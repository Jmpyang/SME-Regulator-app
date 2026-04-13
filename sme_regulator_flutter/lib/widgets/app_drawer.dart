import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';
import '../providers/theme_notifier.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF4F46E5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'SME',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SME Navigator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: AppRoutes.dashboard,
            currentRoute: currentRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.folder_open_outlined,
            title: 'Document Vault',
            route: AppRoutes.documentVault,
            currentRoute: currentRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.assignment_outlined,
            title: 'Permits',
            route: AppRoutes.permits,
            currentRoute: currentRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.notifications_active_outlined,
            title: 'Reminders',
            route: AppRoutes.reminders,
            currentRoute: currentRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            route: AppRoutes.profile,
            currentRoute: currentRoute,
          ),
          const Divider(),
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return ListTile(
          leading: Icon(
            themeNotifier.isDark ? Icons.dark_mode : Icons.light_mode,
            color: Colors.grey.shade600,
          ),
          title: Text(
            themeNotifier.isDark ? 'Light Mode' : 'Dark Mode',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.normal,
            ),
          ),
          onTap: () {
            themeNotifier.toggle();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required String currentRoute,
  }) {
    final bool isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF4F46E5).withOpacity(0.05),
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
