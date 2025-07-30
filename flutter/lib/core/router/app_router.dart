import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/expenses/expense_list_screen.dart';
import '../../presentation/screens/expenses/add_expense_screen.dart';
import '../../presentation/screens/expenses/edit_expense_screen.dart';
import '../../presentation/screens/incomes/income_list_screen.dart';
import '../../presentation/screens/incomes/add_income_screen.dart';
import '../../presentation/screens/incomes/edit_income_screen.dart';
import '../../presentation/screens/tags/tag_list_screen.dart';
import '../../presentation/screens/tags/add_tag_screen.dart';
import '../../presentation/screens/tags/edit_tag_screen.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String expenses = '/expenses';
  static const String addExpense = '/expenses/add';
  static const String editExpense = '/expenses/edit';
  static const String incomes = '/incomes';
  static const String addIncome = '/incomes/add';
  static const String editIncome = '/incomes/edit';
  static const String tags = '/tags';
  static const String addTag = '/tags/add';
  static const String editTag = '/tags/edit';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      redirect: (BuildContext context, GoRouterState state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final location = state.matchedLocation;

        // If user is on splash screen, let them through
        if (location == splash) {
          return null;
        }

        // If authentication is still loading, stay on splash
        if (authProvider.status == AuthStatus.loading) {
          return splash;
        }

        // If user is not authenticated and trying to access protected routes
        if (!authProvider.isAuthenticated) {
          if (location != login && location != register) {
            return login;
          }
        }

        // If user is authenticated and trying to access auth screens
        if (authProvider.isAuthenticated) {
          if (location == login || location == register || location == splash) {
            return home;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: expenses,
          name: 'expenses',
          builder: (context, state) => const ExpenseListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'add-expense',
              builder: (context, state) => const AddExpenseScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              name: 'edit-expense',
              builder: (context, state) {
                final expenseId = state.pathParameters['id']!;
                return EditExpenseScreen(expenseId: expenseId);
              },
            ),
          ],
        ),
        GoRoute(
          path: incomes,
          name: 'incomes',
          builder: (context, state) => const IncomeListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'add-income',
              builder: (context, state) => const AddIncomeScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              name: 'edit-income',
              builder: (context, state) {
                final incomeId = state.pathParameters['id']!;
                return EditIncomeScreen(incomeId: incomeId);
              },
            ),
          ],
        ),
        GoRoute(
          path: tags,
          name: 'tags',
          builder: (context, state) => const TagListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'add-tag',
              builder: (context, state) => const AddTagScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              name: 'edit-tag',
              builder: (context, state) {
                final tagId = state.pathParameters['id']!;
                return EditTagScreen(tagId: tagId);
              },
            ),
          ],
        ),
        GoRoute(
          path: analytics,
          name: 'analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}