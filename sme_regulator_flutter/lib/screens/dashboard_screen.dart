import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/compliance_model.dart';
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
    final compliance = dashboardProvider.compliance;
    final bool isSmallScreen = MediaQuery.sizeOf(context).width < 600;

    final displayName = user?.name.isNotEmpty == true ? user!.name : 
                        user?.email.isNotEmpty == true ? user!.email : 'User';
    final email = user?.email.isNotEmpty == true ? user!.email : null;

    // Use compliance data
    final complianceScore = compliance?.score ?? 0;
    final activePermits = compliance?.completed ?? 0;
    final missingExpired = compliance != null 
        ? compliance.totalRequired - compliance.completed 
        : 0;
    final requiredCategories = compliance?.totalRequired ?? 0;

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Text(
                                'Welcome back, ',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                displayName,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email == null
                                ? 'Here is your real-time compliance status.'
                                : 'Signed in as $email',
                            style: Theme.of(context).textTheme.bodyMedium,
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
                            '$complianceScore%',
                            Icons.shield_outlined,
                            _getComplianceScoreColor(complianceScore.toDouble()),
                            Theme.of(context).colorScheme.primary,
                          ),
                          _buildInfoCard(
                            'ACTIVE PERMITS',
                            '$activePermits',
                            Icons.shield_outlined,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary,
                          ),
                          _buildInfoCard(
                            'MISSING / EXPIRED',
                            '$missingExpired',
                            Icons.warning_amber_rounded,
                            Theme.of(context).colorScheme.error,
                            Theme.of(context).colorScheme.error,
                          ),
                          _buildInfoCard(
                            'REQUIRED CATEGORIES',
                            '$requiredCategories',
                            Icons.description_outlined,
                            Theme.of(context).colorScheme.onSurface,
                            Colors.blueGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Compliance Categories Section
                      if (compliance != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: AppTheme.kCardRadius,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'COMPLIANCE CATEGORIES',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: AppTheme.kFontWeightBlack,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getRiskLevelColor(compliance.riskLevel),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      compliance.riskLevel.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: AppTheme.kFontWeightBold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              ...compliance.categories.map((category) => _buildCategoryItem(category)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Bottom Large Card - Expiring Documents
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: AppTheme.kCardRadius,
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
                                Text(
                                  'EXPIRING DOCUMENTS (90 DAYS)',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: AppTheme.kFontWeightBlack,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (compliance == null)
                              const Center(child: CircularProgressIndicator())
                            else if (_getExpiringDocuments(compliance).isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 32.0),
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
                                      const SizedBox(height: 16),
                                      Text(
                                        'Compliance Maintained',
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No documents are expiring in the next 90 days.',
                                        style: Theme.of(context).textTheme.bodyMedium,
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
                                itemCount: _getExpiringDocuments(compliance).length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final doc = _getExpiringDocuments(compliance)[index];
                                  final urgent = doc.daysToExpiry != null && doc.daysToExpiry! <= 30;
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(
                                      urgent ? Icons.warning_amber_rounded : Icons.info_outline,
                                      color: urgent ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                                    ),
                                    title: Text(
                                      doc.title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: AppTheme.kFontWeightSemiBold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${doc.type} · ${doc.daysToExpiry != null ? "Expires in ${doc.daysToExpiry} days" : "Expiry date unknown"}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: isSmallScreen
                                        ? null
                                        : doc.expiryDate != null
                                            ? Text(
                                                doc.expiryDate!.toLocal().toString().split(' ')[0],
                                                style: Theme.of(context).textTheme.bodySmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : null,
                                  );
                                },
                              ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.documentVault);
                                },
                                child: Text(
                                  'MANAGE ALL DOCUMENTS →',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: AppTheme.kFontWeightSemiBold,
                                    letterSpacing: 1.0,
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
            color: Colors.black.withValues(alpha: 0.1),
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

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  List<DocumentData> _getExpiringDocuments(ComplianceModel compliance) {
    final allDocs = compliance.categories.expand((cat) => cat.uploadedDocuments).toList();
    return allDocs.where((doc) {
      if (doc.daysToExpiry == null) return false;
      return doc.daysToExpiry! <= 90 && doc.daysToExpiry! > 0;
    }).toList()
      ..sort((a, b) => (a.daysToExpiry ?? 0).compareTo(b.daysToExpiry ?? 0));
  }

  Widget _buildCategoryItem(ComplianceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: category.isCompleted ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: category.isCompleted ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category.isCompleted ? const Color(0xFF22C55E).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.isCompleted ? Icons.check_circle : Icons.error,
              color: category.isCompleted ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (category.uploadedDocuments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${category.uploadedDocuments.length} document(s) uploaded',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
