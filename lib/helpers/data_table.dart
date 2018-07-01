import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyDataTable extends StatelessWidget {
  /// Creates a widget describing a data table.
  ///
  /// The [columns] argument must be a list of as many [DataColumn]
  /// objects as the table is to have columns, ignoring the leading
  /// checkbox column if any. The [columns] argument must have a
  /// length greater than zero and must not be null.
  ///
  /// The [rows] argument must be a list of as many [DataRow] objects
  /// as the table is to have rows, ignoring the leading heading row
  /// that contains the column headings (derived from the [columns]
  /// argument). There may be zero rows, but the rows argument must
  /// not be null.
  ///
  /// Each [DataRow] object in [rows] must have as many [DataCell]
  /// objects in the [DataRow.cells] list as the table has columns.
  ///
  /// If the table is sorted, the column that provides the current
  /// primary key should be specified by index in [sortColumnIndex], 0
  /// meaning the first column in [columns], 1 being the next one, and
  /// so forth.
  ///
  /// The actual sort order can be specified using [sortAscending]; if
  /// the sort order is ascending, this should be true (the default),
  /// otherwise it should be false.
  MyDataTable({
    Key key,
    this.columns,
    this.sortColumnIndex,
    this.sortAscending: true,
    this.onSelectAll,
    this.rows,
  }) : assert(columns != null),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(sortAscending != null),
        assert(rows != null),
        assert(!rows.any((DataRow row) => row.cells.length != columns.length)),
        _onlyTextColumn = _initOnlyTextColumn(columns),
        super(key: key);

  /// The configuration and labels for the columns in the table.
  final List<DataColumn> columns;

  /// The current primary sort key's column.
  ///
  /// If non-null, indicates that the indicated column is the column
  /// by which the data is sorted. The number must correspond to the
  /// index of the relevant column in [columns].
  ///
  /// Setting this will cause the relevant column to have a sort
  /// indicator displayed.
  ///
  /// When this is null, it implies that the table's sort order does
  /// not correspond to any of the columns.
  final int sortColumnIndex;

  /// Whether the column mentioned in [sortColumnIndex], if any, is sorted
  /// in ascending order.
  ///
  /// If true, the order is ascending (meaning the rows with the
  /// smallest values for the current sort column are first in the
  /// table).
  ///
  /// If false, the order is descending (meaning the rows with the
  /// smallest values for the current sort column are last in the
  /// table).
  final bool sortAscending;

  /// Invoked when the user selects or unselects every row, using the
  /// checkbox in the heading row.
  ///
  /// If this is null, then the [DataRow.onSelectChanged] callback of
  /// every row in the table is invoked appropriately instead.
  ///
  /// To control whether a particular row is selectable or not, see
  /// [DataRow.onSelectChanged]. This callback is only relevant if any
  /// row is selectable.
  final ValueSetter<bool> onSelectAll;

  /// The data to show in each row (excluding the row that contains
  /// the column headings). Must be non-null, but may be empty.
  final List<DataRow> rows;

  // Set by the constructor to the index of the only Column that is
  // non-numeric, if there is exactly one, otherwise null.
  final int _onlyTextColumn;
  static int _initOnlyTextColumn(List<DataColumn> columns) {
    int result;
    for (int index = 0; index < columns.length; index += 1) {
      final DataColumn column = columns[index];
      if (!column.numeric) {
        if (result != null)
          return null;
        result = index;
      }
    }
    return result;
  }

  bool get _debugInteractive {
    return true;
  }

  static final LocalKey _headingRowKey = new UniqueKey();

  void _handleSelectAll(bool checked) {
    if (onSelectAll != null) {
      onSelectAll(checked);
    } else {
      for (DataRow row in rows) {
        if ((row.onSelectChanged != null) && (row.selected != checked))
          row.onSelectChanged(checked);
      }
    }
  }

  static const double _kHeadingRowHeight = 56.0;
  final double kDataRowHeight = 48.0;
  static const double _kTablePadding = 24.0;
  static const double _kColumnSpacing = 56.0;
  static const double _kSortArrowPadding = 2.0;
  static const double _kHeadingFontSize = 12.0;
  static const Duration _kSortArrowAnimationDuration = const Duration(milliseconds: 150);
  static const Color _kGrey100Opacity = const Color(0x0A000000); // Grey 100 as opacity instead of solid color
  static const Color _kGrey300Opacity = const Color(0x1E000000); // Dark theme variant is just a guess.

  Widget _buildCheckbox({
    Color color,
    bool checked,
    VoidCallback onRowTap,
    ValueChanged<bool> onCheckboxChanged
  }) {
    Widget contents = new Padding(
      padding: const EdgeInsetsDirectional.only(start: _kTablePadding, end: _kTablePadding / 2.0),
      child: new Center(
        child: new Checkbox(
          activeColor: color,
          value: checked,
          onChanged: onCheckboxChanged,
        ),
      ),
    );
    if (onRowTap != null) {
      contents = new TableRowInkWell(
        onTap: onRowTap,
        child: contents,
      );
    }
    return new TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: contents,
    );
  }

  Widget _buildHeadingCell({
    BuildContext context,
    EdgeInsetsGeometry padding,
    Widget label,
    String tooltip,
    bool numeric,
    VoidCallback onSort,
    bool sorted,
    bool ascending,
  }) {
    if (onSort != null) {
      final Widget arrow = new _SortArrow(
        visible: sorted,
        down: sorted ? ascending : null,
        duration: _kSortArrowAnimationDuration,
      );
      const Widget arrowPadding = const SizedBox(width: _kSortArrowPadding);
      label = new Row(
        textDirection: numeric ? TextDirection.rtl : null,
        children: <Widget>[ label, arrowPadding, arrow ],
      );
    }
    label = new Container(
      padding: padding,
      height: _kHeadingRowHeight,
      alignment: numeric ? Alignment.centerRight : AlignmentDirectional.centerStart,
      child: new AnimatedDefaultTextStyle(
        style: new TextStyle(
          // TODO(ianh): font family should match Theme; see https://github.com/flutter/flutter/issues/3116
          fontWeight: FontWeight.w500,
          fontSize: _kHeadingFontSize,
          height: math.min(1.0, _kHeadingRowHeight / _kHeadingFontSize),
          color: (Theme.of(context).brightness == Brightness.light)
              ? ((onSort != null && sorted) ? Colors.black87 : Colors.black54)
              : ((onSort != null && sorted) ? Colors.white : Colors.white70),
        ),
        softWrap: false,
        duration: _kSortArrowAnimationDuration,
        child: label,
      ),
    );
    if (tooltip != null) {
      label = new Tooltip(
        message: tooltip,
        child: label,
      );
    }
    if (onSort != null) {
      label = new InkWell(
        onTap: onSort,
        child: label,
      );
    }
    return label;
  }

  Widget _buildDataCell({
    BuildContext context,
    EdgeInsetsGeometry padding,
    Widget label,
    bool numeric,
    bool placeholder,
    bool showEditIcon,
    VoidCallback onTap,
    VoidCallback onSelectChanged,
  }) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    if (showEditIcon) {
      const Widget icon = const Icon(Icons.edit, size: 18.0);
      label = new Expanded(child: label);
      label = new Row(
        textDirection: numeric ? TextDirection.rtl : null,
        children: <Widget>[ label, icon ],
      );
    }
    label = new Container(
//        padding: padding,
//        height: kDataRowHeight,
        alignment: numeric ? Alignment.centerRight : AlignmentDirectional.centerStart,
        child: new DefaultTextStyle(
            style: new TextStyle(
              // TODO(ianh): font family should be Roboto; see https://github.com/flutter/flutter/issues/3116
              fontSize: 13.0,
              color: isLightTheme
                  ? (placeholder ? Colors.black38 : Colors.black87)
                  : (placeholder ? Colors.white30 : Colors.white70),
            ),
            child: IconTheme.merge(
              data: new IconThemeData(
                color: isLightTheme ? Colors.black54 : Colors.white70,
              ),
              child: new DropdownButtonHideUnderline(child: label),
            )
        )
    );
    if (onTap != null) {
      label = new InkWell(
        onTap: onTap,
        child: label,
      );
    } else if (onSelectChanged != null) {
      label = new TableRowInkWell(
        onTap: onSelectChanged,
        child: label,
      );
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    assert(!_debugInteractive || debugCheckHasMaterial(context));

    final ThemeData theme = Theme.of(context);
    final BoxDecoration _kSelectedDecoration = new BoxDecoration(
      border: new Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      // The backgroundColor has to be transparent so you can see the ink on the material
      color: (Theme.of(context).brightness == Brightness.light) ? _kGrey100Opacity : _kGrey300Opacity,
    );
    final BoxDecoration _kUnselectedDecoration = new BoxDecoration(
      border: new Border(bottom: Divider.createBorderSide(context, width: 1.0)),
    );

    final bool showCheckboxColumn = false;
    final bool allChecked = showCheckboxColumn && !rows.any((DataRow row) => row.onSelectChanged != null && !row.selected);

    final List<TableColumnWidth> tableColumns = new List<TableColumnWidth>(columns.length + (showCheckboxColumn ? 1 : 0));
    final List<TableRow> tableRows = new List<TableRow>.generate(
      rows.length, // the +1 is for the header row
          (int index) {
        return new TableRow(
            key: rows[index].key,
//            decoration: index > 0 && rows[index - 1].selected ? _kSelectedDecoration
//                : _kUnselectedDecoration,
            children: new List<Widget>(tableColumns.length)
        );
      },
    );

    int rowIndex;

    int displayColumnIndex = 0;

    for (int dataColumnIndex = 0; dataColumnIndex < columns.length; dataColumnIndex += 1) {
      final DataColumn column = columns[dataColumnIndex];
      final EdgeInsetsDirectional padding = new EdgeInsetsDirectional.only(
        start: dataColumnIndex == 0 ? showCheckboxColumn ? _kTablePadding / 2.0 : _kTablePadding : _kColumnSpacing / 2.0,
        end: dataColumnIndex == columns.length - 1 ? _kTablePadding : _kColumnSpacing / 2.0,
      );
      if (dataColumnIndex == _onlyTextColumn) {
        tableColumns[displayColumnIndex] = const IntrinsicColumnWidth(flex: 1.0);
      } else {
        tableColumns[displayColumnIndex] = const IntrinsicColumnWidth();
      }
      rowIndex = 0;
      for (DataRow row in rows) {
        final DataCell cell = row.cells[dataColumnIndex];
        tableRows[rowIndex].children[displayColumnIndex] = _buildDataCell(
          context: context,
          padding: padding,
          label: cell.child,
          numeric: column.numeric,
          placeholder: cell.placeholder,
          showEditIcon: cell.showEditIcon,
          onTap: cell.onTap,
//          onSelectChanged: () => row.onSelectChanged(!row.selected),
        );
        rowIndex += 1;
      }
      displayColumnIndex += 1;
    }

    return new Table(
      columnWidths: tableColumns.asMap(),
      children: tableRows,
    );
  }
}

class _SortArrow extends StatefulWidget {
  const _SortArrow({
    Key key,
    this.visible,
    this.down,
    this.duration,
  }) : super(key: key);

  final bool visible;

  final bool down;

  final Duration duration;

  @override
  _SortArrowState createState() => new _SortArrowState();
}

class _SortArrowState extends State<_SortArrow> with TickerProviderStateMixin {

  AnimationController _opacityController;
  Animation<double> _opacityAnimation;

  AnimationController _orientationController;
  Animation<double> _orientationAnimation;
  double _orientationOffset = 0.0;

  bool _down;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = new CurvedAnimation(
        parent: _opacityController = new AnimationController(
          duration: widget.duration,
          vsync: this,
        ),
        curve: Curves.fastOutSlowIn
    )
      ..addListener(_rebuild);
    _opacityController.value = widget.visible ? 1.0 : 0.0;
    _orientationAnimation = new Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(new CurvedAnimation(
        parent: _orientationController = new AnimationController(
          duration: widget.duration,
          vsync: this,
        ),
        curve: Curves.easeIn
    ))
      ..addListener(_rebuild)
      ..addStatusListener(_resetOrientationAnimation);
    if (widget.visible)
      _orientationOffset = widget.down ? 0.0 : math.pi;
  }

  void _rebuild() {
    setState(() {
      // The animations changed, so we need to rebuild.
    });
  }

  void _resetOrientationAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      assert(_orientationAnimation.value == math.pi);
      _orientationOffset += math.pi;
      _orientationController.value = 0.0; // TODO(ianh): This triggers a pointless rebuild.
    }
  }

  @override
  void didUpdateWidget(_SortArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool skipArrow = false;
    final bool newDown = widget.down != null ? widget.down : _down;
    if (oldWidget.visible != widget.visible) {
      if (widget.visible && (_opacityController.status == AnimationStatus.dismissed)) {
        _orientationController.stop();
        _orientationController.value = 0.0;
        _orientationOffset = newDown ? 0.0 : math.pi;
        skipArrow = true;
      }
      if (widget.visible) {
        _opacityController.forward();
      } else {
        _opacityController.reverse();
      }
    }
    if ((_down != newDown) && !skipArrow) {
      if (_orientationController.status == AnimationStatus.dismissed) {
        _orientationController.forward();
      } else {
        _orientationController.reverse();
      }
    }
    _down = newDown;
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _orientationController.dispose();
    super.dispose();
  }

  static const double _kArrowIconBaselineOffset = -1.5;
  static const double _kArrowIconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: _opacityAnimation.value,
      child: new Transform(
        transform: new Matrix4.rotationZ(_orientationOffset + _orientationAnimation.value)
          ..setTranslationRaw(0.0, _kArrowIconBaselineOffset, 0.0),
        alignment: Alignment.center,
        child: new Icon(
          Icons.arrow_downward,
          size: _kArrowIconSize,
          color: (Theme.of(context).brightness == Brightness.light) ? Colors.black87 : Colors.white70,
        ),
      ),
    );
  }

}