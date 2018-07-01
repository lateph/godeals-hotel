import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inka_msa/pages/report/schedule.model.dart';
import 'package:intl/intl.dart';

class WeightEntryDialog extends StatefulWidget {
  final SearchModel weighEntryToEdit;
  final List<dynamic> listTrainSet;

  WeightEntryDialog.edit(this.weighEntryToEdit, this.listTrainSet);

  @override
  WeightEntryDialogState createState() {
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new WeightEntryDialogState(listTrainSet, weighEntryToEdit.dateFrom, weighEntryToEdit.dateTo, weighEntryToEdit.trainSetId, weighEntryToEdit.status, weighEntryToEdit.action);
  }
}

class WeightEntryDialogState extends State<WeightEntryDialog> {
  DateTime _dateFrom;
  DateTime _dateTo;
  String _trainSetId;
  String _status;
  String _action;
  List<dynamic> _listTrainSet;
  List<dynamic> _listStatus = [
    { 'id': 'C', 'name':'Created' },
    { 'id': 'O', 'name':'On Progress' },
    { 'id': 'D', 'name':'Done' },
  ];

  List<dynamic> _listAction = [
    { 'id': 'running', 'name':'Running' },
    { 'id': 'doNothing', 'name':'Do Nothing' },
    { 'id': 'outstanding', 'name':'Outstanding' },
  ];

  WeightEntryDialogState(this._listTrainSet, this._dateFrom, this._dateTo, this._trainSetId, this._status, this._action);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.weighEntryToEdit == null
          ? const Text("New entry")
          : const Text("Edit entry"),
      actions: [
        new FlatButton(
          onPressed: () {
            Navigator
                .of(context)
                .pop(new SearchModel(_dateFrom, _dateTo, _trainSetId, _status, _action));
          },
          child: new Text('Filter',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _createAppBar(context),
        body: new DropdownButtonHideUnderline(
          child: new SafeArea(
            top: false,
            bottom: false,
            child: new ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                new _DateTimePicker(
                  labelText: 'From',
                  selectedDate:_dateFrom,
                  selectDate: (DateTime date) {
                    setState(() {
                      _dateFrom = date;
                    });
                  },
                ),
                new _DateTimePicker(
                  labelText: 'To',
                  selectedDate: _dateTo,
                  selectDate: (DateTime date) {
                    setState(() {
                      _dateTo = date;
                    });
                  },
                ),
                new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Train Set',
                    hintText: 'Choose Train Set',
                  ),
                  isEmpty: _trainSetId == null,
                  child: new DropdownButton<String>(
                    value: _trainSetId,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _trainSetId = newValue;
                      });
                    },
                    items: (_listTrainSet.map((value) => new DropdownMenuItem<String>(
                      value: value['train_set_id'].toString(),
                      child: new Text(value['train_set_name'].toString()),
                    )).toList()..insert(0, new DropdownMenuItem<String>(
                        value: '',
                        child: new Text('- Choose Train Set -')
                    ),
                    )),
                  ),
                ),
                new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    hintText: 'Choose Status',
                  ),
                  isEmpty: _status == null,
                  child: new DropdownButton<String>(
                    value: _status,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _status = newValue;
                      });
                    },
                    items: (_listStatus.map((value) => new DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: new Text(value['name'].toString()),
                    )).toList()..insert(0, new DropdownMenuItem<String>(
                        value: '',
                        child: new Text('- All -')
                    ),
                    )),
                  ),
                ),
                new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Action',
                    hintText: 'Choose Action',
                  ),
                  isEmpty: _action == null,
                  child: new DropdownButton<String>(
                    value: _action,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _action = newValue;
                      });
                    },
                    items: (_listAction.map((value) => new DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: new Text(value['name'].toString()),
                    )).toList()..insert(0, new DropdownMenuItem<String>(
                        value: '',
                        child: new Text('- All -')
                    ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}
