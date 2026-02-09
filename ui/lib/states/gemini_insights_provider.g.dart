// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GeminiInsights)
final geminiInsightsProvider = GeminiInsightsProvider._();

final class GeminiInsightsProvider
    extends
        $NotifierProvider<GeminiInsights, AsyncValue<GeminiInsightResponse?>> {
  GeminiInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiInsightsHash();

  @$internal
  @override
  GeminiInsights create() => GeminiInsights();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<GeminiInsightResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<GeminiInsightResponse?>>(
        value,
      ),
    );
  }
}

String _$geminiInsightsHash() => r'bacfa2c908eec03d756fb8953a0d24c0cfadac96';

abstract class _$GeminiInsights
    extends $Notifier<AsyncValue<GeminiInsightResponse?>> {
  AsyncValue<GeminiInsightResponse?> build();

  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<GeminiInsightResponse?>,
              AsyncValue<GeminiInsightResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<GeminiInsightResponse?>,
                AsyncValue<GeminiInsightResponse?>
              >,
              AsyncValue<GeminiInsightResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
