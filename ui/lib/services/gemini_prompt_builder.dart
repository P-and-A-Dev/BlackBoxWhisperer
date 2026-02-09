import 'dart:convert';

/// Service to build prompts for Gemini AI analysis
class GeminiPromptBuilder {
  static const int maxReportLines = 800;
  static const int maxRisksCount = 10;

  /// Builds the complete analysis prompt for Gemini
  static String buildAnalysisPrompt({
    required String manifestJson,
    required String metricsJson,
    required String risksJson,
    required String reportExcerpt,
  }) {
    return '''
You are an expert in legacy system analysis. Your role is to provide factual, evidence-based insights.

STRICT RULES:
- Only cite information present in the artifacts
- Reference evidence IDs when discussing risks
- No speculation or assumptions
- Be concise and actionable

ARTIFACTS PROVIDED:

=== MANIFEST ===
$manifestJson

=== METRICS ===
$metricsJson

=== RISKS (Top $maxRisksCount) ===
$risksJson

=== REPORT EXCERPT (First $maxReportLines lines) ===
$reportExcerpt

TASK:
Generate a structured analysis in JSON format with this exact schema:

{
  "systemSummary": "2-3 sentence overview of the system based on manifest and metrics",
  "criticalRisks": [
    {
      "title": "Short risk title",
      "severity": "critical" or "high",
      "evidenceIds": ["risk.id.from.artifacts"],
      "explanation": "Why this matters, based on evidence"
    }
  ],
  "recommendations": [
    {
      "title": "Actionable recommendation",
      "rationale": "Why this helps, referencing artifacts",
      "priority": "high" | "medium" | "low"
    }
  ],
  "generatedAt": "ISO 8601 timestamp"
}

Return top 3 risks and top 3 recommendations only.
Focus on critical issues that could impact operations or maintainability.
''';
  }

  /// Truncates the report to respect token budget
  static String truncateReport(String reportMd) {
    final lines = reportMd.split('\n');
    if (lines.length <= maxReportLines) {
      return reportMd;
    }

    return '${lines.take(maxReportLines).join('\n')}\n\n... (truncated for brevity)';
  }

  /// Filters risks to keep only high severity ones
  static String filterHighSeverityRisks(String risksJson) {
    try {
      final data = jsonDecode(risksJson) as Map<String, dynamic>;
      final risks = data['risks'] as List?;

      if (risks == null) return risksJson;

      final filtered = risks
          .where((r) {
            final severity = r['severity'] as String?;
            return severity == 'critical' || severity == 'high';
          })
          .take(maxRisksCount)
          .toList();

      return jsonEncode({'risks': filtered});
    } catch (e) {
      // Just a Fallback: it returns the original one if parsing fails
      return risksJson;
    }
  }
}
