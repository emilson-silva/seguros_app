import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seguros_app/features/family/domain/family_member.dart';
import 'package:seguros_app/features/family/domain/usecases/family_usecases.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_event.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc({
    required WatchFamily watchFamily,
    required AddFamilyMember addFamilyMember,
    required RemoveFamilyMember removeFamilyMember,
  })  : _watch = watchFamily,
        _add = addFamilyMember,
        _remove = removeFamilyMember,
        super(const FamilyState()) {
    on<FamilyWatchStarted>(_onStarted);
    on<FamilyMemberAdded>(_onAdded);
    on<FamilyMemberRemoved>(_onRemoved);
  }

  final WatchFamily _watch;
  final AddFamilyMember _add;
  final RemoveFamilyMember _remove;
  String? _uid;

  Future<void> _onStarted(
    FamilyWatchStarted event,
    Emitter<FamilyState> emit,
  ) async {
    _uid = event.uid;
    await emit.forEach<List<FamilyMember>>(
      _watch(event.uid),
      onData: (members) =>
          FamilyState(status: FamilyStatus.loaded, members: members),
      onError: (_, __) => state.copyWith(
        status: FamilyStatus.failure,
        errorMessage: 'Não foi possível carregar sua família.',
      ),
    );
  }

  Future<void> _onAdded(
    FamilyMemberAdded event,
    Emitter<FamilyState> emit,
  ) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _add(uid, name: event.name, relationship: event.relationship);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Não foi possível adicionar o membro.'));
    }
  }

  Future<void> _onRemoved(
    FamilyMemberRemoved event,
    Emitter<FamilyState> emit,
  ) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _remove(uid, event.memberId);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Não foi possível remover o membro.'));
    }
  }
}
