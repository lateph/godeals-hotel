enum ApiRoute {
  authRegister,
  authLogin,
  authLogout,
  authForgotPassword,
  authResetPassword,
  authVerifyUser,
  authChangePhoneNumber,
  authVerifyDevice,
  trainAvailbility,
  trainReliability,
  trainSet,
  editProfile,
  editPassword,
  schedule,
  scheduleFirst,
  componentStock,
  locations
}

class Api {
  static const Map<ApiRoute, String> routes = {
    ApiRoute.authRegister: '/auth/register',
    ApiRoute.authLogin: '/login',
    ApiRoute.authLogout: '/logout',
    ApiRoute.authForgotPassword: '/auth/forgot-password',
    ApiRoute.authResetPassword: '/auth/reset-password',
    ApiRoute.authVerifyUser: '/auth/verify-user',
    ApiRoute.authChangePhoneNumber: '/auth/change-phone-number',
    ApiRoute.authVerifyDevice: '/auth/verify-device',
    ApiRoute.trainAvailbility: '/report/train-set-availability',
    ApiRoute.trainReliability: '/report/train-set-reliability',
    ApiRoute.trainSet: '/master/train-set?page=all',
    ApiRoute.editProfile: '/account/edit-profile',
    ApiRoute.editPassword: '/account/change-password',
    ApiRoute.schedule: '/report/maintenance-schedule',
    ApiRoute.scheduleFirst: '/report/scheduled-train-set',
    ApiRoute.componentStock: '/report/component-stock',
    ApiRoute.locations: '/master/location?page=all',
  };
}
