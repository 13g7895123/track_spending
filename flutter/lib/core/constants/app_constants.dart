class AppConstants {
  // App Info
  static const String appName = '記帳App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstTimeKey = 'first_time';
  
  // Database
  static const String databaseName = 'expense_tracker.db';
  static const int databaseVersion = 1;
  
  // API (Mock for now)
  static const String mockApiDelay = '1000'; // milliseconds
  static const String baseUrl = 'http://localhost:8000/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String userEndpoint = '/user';
  static const String expensesEndpoint = '/expenses';
  static const String incomesEndpoint = '/incomes';
  static const String tagsEndpoint = '/tags';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxDescriptionLength = 200;
  static const int maxTagNameLength = 50;
  static const int minTagNameLength = 2;
  static const int minNameLength = 2;
  static const double maxAmount = 999999999.99;
  static const double minAmount = 0.01;
  
  // Categories
  static const List<String> expenseCategories = [
    'food',
    'transport',
    'utilities',
    'entertainment',
    'shopping',
    'housing',
    'health',
    'education',
    'other',
  ];

  static const List<String> incomeSources = [
    'salary',
    'bonus',
    'investment',
    'freelance',
    'gift',
    'other',
  ];
  
  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation
  static const int animationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Chart settings
  static const int maxChartDataPoints = 12;
  static const double chartAnimationDuration = 1.5;
  
  // Image settings
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  
  // Error messages
  static const String networkError = 'Network error occurred';
  static const String genericError = 'An error occurred';
  static const String authError = 'Authentication failed';
  static const String validationError = 'Validation failed';

  // Success messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logout successful';
  static const String createSuccess = 'Created successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
}