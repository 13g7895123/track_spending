import '../models/expense_model.dart';
import '../services/mock_data_service.dart';

class ExpenseRepository {
  final MockDataService _dataService;

  ExpenseRepository(this._dataService);

  Future<List<Expense>> getExpenses({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _dataService.getExpenses(
        limit: limit,
        offset: offset,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  Future<Expense> createExpense(Expense expense) async {
    try {
      if (expense.amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      if (expense.description.trim().isEmpty) {
        throw Exception('Description is required');
      }

      if (expense.category.trim().isEmpty) {
        throw Exception('Category is required');
      }

      return await _dataService.createExpense(expense);
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  Future<Expense> updateExpense(Expense expense) async {
    try {
      if (expense.amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      if (expense.description.trim().isEmpty) {
        throw Exception('Description is required');
      }

      if (expense.category.trim().isEmpty) {
        throw Exception('Category is required');
      }

      return await _dataService.updateExpense(expense);
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      if (expenseId.trim().isEmpty) {
        throw Exception('Expense ID is required');
      }

      await _dataService.deleteExpense(expenseId);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  Future<List<Expense>> getExpensesByCategory(String category) async {
    try {
      final expenses = await getExpenses();
      return expenses.where((expense) => expense.category == category).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by category: $e');
    }
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      return await getExpenses(startDate: startDate, endDate: endDate);
    } catch (e) {
      throw Exception('Failed to get expenses by date range: $e');
    }
  }

  Future<double> getTotalExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final expenses = await getExpensesByDateRange(startDate, endDate);
      return expenses.fold(0.0, (total, expense) => total + expense.amount);
    } catch (e) {
      throw Exception('Failed to calculate total expenses: $e');
    }
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    try {
      final expenses = await getExpenses();
      final categoryTotals = <String, double>{};
      
      for (final expense in expenses) {
        categoryTotals[expense.category] = 
            (categoryTotals[expense.category] ?? 0.0) + expense.amount;
      }
      
      return categoryTotals;
    } catch (e) {
      throw Exception('Failed to get expenses by category: $e');
    }
  }
}