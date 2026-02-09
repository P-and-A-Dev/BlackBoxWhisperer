import 'package:blackbox_ui/models/gemini_insight.dart';
import 'package:blackbox_ui/states/gemini_insights_provider.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminiInsightsPanel extends ConsumerWidget {
  const GeminiInsightsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedRun = ref.watch(loadedRunProvider);
    final insightsAsync = ref.watch(geminiInsightsProvider);

    return Container(
      color: const Color(0xFF1a1d23),
      child: Column(
        children: [
          _buildHeader(context, ref, loadedRun),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: insightsAsync.when(
              data: (insights) => _buildContent(context, insights),
              loading: () => _buildLoading(),
              error: (e, _) => _buildError(context, e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    LoadedRunState? run,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF1e2228),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.purple, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Gemini Insights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: run == null ? null : () => _generate(ref, run),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate Insights'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _generate(WidgetRef ref, LoadedRunState run) {
    ref.read(geminiInsightsProvider.notifier).generate(run);
  }

  Widget _buildContent(BuildContext context, GeminiInsightResponse? insights) {
    if (insights == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: Colors.white.withAlpha(30),
            ),
            const SizedBox(height: 16),
            const Text(
              'No insights generated yet',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Generate Insights" to analyze this system with AI',
              style: TextStyle(color: Colors.white.withAlpha(95), fontSize: 12),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection(context, insights.systemSummary),
          const SizedBox(height: 32),
          _buildRisksSection(context, insights.criticalRisks),
          const SizedBox(height: 32),
          _buildRecommendationsSection(context, insights.recommendations),
          const SizedBox(height: 16),
          _buildFooter(context, insights.generatedAt),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, String summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.summarize, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'System Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2a2f38),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withAlpha(50)),
          ),
          child: Text(
            summary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRisksSection(BuildContext context, List<InsightRisk> risks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Critical Risks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...risks.asMap().entries.map((entry) {
          final index = entry.key;
          final risk = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < risks.length - 1 ? 12 : 0),
            child: _buildRiskCard(context, risk, index + 1),
          );
        }),
      ],
    );
  }

  Widget _buildRiskCard(BuildContext context, InsightRisk risk, int number) {
    final severityColor = risk.severity == 'critical'
        ? Colors.red
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2f38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#$number',
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  risk.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  risk.severity.toUpperCase(),
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            risk.explanation,
            style: TextStyle(
              color: Colors.white.withAlpha(215),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (risk.evidenceIds.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: risk.evidenceIds.map((id) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withAlpha(30)),
                  ),
                  child: Text(
                    id,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(
    BuildContext context,
    List<InsightRecommendation> recommendations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Recommendations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final rec = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < recommendations.length - 1 ? 12 : 0,
            ),
            child: _buildRecommendationCard(context, rec, index + 1),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    InsightRecommendation rec,
    int number,
  ) {
    final priorityColor = rec.priority == 'high'
        ? Colors.red
        : rec.priority == 'medium'
        ? Colors.orange
        : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2f38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#$number',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rec.priority.toUpperCase(),
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rec.rationale,
            style: TextStyle(
              color: Colors.white.withAlpha(215),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, DateTime generatedAt) {
    return Center(
      child: Text(
        'Generated at ${generatedAt.toLocal().toString().substring(0, 19)}',
        style: TextStyle(
          color: Colors.white.withAlpha(100),
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.purple),
          SizedBox(height: 16),
          Text(
            'Analyzing system with Gemini AI...',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final errorMessage = error.toString();
    final isApiKeyError =
        errorMessage.contains('API_KEY') ||
        errorMessage.contains('YOUR_API_KEY_HERE');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to generate insights',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withAlpha(100)),
              ),
              child: SelectableText(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            if (isApiKeyError)
              const Text(
                '⚠️ Please configure your Gemini API key in gemini_service.dart',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Check your API key and network connection',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
