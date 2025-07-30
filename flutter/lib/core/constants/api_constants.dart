class ApiConstants {
  // Base URL (將來整合時使用)
  static const String baseUrl = 'https://yourdomain.com/api';
  
  // Auth Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String profileEndpoint = '/auth/profile';
  
  // Expense Endpoints
  static const String expensesEndpoint = '/expenses';
  static const String expenseStatsEndpoint = '/expenses/stats';
  
  // Income Endpoints
  static const String incomeEndpoint = '/income';
  static const String incomeStatsEndpoint = '/income/stats';
  
  // Tag Endpoints
  static const String tagsEndpoint = '/tags';
  
  // Share Endpoints
  static const String shareTagEndpoint = '/share/tag';
  static const String sharedRecordsEndpoint = '/share/received';
  
  // File Upload
  static const String uploadEndpoint = '/upload';
  
  // HTTP Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  
  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';
  
  // Response Status
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int validationErrorCode = 422;
  static const int serverErrorCode = 500;
  
  // Request Timeout
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}