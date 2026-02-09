/// Risk identified by Gemini AI
class InsightRisk {
  final String title;
  final String severity; // "critical" | "high"
  final List<String> evidenceIds;
  final String explanation;

  InsightRisk({
    required this.title,
    required this.severity,
    required this.evidenceIds,
    required this.explanation,
  });

  factory InsightRisk.fromJson(Map<String, dynamic> json) {
    return InsightRisk(
      title: json['title'] as String,
      severity: json['severity'] as String,
      evidenceIds: (json['evidenceIds'] as List<dynamic>).cast<String>(),
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'severity': severity,
      'evidenceIds': evidenceIds,
      'explanation': explanation,
    };
  }
}

/// Recommendation from Gemini AI
class InsightRecommendation {
  final String title;
  final String rationale;
  final String priority; // "high" | "medium" | "low"

  InsightRecommendation({
    required this.title,
    required this.rationale,
    required this.priority,
  });

  factory InsightRecommendation.fromJson(Map<String, dynamic> json) {
    return InsightRecommendation(
      title: json['title'] as String,
      rationale: json['rationale'] as String,
      priority: json['priority'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'rationale': rationale,
      'priority': priority,
    };
  }
}

/// Request to generate insights from artifacts
class GeminiInsightRequest {
  final String manifestJson;
  final String metricsJson;
  final String risksJson;
  final String reportExcerpt;

  GeminiInsightRequest({
    required this.manifestJson,
    required this.metricsJson,
    required this.risksJson,
    required this.reportExcerpt,
  });
}

/// Structured response from Gemini AI
class GeminiInsightResponse {
  final String systemSummary; // 2-3 sentences
  final List<InsightRisk> criticalRisks; // Top 3
  final List<InsightRecommendation> recommendations; // Top 3
  final DateTime generatedAt;

  GeminiInsightResponse({
    required this.systemSummary,
    required this.criticalRisks,
    required this.recommendations,
    required this.generatedAt,
  });

  factory GeminiInsightResponse.fromJson(Map<String, dynamic> json) {
    return GeminiInsightResponse(
      systemSummary: json['systemSummary'] as String,
      criticalRisks: (json['criticalRisks'] as List)
          .map((e) => InsightRisk.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((e) => InsightRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemSummary': systemSummary,
      'criticalRisks': criticalRisks.map((r) => r.toJson()).toList(),
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
