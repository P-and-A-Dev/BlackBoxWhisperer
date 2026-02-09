import 'package:blackbox_ui/models/gemini_insight.dart';
import 'package:blackbox_ui/services/gemini_service.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_insights_provider.g.dart';

@riverpod
class GeminiInsights extends _$GeminiInsights {
  @override
  AsyncValue<GeminiInsightResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> generate(LoadedRunState run) async {
    state = const AsyncValue.loading();

    try {
      final service = GeminiService();
      final response = await service.generateInsights(run);
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
