import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/income_provider.dart';
import '../../../core/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final expenseProvider = context.read<ExpenseProvider>();
    final incomeProvider = context.read<IncomeProvider>();
    
    await Future.wait([
      expenseProvider.loadExpenses(refresh: true),
      incomeProvider.loadIncomes(refresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('記帳App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go(AppRouter.profile),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: '支出',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: '收入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '分析',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showAddDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildExpensesTab();
      case 2:
        return _buildIncomesTab();
      case 3:
        return _buildAnalyticsTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Consumer2<ExpenseProvider, IncomeProvider>(
      builder: (context, expenseProvider, incomeProvider, child) {
        final monthlyExpenses = expenseProvider.getExpensesForCurrentMonth();
        final monthlyIncomes = incomeProvider.getIncomesForCurrentMonth();
        
        final totalExpense = monthlyExpenses.fold<double>(
          0.0, (sum, expense) => sum + expense.amount
        );
        final totalIncome = monthlyIncomes.fold<double>(
          0.0, (sum, income) => sum + income.amount
        );
        final balance = totalIncome - totalExpense;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: '本月支出',
                    amount: totalExpense,
                    color: Theme.of(context).colorScheme.error,
                    icon: Icons.trending_down,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    title: '本月收入',
                    amount: totalIncome,
                    color: Colors.green,
                    icon: Icons.trending_up,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              title: '本月結餘',
              amount: balance,
              color: balance >= 0 ? Colors.green : Theme.of(context).colorScheme.error,
              icon: balance >= 0 ? Icons.account_balance : Icons.warning,
              isWide: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    bool isWide = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'NT\$ ${amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '最近交易',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: const Text('查看全部'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer2<ExpenseProvider, IncomeProvider>(
          builder: (context, expenseProvider, incomeProvider, child) {
            final expenses = expenseProvider.expenses.take(3).toList();
            final incomes = incomeProvider.incomes.take(2).toList();
            
            if (expenses.isEmpty && incomes.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text('暫無交易記錄'),
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...expenses.map((expense) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      child: Icon(
                        Icons.trending_down,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    title: Text(expense.description),
                    subtitle: Text(expense.category),
                    trailing: Text(
                      '-NT\$ ${expense.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
                ...incomes.map((income) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.2),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(income.description),
                    subtitle: Text(income.source),
                    trailing: Text(
                      '+NT\$ ${income.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildExpensesTab() {
    return const Center(
      child: Text('支出列表功能開發中...'),
    );
  }

  Widget _buildIncomesTab() {
    return const Center(
      child: Text('收入列表功能開發中...'),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('分析功能開發中...'),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新增交易'),
        content: const Text('選擇要新增的交易類型'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.addExpense);
            },
            child: const Text('支出'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.addIncome);
            },
            child: const Text('收入'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}