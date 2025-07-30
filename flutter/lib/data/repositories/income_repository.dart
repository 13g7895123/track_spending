import '../models/income_model.dart';
import '../services/mock_data_service.dart';

class IncomeRepository {
  final MockDataService _dataService;

  IncomeRepository(this._dataService);

  Future<List<Income>> getIncomes({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _dataService.getIncomes(
        limit: limit,
        offset: offset,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to get incomes: $e');
    }
  }

  Future<Income> createIncome(Income income) async {
    try {
      if (income.amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      if (income.description.trim().isEmpty) {
        throw Exception('Description is required');
      }

      if (income.source.trim().isEmpty) {
        throw Exception('Source is required');
      }

      return await _dataService.createIncome(income);
    } catch (e) {
      throw Exception('Failed to create income: $e');
    }
  }

  Future<Income> updateIncome(Income income) async {
    try {
      if (income.amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      if (income.description.trim().isEmpty) {
        throw Exception('Description is required');
      }

      if (income.source.trim().isEmpty) {
        throw Exception('Source is required');
      }

      return await _dataService.updateIncome(income);
    } catch (e) {
      throw Exception('Failed to update income: $e');
    }
  }

  Future<void> deleteIncome(String incomeId) async {
    try {
      if (incomeId.trim().isEmpty) {
        throw Exception('Income ID is required');
      }

      await _dataService.deleteIncome(incomeId);
    } catch (e) {
      throw Exception('Failed to delete income: $e');
    }
  }

  Future<List<Income>> getIncomesBySource(String source) async {
    try {
      final incomes = await getIncomes();
      return incomes.where((income) => income.source == source).toList();
    } catch (e) {
      throw Exception('Failed to get incomes by source: $e');
    }
  }

  Future<List<Income>> getIncomesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      return await getIncomes(startDate: startDate, endDate: endDate);
    } catch (e) {
      throw Exception('Failed to get incomes by date range: $e');
    }
  }

  Future<double> getTotalIncomesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final incomes = await getIncomesByDateRange(startDate, endDate);
      return incomes.fold(0.0, (total, income) => total + income.amount);
    } catch (e) {
      throw Exception('Failed to calculate total incomes: $e');
    }
  }

  Future<Map<String, double>> getIncomesBySource() async {
    try {
      final incomes = await getIncomes();
      final sourceTotals = <String, double>{};
      
      for (final income in incomes) {
        sourceTotals[income.source] = 
            (sourceTotals[income.source] ?? 0.0) + income.amount;
      }
      
      return sourceTotals;
    } catch (e) {
      throw Exception('Failed to get incomes by source: $e');
    }
  }
}