import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/mock_data_service.dart';
import 'data/repositories/expense_repository.dart';
import 'data/repositories/income_repository.dart';
import 'data/repositories/tag_repository.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/providers/income_provider.dart';
import 'presentation/providers/tag_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地儲存
  final sharedPreferences = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(sharedPreferences);
  
  // 初始化模擬資料服務
  final mockDataService = MockDataService();
  
  // 初始化Repository
  final userRepository = UserRepository(mockDataService);
  final expenseRepository = ExpenseRepository(mockDataService);
  final incomeRepository = IncomeRepository(mockDataService);
  final tagRepository = TagRepository(mockDataService);
  
  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<LocalStorageService>.value(value: localStorageService),
        Provider<MockDataService>.value(value: mockDataService),
        
        // Repositories
        Provider<UserRepository>.value(value: userRepository),
        Provider<ExpenseRepository>.value(value: expenseRepository),
        Provider<IncomeRepository>.value(value: incomeRepository),
        Provider<TagRepository>.value(value: tagRepository),
        
        // Providers
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(localStorageService),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            userRepository: context.read<UserRepository>(),
            localStorageService: localStorageService,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ExpenseProvider>(
          create: (context) => ExpenseProvider(
            expenseRepository: context.read<ExpenseRepository>(),
            authProvider: context.read<AuthProvider>(),
          ),
          update: (context, authProvider, previous) => previous ?? ExpenseProvider(
            expenseRepository: context.read<ExpenseRepository>(),
            authProvider: authProvider,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, IncomeProvider>(
          create: (context) => IncomeProvider(
            incomeRepository: context.read<IncomeRepository>(),
            authProvider: context.read<AuthProvider>(),
          ),
          update: (context, authProvider, previous) => previous ?? IncomeProvider(
            incomeRepository: context.read<IncomeRepository>(),
            authProvider: authProvider,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TagProvider>(
          create: (context) => TagProvider(
            tagRepository: context.read<TagRepository>(),
            authProvider: context.read<AuthProvider>(),
          ),
          update: (context, authProvider, previous) => previous ?? TagProvider(
            tagRepository: context.read<TagRepository>(),
            authProvider: authProvider,
          ),
        ),
      ],
      child: const ExpenseTrackerApp(),
    ),
  );
}