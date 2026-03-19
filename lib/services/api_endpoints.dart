class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String users = '/users';

  // Products
  static const String products = '/products/';
  static String userById(int id) => '/users/$id';
}
