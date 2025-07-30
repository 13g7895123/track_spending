import 'package:flutter/material.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/expense_repository.dart';
import './auth_provider.dart';

enum ExpenseStatus {
  initial,
  loading,
  loaded,
  error,
}

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final AuthProvider _authProvider;

  ExpenseProvider({
    required ExpenseRepository expenseRepository,
    required AuthProvider authProvider,
  }) : _expenseRepository = expenseRepository,
       _authProvider = authProvider;

  ExpenseStatus _status = ExpenseStatus.initial;
  List<Expense> _expenses = [];
  String? _errorMessage;
  bool _hasMore = true;
  int _currentOffset = 0;
  static const int _pageSize = 20;

  ExpenseStatus get status => _status;
  List<Expense> get expenses => _expenses;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == ExpenseStatus.loading;
  bool get isLoaded => _status == ExpenseStatus.loaded;

  Future<void> loadExpenses({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasMore = true;
      _expenses.clear();
    }

    if (!_hasMore && !refresh) return;

    _setStatus(ExpenseStatus.loading);

    try {
      final newExpenses = await _expenseRepository.getExpenses(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (refresh) {
        _expenses = newExpenses;
      } else {
        _expenses.addAll(newExpenses);
      }

      _hasMore = newExpenses.length == _pageSize;
      _currentOffset += newExpenses.length;
      
      _setStatus(ExpenseStatus.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    _setStatus(ExpenseStatus.loading);

    try {
      _expenses = await _expenseRepository.getExpensesByDateRange(startDate, endDate);
      _setStatus(ExpenseStatus.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> createExpense(Expense expense) async {
    try {
      final newExpense = await _expenseRepository.createExpense(expense);
      _expenses.insert(0, newExpense);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      final updatedExpense = await _expenseRepository.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseRepository.deleteExpense(expenseId);
      _expenses.removeWhere((expense) => expense.id == expenseId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    try {
      return await _expenseRepository.getExpensesByCategory();
    } catch (e) {
      _setError(e.toString());
      return {};
    }
  }

  Future<double> getTotalExpenses({DateTime? startDate, DateTime? endDate}) async {
    try {
      if (startDate != null && endDate != null) {
        return await _expenseRepository.getTotalExpensesByDateRange(startDate, endDate);
      } else {
        return _expenses.fold(0.0, (total, expense) => total + expense.amount);
      }
    } catch (e) {
      _setError(e.toString());
      return 0.0;
    }
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  List<Expense> getExpensesForToday() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    return _expenses.where((expense) => 
      expense.date.isAfter(startOfDay) && expense.date.isBefore(endOfDay)
    ).toList();
  }

  List<Expense> getExpensesForCurrentMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    return _expenses.where((expense) => 
      expense.date.isAfter(startOfMonth) && expense.date.isBefore(endOfMonth)
    ).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(ExpenseStatus status) {
    _status = status;
    if (status != ExpenseStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _status = ExpenseStatus.error;
    notifyListeners();
  }
}