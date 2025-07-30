import 'package:flutter/material.dart';
import '../../data/models/income_model.dart';
import '../../data/repositories/income_repository.dart';
import './auth_provider.dart';

enum IncomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class IncomeProvider with ChangeNotifier {
  final IncomeRepository _incomeRepository;
  final AuthProvider _authProvider;

  IncomeProvider({
    required IncomeRepository incomeRepository,
    required AuthProvider authProvider,
  }) : _incomeRepository = incomeRepository,
       _authProvider = authProvider;

  IncomeStatus _status = IncomeStatus.initial;
  List<Income> _incomes = [];
  String? _errorMessage;
  bool _hasMore = true;
  int _currentOffset = 0;
  static const int _pageSize = 20;

  IncomeStatus get status => _status;
  List<Income> get incomes => _incomes;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == IncomeStatus.loading;
  bool get isLoaded => _status == IncomeStatus.loaded;

  Future<void> loadIncomes({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasMore = true;
      _incomes.clear();
    }

    if (!_hasMore && !refresh) return;

    _setStatus(IncomeStatus.loading);

    try {
      final newIncomes = await _incomeRepository.getIncomes(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (refresh) {
        _incomes = newIncomes;
      } else {
        _incomes.addAll(newIncomes);
      }

      _hasMore = newIncomes.length == _pageSize;
      _currentOffset += newIncomes.length;
      
      _setStatus(IncomeStatus.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadIncomesByDateRange(DateTime startDate, DateTime endDate) async {
    _setStatus(IncomeStatus.loading);

    try {
      _incomes = await _incomeRepository.getIncomesByDateRange(startDate, endDate);
      _setStatus(IncomeStatus.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> createIncome(Income income) async {
    try {
      final newIncome = await _incomeRepository.createIncome(income);
      _incomes.insert(0, newIncome);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateIncome(Income income) async {
    try {
      final updatedIncome = await _incomeRepository.updateIncome(income);
      final index = _incomes.indexWhere((i) => i.id == income.id);
      if (index != -1) {
        _incomes[index] = updatedIncome;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteIncome(String incomeId) async {
    try {
      await _incomeRepository.deleteIncome(incomeId);
      _incomes.removeWhere((income) => income.id == incomeId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<Map<String, double>> getIncomesBySource() async {
    try {
      return await _incomeRepository.getIncomesBySource();
    } catch (e) {
      _setError(e.toString());
      return {};
    }
  }

  Future<double> getTotalIncomes({DateTime? startDate, DateTime? endDate}) async {
    try {
      if (startDate != null && endDate != null) {
        return await _incomeRepository.getTotalIncomesByDateRange(startDate, endDate);
      } else {
        return _incomes.fold(0.0, (total, income) => total + income.amount);
      }
    } catch (e) {
      _setError(e.toString());
      return 0.0;
    }
  }

  List<Income> getIncomesBySource(String source) {
    return _incomes.where((income) => income.source == source).toList();
  }

  List<Income> getIncomesForToday() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    return _incomes.where((income) => 
      income.date.isAfter(startOfDay) && income.date.isBefore(endOfDay)
    ).toList();
  }

  List<Income> getIncomesForCurrentMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    return _incomes.where((income) => 
      income.date.isAfter(startOfMonth) && income.date.isBefore(endOfMonth)
    ).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(IncomeStatus status) {
    _status = status;
    if (status != IncomeStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _status = IncomeStatus.error;
    notifyListeners();
  }
}