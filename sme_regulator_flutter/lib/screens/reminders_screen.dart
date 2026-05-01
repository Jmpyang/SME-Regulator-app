import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../models/reminder_model.dart';
import '../models/notification_model.dart';
import '../widgets/custom_app_bar.dart';
import '../core/theme.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();
    final reminders = provider.reminders;
    final notifications = provider.notifications;
    final filterType = provider.filterType ?? 'all';

    // Combine both lists based on filter
    List<dynamic> combinedItems = [];
    if (filterType == 'all' || filterType == 'expiry') {
      combinedItems.addAll(reminders);
    }
    if (filterType == 'all' || filterType == 'notification') {
      combinedItems.addAll(notifications);
    }

    // Sort by date (most recent first)
    combinedItems.sort((a, b) {
      final aDate = a is ReminderModel ? a.expiryDate : (a as AppNotification).createdAt;
      final bDate = b is ReminderModel ? b.expiryDate : (b as AppNotification).createdAt;
      return bDate.compareTo(aDate);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: const CustomAppBar(title: 'Notifications'),
      body: provider.isLoading && reminders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.loadReminders(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title Area
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reminders',
                                      style: Theme.of(context).textTheme.displaySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Auto-generated compliance alerts and system updates.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                _showFilterDialog(context, provider);
                              },
                              icon: const Icon(Icons.filter_alt_outlined, size: 20),
                              label: Text(
                                filterType == 'all' ? 'Filter: All' : 
                                filterType == 'expiry' ? 'Filter: Expiries' : 
                                'Filter: Notifications',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Error Banner
                      if (provider.error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            border: Border.all(color: const Color(0xFFFCA5A5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  provider.error ?? 'Unable to sync reminders with the server.',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: AppTheme.kFontWeightBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (provider.error != null) const SizedBox(height: 24),

                      // Main List or empty state
                      if (combinedItems.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 80.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: AppTheme.kCardRadius,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.success.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    color: Theme.of(context).colorScheme.success,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'All caught up!',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'You have no new alerts. Your compliance is\nfully up to date.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: AppTheme.kCardRadius,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: combinedItems.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = combinedItems[index];
                              
                              if (item is ReminderModel) {
                                return _buildReminderItem(item);
                              } else if (item is AppNotification) {
                                return _buildNotificationItem(item, provider);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Pro-Tip Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF312E81), Color(0xFF4338CA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pro-Tip: USSD Reminders',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Don\'t forget you can access your compliance status on the go! Dial our USSD\ncode to check expiring permits even without an internet connection.',
                              style: TextStyle(
                                color: Colors.indigo.shade100,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildReminderItem(ReminderModel r) {
    Color iconColor = Theme.of(context).colorScheme.primary;
    IconData icon = Icons.info_outline;
    
    if (r.daysRemaining < 0) {
      iconColor = Theme.of(context).colorScheme.error;
      icon = Icons.error_outline;
    } else if (r.daysRemaining <= 30) {
      iconColor = Theme.of(context).colorScheme.warning;
      icon = Icons.warning_amber_rounded;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppTheme.kFontWeightSemiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  r.daysRemaining < 0 
                    ? 'Expired ${-r.daysRemaining} days ago'
                    : 'Expires in ${r.daysRemaining} days',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              r.expiryDate.toLocal().toString().split(' ')[0],
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification, ReminderProvider provider) {
    Color iconColor = Theme.of(context).colorScheme.primary;
    IconData icon = Icons.info_outline;
    
    switch (notification.type) {
      case 'success':
        iconColor = Theme.of(context).colorScheme.success;
        icon = Icons.check_circle_outline;
        break;
      case 'action_required':
        iconColor = Theme.of(context).colorScheme.error;
        icon = Icons.error_outline;
        break;
      case 'expiry_alert':
        iconColor = Theme.of(context).colorScheme.warning;
        icon = Icons.warning_amber_rounded;
        break;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppTheme.kFontWeightSemiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              notification.createdAt.toLocal().toString().split(' ')[0],
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ReminderProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All'),
              leading: Radio<String>(
                value: 'all',
                groupValue: provider.filterType ?? 'all',
                onChanged: (value) {
                  provider.setFilter(value ?? 'all');
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Expiries Only'),
              leading: Radio<String>(
                value: 'expiry',
                groupValue: provider.filterType ?? 'all',
                onChanged: (value) {
                  provider.setFilter(value ?? 'expiry');
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Notifications Only'),
              leading: Radio<String>(
                value: 'notification',
                groupValue: provider.filterType ?? 'all',
                onChanged: (value) {
                  provider.setFilter(value ?? 'notification');
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
