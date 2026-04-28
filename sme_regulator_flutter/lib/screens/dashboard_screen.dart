import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_overlay.dart';
import '../core/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final dashboardProvider = context.watch<DashboardProvider>();
    final summary = dashboardProvider.summary;
    final bool isSmallScreen = MediaQuery.sizeOf(context).width < 600;

    final displayName = user?.name.isNotEmpty == true ? user!.name : 
                        user?.email.isNotEmpty == true ? user!.email : 'User';
    final email = user?.email.isNotEmpty == true ? user!.email : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: LoadingOverlay(
        loadingKey: 'dashboard',
        child: RefreshIndicator(
          onRefresh: () => context.read<DashboardProvider>().fetchSummary(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    const Text(
                                      'Welcome back, ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email == null
                                      ? 'Here is your real-time compliance status.'
                                      : 'Signed in as $email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh, color: Colors.grey.shade600),
                              onPressed: () {
                                context.read<DashboardProvider>().fetchSummary();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Error Banner (should be removed once data type mismatch is fixed)
                      if (dashboardProvider.error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            border: Border.all(color: Theme.of(context).colorScheme.error),
                            borderRadius: AppTheme.kCardRadius,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.onError, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dashboardProvider.error ?? 'Failed to sync dashboard data.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onError,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (dashboardProvider.error != null) const SizedBox(height: 24),

                      // Info Cards Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isSmallScreen ? 1.05 : 1.25,
                        children: [
                          _buildInfoCard(
                            'COMPLIANCE SCORE',
                            '${summary?.complianceScore ?? 0}%',
                            Icons.shield_outlined,
                            _getComplianceScoreColor((summary?.complianceScore ?? 0).toDouble()), // Color-coded based on score
                            const Color(0xFF4F46E5), // Indigo icon bg
                          ),
                          _buildInfoCard(
                            'ACTIVE PERMITS',
                            '${summary?.activePermits ?? 0}',
                            Icons.shield_outlined,
                            const Color(0xFF4F46E5), // Indigo
                            const Color(0xFF4F46E5), // Indigo icon bg
                          ),
                          _buildInfoCard(
                            'MISSING / EXPIRED',
                            '${summary?.missingExpired ?? 0}',
                            Icons.warning_amber_rounded,
                            const Color(0xFFE11D48), // Red
                            const Color(0xFFE11D48), // Red icon bg
                          ),
                          _buildInfoCard(
                            'REQUIRED CATEGORIES',
                            '${summary?.requiredCategories ?? 0}',
                            Icons.description_outlined,
                            const Color(0xFF111827), // Black
                            Colors.blueGrey, // Grey icon bg
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bottom Large Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                const Text(
                                  'PRIORITY RENEWALS (90 DAYS)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF111827),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                if ((summary?.upcomingExpiries.length ?? 0) > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'ACTION REQUIRED',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (summary == null || summary.upcomingExpiries.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFECFDF5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle_outline,
                                          color: Color(0xFF059669),
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Compliance Maintained',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No documents are expiring in the next 90 days.',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: summary.upcomingExpiries.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final r = summary.upcomingExpiries[index];
                                  final urgent = r.daysRemaining <= 30;
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(
                                      urgent ? Icons.warning_amber_rounded : Icons.info_outline,
                                      color: urgent ? const Color(0xFFE11D48) : const Color(0xFF4F46E5),
                                    ),
                                    title: Text(
                                      r.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${r.documentType} · Expires in ${r.daysRemaining} days',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: isSmallScreen
                                        ? null
                                        : Text(
                                            r.expiryDate.toLocal().toString().split(' ')[0],
                                            style: TextStyle(color: Colors.grey.shade500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                  );
                                },
                              ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFEEF2FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.permits);
                                },
                                child: const Text(
                                  'MANAGE ALL PERMITS →',
                                  style: TextStyle(
                                    color: Color(0xFF4F46E5),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    fontSize: 12,
                                  ),
                                ),
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
        ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color iconBg,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppTheme.kCardRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                    // Add progress indicator for compliance score
                    if (title == 'COMPLIANCE SCORE')
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (double.tryParse(value.replaceAll('%', '')) ?? 0.0) / 100,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(_getComplianceScoreColor(double.tryParse(value.replaceAll('%', '')) ?? 0.0)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getComplianceScoreColor(double score) {
    if (score <= 40) return Colors.red;
    if (score <= 70) return Colors.orange;
    return Colors.green;
  }
}
