import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/features/run/state/run_context_notifier.dart';
import 'package:ui/features/run/state/run_context_state.dart';

final runContextProvider =
    NotifierProvider<RunContextNotifier, RunContextState>(
      RunContextNotifier.new,
    );
