import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'materials_screen.dart';
import 'package:provider/provider.dart';
import '../providers/material_provider.dart';
import '../models/material.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    final List<Widget> _screens = isAdmin
        ? [
            const AdminDashboardScreen(),
            const MaterialsScreen(),
            const ProcessesScreen(),
            const UsersScreen(),
            const AnalyticsScreen(),
          ]
        : [
            const OperatorDashboardScreen(),
            const ScanMaterialsScreen(),
            const TasksScreen(),
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SmartFab',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authProvider.currentUser?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    authProvider.currentUser?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdmin) ...[
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Dashboard'),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Materials'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Processes'),
                selected: _selectedIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Users'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 3);
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: const Text('Analytics'),
                selected: _selectedIndex == 4,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 4);
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Dashboard'),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scan Materials'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.task_outlined),
                title: const Text('Tasks'),
                selected: _selectedIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
            ],
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: isAdmin
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Materials',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Processes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Users',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: 'Analytics',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.qr_code_scanner),
                  selectedIcon: Icon(Icons.qr_code_scanner),
                  label: 'Scan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_outlined),
                  selectedIcon: Icon(Icons.task),
                  label: 'Tasks',
                ),
              ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(
          'Total Materials',
          '1,234',
          Icons.inventory_2,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Active Processes',
          '12',
          Icons.settings,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Total Users',
          '45',
          Icons.people,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Low Stock Items',
          '5',
          Icons.warning,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OperatorDashboardScreen extends StatelessWidget {
  const OperatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(
          'Assigned Tasks',
          '5',
          Icons.task,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Completed Today',
          '3',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Materials Scanned',
          '12',
          Icons.qr_code_scanner,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessesScreen extends StatelessWidget {
  const ProcessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Processes Screen - Coming Soon'),
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Users Screen - Coming Soon'),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Analytics Screen - Coming Soon'),
    );
  }
}

class ScanMaterialsScreen extends StatelessWidget {
  const ScanMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Scan Materials Screen - Coming Soon'),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tasks Screen - Coming Soon'),
    );
  }
} 