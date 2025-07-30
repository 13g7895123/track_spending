import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';
import '../models/tag_model.dart';
import '../../core/theme/app_colors.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _initializeMockData();
  }

  // Mock data storage
  final List<User> _users = [];
  final List<Expense> _expenses = [];
  final List<Income> _incomes = [];
  final List<Tag> _tags = [];

  // Current user (for demo purposes)
  String? _currentUserId;

  void _initializeMockData() {
    _initializeUsers();
    _initializeTags();
    _initializeExpenses();
    _initializeIncomes();
    
    // Set default current user
    if (_users.isNotEmpty) {
      _currentUserId = _users.first.id;
    }
  }

  void _initializeUsers() {
    final now = DateTime.now();
    _users.addAll([
      User(
        id: 'user_1',
        email: 'demo@example.com',
        name: '示範用戶',
        avatarUrl: null,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ]);
  }

  void _initializeTags() {
    final now = DateTime.now();
    final userId = 'user_1';
    
    final tagData = [
      {'name': '日常', 'color': AppColors.tagColors[0]},
      {'name': '工作', 'color': AppColors.tagColors[1]},
      {'name': '家庭', 'color': AppColors.tagColors[2]},
      {'name': '旅行', 'color': AppColors.tagColors[3]},
      {'name': '學習', 'color': AppColors.tagColors[4]},
      {'name': '健康', 'color': AppColors.tagColors[5]},
      {'name': '投資', 'color': AppColors.tagColors[6]},
      {'name': '娛樂', 'color': AppColors.tagColors[7]},
    ];

    for (int i = 0; i < tagData.length; i++) {
      _tags.add(Tag(
        id: 'tag_${i + 1}',
        name: tagData[i]['name'] as String,
        color: tagData[i]['color'] as Color,
        userId: userId,
        createdAt: now.subtract(Duration(days: 20 - i)),
        updatedAt: now.subtract(Duration(days: 10 - i)),
      ));
    }
  }

  void _initializeExpenses() {
    final now = DateTime.now();
    final userId = 'user_1';
    final random = Random();

    final expenseData = [
      {'amount': 350.0, 'description': '午餐便當', 'category': 'food'},
      {'amount': 1200.0, 'description': '加油費', 'category': 'transport'},
      {'amount': 280.0, 'description': '咖啡', 'category': 'food'},
      {'amount': 5000.0, 'description': '電費', 'category': 'utilities'},
      {'amount': 2500.0, 'description': '電影票', 'category': 'entertainment'},
      {'amount': 8900.0, 'description': '日用品採購', 'category': 'shopping'},
      {'amount': 15000.0, 'description': '房租', 'category': 'housing'},
      {'amount': 3200.0, 'description': '看醫生', 'category': 'health'},
      {'amount': 1800.0, 'description': '書籍', 'category': 'education'},
      {'amount': 450.0, 'description': '晚餐', 'category': 'food'},
    ];

    for (int i = 0; i < expenseData.length; i++) {
      final data = expenseData[i];
      final selectedTags = _getRandomTags(random.nextInt(3) + 1);
      
      _expenses.add(Expense(
        id: 'expense_${i + 1}',
        userId: userId,
        amount: data['amount'] as double,
        description: data['description'] as String,
        category: data['category'] as String,
        date: now.subtract(Duration(days: random.nextInt(30))),
        receiptImageUrl: null,
        tags: selectedTags,
        createdAt: now.subtract(Duration(days: 25 - i)),
        updatedAt: now.subtract(Duration(days: 15 - i)),
      ));
    }
  }

  void _initializeIncomes() {
    final now = DateTime.now();
    final userId = 'user_1';
    final random = Random();

    final incomeData = [
      {'amount': 50000.0, 'description': '月薪', 'source': 'salary'},
      {'amount': 8000.0, 'description': '年終獎金', 'source': 'bonus'},
      {'amount': 3500.0, 'description': '股票收益', 'source': 'investment'},
      {'amount': 12000.0, 'description': '接案收入', 'source': 'freelance'},
      {'amount': 2000.0, 'description': '紅包', 'source': 'gift'},
    ];

    for (int i = 0; i < incomeData.length; i++) {
      final data = incomeData[i];
      final selectedTags = _getRandomTags(random.nextInt(2) + 1);
      
      _incomes.add(Income(
        id: 'income_${i + 1}',
        userId: userId,
        amount: data['amount'] as double,
        description: data['description'] as String,
        source: data['source'] as String,
        date: now.subtract(Duration(days: random.nextInt(30))),
        tags: selectedTags,
        createdAt: now.subtract(Duration(days: 25 - i)),
        updatedAt: now.subtract(Duration(days: 15 - i)),
      ));
    }
  }

  List<Tag> _getRandomTags(int count) {
    final random = Random();
    final availableTags = List<Tag>.from(_tags);
    final selectedTags = <Tag>[];

    for (int i = 0; i < count && availableTags.isNotEmpty; i++) {
      final randomIndex = random.nextInt(availableTags.length);
      selectedTags.add(availableTags.removeAt(randomIndex));
    }

    return selectedTags;
  }

  // User methods
  Future<User?> getCurrentUser() async {
    await _simulateDelay();
    if (_currentUserId != null) {
      return _users.firstWhere((user) => user.id == _currentUserId);
    }
    return null;
  }

  Future<User?> loginUser(String email, String password) async {
    await _simulateDelay();
    final user = _users.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('User not found'),
    );
    _currentUserId = user.id;
    return user;
  }

  Future<void> logoutUser() async {
    await _simulateDelay();
    _currentUserId = null;
  }

  // Expense methods
  Future<List<Expense>> getExpenses({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _simulateDelay();
    var expenses = _expenses.where((expense) => expense.userId == _currentUserId).toList();
    
    if (startDate != null) {
      expenses = expenses.where((expense) => expense.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
    }
    
    if (endDate != null) {
      expenses = expenses.where((expense) => expense.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
    }
    
    expenses.sort((a, b) => b.date.compareTo(a.date));
    
    if (offset != null) {
      expenses = expenses.skip(offset).toList();
    }
    
    if (limit != null) {
      expenses = expenses.take(limit).toList();
    }
    
    return expenses;
  }

  Future<Expense> createExpense(Expense expense) async {
    await _simulateDelay();
    final newExpense = expense.copyWith(
      id: 'expense_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUserId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _expenses.add(newExpense);
    return newExpense;
  }

  Future<Expense> updateExpense(Expense expense) async {
    await _simulateDelay();
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      final updatedExpense = expense.copyWith(updatedAt: DateTime.now());
      _expenses[index] = updatedExpense;
      return updatedExpense;
    }
    throw Exception('Expense not found');
  }

  Future<void> deleteExpense(String expenseId) async {
    await _simulateDelay();
    _expenses.removeWhere((expense) => expense.id == expenseId);
  }

  // Income methods
  Future<List<Income>> getIncomes({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _simulateDelay();
    var incomes = _incomes.where((income) => income.userId == _currentUserId).toList();
    
    if (startDate != null) {
      incomes = incomes.where((income) => income.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
    }
    
    if (endDate != null) {
      incomes = incomes.where((income) => income.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
    }
    
    incomes.sort((a, b) => b.date.compareTo(a.date));
    
    if (offset != null) {
      incomes = incomes.skip(offset).toList();
    }
    
    if (limit != null) {
      incomes = incomes.take(limit).toList();
    }
    
    return incomes;
  }

  Future<Income> createIncome(Income income) async {
    await _simulateDelay();
    final newIncome = income.copyWith(
      id: 'income_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUserId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _incomes.add(newIncome);
    return newIncome;
  }

  Future<Income> updateIncome(Income income) async {
    await _simulateDelay();
    final index = _incomes.indexWhere((i) => i.id == income.id);
    if (index != -1) {
      final updatedIncome = income.copyWith(updatedAt: DateTime.now());
      _incomes[index] = updatedIncome;
      return updatedIncome;
    }
    throw Exception('Income not found');
  }

  Future<void> deleteIncome(String incomeId) async {
    await _simulateDelay();
    _incomes.removeWhere((income) => income.id == incomeId);
  }

  // Tag methods
  Future<List<Tag>> getTags() async {
    await _simulateDelay();
    return _tags.where((tag) => tag.userId == _currentUserId).toList();
  }

  Future<Tag> createTag(Tag tag) async {
    await _simulateDelay();
    final newTag = tag.copyWith(
      id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUserId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _tags.add(newTag);
    return newTag;
  }

  Future<Tag> updateTag(Tag tag) async {
    await _simulateDelay();
    final index = _tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      final updatedTag = tag.copyWith(updatedAt: DateTime.now());
      _tags[index] = updatedTag;
      return updatedTag;
    }
    throw Exception('Tag not found');
  }

  Future<void> deleteTag(String tagId) async {
    await _simulateDelay();
    _tags.removeWhere((tag) => tag.id == tagId);
  }

  // Helper method to simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}