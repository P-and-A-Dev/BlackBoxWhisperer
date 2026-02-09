import 'dart:convert';
import 'dart:io';
import 'package:blackbox_ui/models/gemini_insight.dart';
import 'package:blackbox_ui/services/gemini_prompt_builder.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to interact with Gemini API for system insights
class GeminiService {
  GenerativeModel? _model;

  /// Initializes the Gemini service with API key from SharedPreferences
  Future<void> _ensureInitialized() async {
    if (_model != null) return;

    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('gemini_api_key') ?? '';

    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini API key not configured.\n\n'
        'Please go to Settings and enter your API key.\n'
        'Get one at: https://aistudio.google.com/app/apikey',
      );
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3, // Factual and not creative
        maxOutputTokens: 4096,
        responseMimeType: 'application/json',
      ),
    );
  }

  /// Generates insights from a loaded run
  Future<GeminiInsightResponse> generateInsights(
    LoadedRunState run,
  ) async {
    await _ensureInitialized();
    final request = await _buildRequest(run);

    final prompt = GeminiPromptBuilder.buildAnalysisPrompt(
      manifestJson: request.manifestJson,
      metricsJson: request.metricsJson,
      risksJson: request.risksJson,
      reportExcerpt: request.reportExcerpt,
    );

    final response = await _model!.generateContent([Content.text(prompt)]);

    final text = response.text;
    if (text == null || text.isEmpty) {
      throw Exception('Gemini returned empty response');
    }

    return _parseResponse(text);
  }

  /// Builds the request by reading artifact files
  Future<GeminiInsightRequest> _buildRequest(LoadedRunState run) async {
    final manifestPath = '${run.runFolderPath}/artifact_manifest.json';
    final metricsPath = '${run.runFolderPath}/metrics.json';
    final risksPath = '${run.runFolderPath}/risks.json';
    final reportPath = '${run.runFolderPath}/report.md';

    final manifestJson = await File(manifestPath).readAsString();
    final metricsJson = await File(metricsPath).readAsString();
    final risksJsonRaw = await File(risksPath).readAsString();
    final reportMd = await File(reportPath).readAsString();

    final filteredRisks = GeminiPromptBuilder.filterHighSeverityRisks(
      risksJsonRaw,
    );
    final truncatedReport = GeminiPromptBuilder.truncateReport(reportMd);

    return GeminiInsightRequest(
      manifestJson: manifestJson,
      metricsJson: metricsJson,
      risksJson: filteredRisks,
      reportExcerpt: truncatedReport,
    );
  }

  /// Parses Gemini's response into structured data
  GeminiInsightResponse _parseResponse(String text) {
    try {
      final jsonMatch = RegExp(r'```json\s*([\s\S]*?)\s*```').firstMatch(text);
      final jsonStr = jsonMatch?.group(1) ?? text;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return GeminiInsightResponse.fromJson(json);
    } catch (e) {
      throw Exception(
        'Failed to parse Gemini response: $e\n\nRaw response:\n$text',
      );
    }
  }
}
