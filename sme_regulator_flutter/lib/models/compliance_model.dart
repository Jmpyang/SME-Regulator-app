/// Compliance model for AI-ready compliance analysis
class ComplianceModel {
  final int score;
  final int totalRequired;
  final int completed;
  final List<ComplianceCategory> categories;
  final String riskLevel;
  final Map<String, dynamic> aiAnalysisData;

  ComplianceModel({
    required this.score,
    required this.totalRequired,
    required this.completed,
    required this.categories,
    required this.riskLevel,
    required this.aiAnalysisData,
  });

  factory ComplianceModel.calculate(List<DocumentData> documents, {String? businessType}) {
    final requiredCategories = ComplianceCategory.getRequiredCategories(businessType);
    int completedCount = 0;
    final categoryStatus = <ComplianceCategory>[];

    for (final category in requiredCategories) {
      final hasDocument = documents.any((doc) => 
        category.requiredTypes.contains(doc.type.toLowerCase()) ||
        category.keywords.any((keyword) => doc.title.toLowerCase().contains(keyword))
      );

      if (hasDocument) {
        completedCount++;
      }

      categoryStatus.add(category.copyWith(
        isCompleted: hasDocument,
        uploadedDocuments: documents.where((doc) => 
          category.requiredTypes.contains(doc.type.toLowerCase()) ||
          category.keywords.any((keyword) => doc.title.toLowerCase().contains(keyword))
        ).toList(),
      ));
    }

    final score = requiredCategories.isNotEmpty ? ((completedCount / requiredCategories.length) * 100).round() : 0;
    final riskLevel = _calculateRiskLevel(score);

    // AI-ready data structure for analysis
    final aiAnalysisData = {
      'timestamp': DateTime.now().toIso8601String(),
      'business_type': businessType ?? 'Unknown',
      'compliance_score': score,
      'risk_level': riskLevel,
      'category_breakdown': categoryStatus.map((cat) => {
        'category': cat.name,
        'is_completed': cat.isCompleted,
        'required_count': cat.requiredTypes.length,
        'uploaded_count': cat.uploadedDocuments.length,
        'documents': cat.uploadedDocuments.map((doc) => doc.toAIFormat()).toList(),
      }).toList(),
      'total_documents': documents.length,
      'recommendations': _generateRecommendations(categoryStatus),
    };

    return ComplianceModel(
      score: score,
      totalRequired: requiredCategories.length,
      completed: completedCount,
      categories: categoryStatus,
      riskLevel: riskLevel,
      aiAnalysisData: aiAnalysisData,
    );
  }

  static String _calculateRiskLevel(int score) {
    if (score >= 80) return 'Low';
    if (score >= 60) return 'Medium';
    if (score >= 40) return 'High';
    return 'Critical';
  }

  static List<String> _generateRecommendations(List<ComplianceCategory> categories) {
    final recommendations = <String>[];
    for (final category in categories) {
      if (!category.isCompleted) {
        recommendations.add('Upload ${category.name} document(s): ${category.requiredTypes.join(", ")}');
      }
    }
    return recommendations;
  }
}

class ComplianceCategory {
  final String name;
  final String description;
  final List<String> requiredTypes;
  final List<String> keywords;
  final bool isCompleted;
  final List<DocumentData> uploadedDocuments;

  ComplianceCategory({
    required this.name,
    required this.description,
    required this.requiredTypes,
    required this.keywords,
    this.isCompleted = false,
    this.uploadedDocuments = const [],
  });

  ComplianceCategory copyWith({
    String? name,
    String? description,
    List<String>? requiredTypes,
    List<String>? keywords,
    bool? isCompleted,
    List<DocumentData>? uploadedDocuments,
  }) {
    return ComplianceCategory(
      name: name ?? this.name,
      description: description ?? this.description,
      requiredTypes: requiredTypes ?? this.requiredTypes,
      keywords: keywords ?? this.keywords,
      isCompleted: isCompleted ?? this.isCompleted,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
    );
  }

  static List<ComplianceCategory> getRequiredCategories(String? businessType) {
    final baseCategories = [
      ComplianceCategory(
        name: 'Business Registration',
        description: 'Official business registration documents',
        requiredTypes: ['business_registration', 'certificate_of_incorporation'],
        keywords: ['registration', 'incorporation', 'business'],
      ),
      ComplianceCategory(
        name: 'Tax Compliance',
        description: 'Tax registration and compliance documents',
        requiredTypes: ['tax_compliance', 'kra_pin', 'tax_certificate'],
        keywords: ['tax', 'kra', 'pin', 'certificate'],
      ),
    ];

    // Add industry-specific categories based on business type
    switch (businessType?.toLowerCase()) {
      case 'retail':
      case 'hospitality':
        return [
          ...baseCategories,
          ComplianceCategory(
            name: 'Health Compliance',
            description: 'Health and safety compliance documents',
            requiredTypes: ['health_compliance', 'health_certificate'],
            keywords: ['health', 'sanitary', 'inspection'],
          ),
          ComplianceCategory(
            name: 'Trade License',
            description: 'Business trade license documents',
            requiredTypes: ['trade_license', 'business_permit'],
            keywords: ['trade', 'license', 'permit'],
          ),
        ];
      case 'manufacturing':
      case 'construction':
        return [
          ...baseCategories,
          ComplianceCategory(
            name: 'Fire Safety',
            description: 'Fire safety inspection certificates',
            requiredTypes: ['fire_safety', 'safety_certificate'],
            keywords: ['fire', 'safety', 'inspection'],
          ),
          ComplianceCategory(
            name: 'Environmental',
            description: 'Environmental impact assessment documents',
            requiredTypes: ['environmental', 'nema', 'eia'],
            keywords: ['environmental', 'nema', 'impact'],
          ),
          ComplianceCategory(
            name: 'Trade License',
            description: 'Business trade license documents',
            requiredTypes: ['trade_license', 'business_permit'],
            keywords: ['trade', 'license', 'permit'],
          ),
        ];
      case 'technology':
      case 'consulting':
        return [
          ...baseCategories,
          ComplianceCategory(
            name: 'Trade License',
            description: 'Business trade license documents',
            requiredTypes: ['trade_license', 'business_permit'],
            keywords: ['trade', 'license', 'permit'],
          ),
        ];
      default:
        // Return all categories for unknown business types
        return [
          ...baseCategories,
          ComplianceCategory(
            name: 'Fire Safety',
            description: 'Fire safety inspection certificates',
            requiredTypes: ['fire_safety', 'safety_certificate'],
            keywords: ['fire', 'safety', 'inspection'],
          ),
          ComplianceCategory(
            name: 'Health Compliance',
            description: 'Health and safety compliance documents',
            requiredTypes: ['health_compliance', 'health_certificate'],
            keywords: ['health', 'sanitary', 'inspection'],
          ),
          ComplianceCategory(
            name: 'Environmental',
            description: 'Environmental impact assessment documents',
            requiredTypes: ['environmental', 'nema', 'eia'],
            keywords: ['environmental', 'nema', 'impact'],
          ),
          ComplianceCategory(
            name: 'Trade License',
            description: 'Business trade license documents',
            requiredTypes: ['trade_license', 'business_permit'],
            keywords: ['trade', 'license', 'permit'],
          ),
        ];
    }
  }

  static List<ComplianceCategory> get requiredCategories => getRequiredCategories(null);
}

class DocumentData {
  final String id;
  final String title;
  final String type;
  final String status;
  final DateTime uploadedAt;
  final DateTime? expiryDate;
  final int? daysToExpiry;

  DocumentData({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.uploadedAt,
    this.expiryDate,
    this.daysToExpiry,
  });

  Map<String, dynamic> toAIFormat() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'status': status,
      'uploaded_at': uploadedAt.toIso8601String(),
      'days_since_upload': DateTime.now().difference(uploadedAt).inDays,
      'expiry_date': expiryDate?.toIso8601String(),
      'days_to_expiry': daysToExpiry,
    };
  }
}
