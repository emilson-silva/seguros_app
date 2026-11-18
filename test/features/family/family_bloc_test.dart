import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seguros_app/features/family/domain/family_member.dart';
import 'package:seguros_app/features/family/domain/family_repository.dart';
import 'package:seguros_app/features/family/domain/usecases/family_usecases.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_event.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_state.dart';

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  late MockFamilyRepository repo;
  const member = FamilyMember(id: '1', name: 'Ana', relationship: 'Cônjuge');

  FamilyBloc buildBloc() => FamilyBloc(
        watchFamily: WatchFamily(repo),
        addFamilyMember: AddFamilyMember(repo),
        removeFamilyMember: RemoveFamilyMember(repo),
      );

  setUp(() => repo = MockFamilyRepository());

  blocTest<FamilyBloc, FamilyState>(
    'FamilyWatchStarted emite a lista vinda do stream',
    setUp: () => when(() => repo.watchMembers('u1'))
        .thenAnswer((_) => Stream.value([member])),
    build: buildBloc,
    act: (b) => b.add(const FamilyWatchStarted('u1')),
    expect: () => [
      const FamilyState(status: FamilyStatus.loaded, members: [member]),
    ],
  );

  blocTest<FamilyBloc, FamilyState>(
    'erro no stream emite failure',
    setUp: () => when(() => repo.watchMembers('u1'))
        .thenAnswer((_) => Stream.error(Exception('x'))),
    build: buildBloc,
    act: (b) => b.add(const FamilyWatchStarted('u1')),
    expect: () => [
      const FamilyState(
        status: FamilyStatus.failure,
        errorMessage: 'Não foi possível carregar sua família.',
      ),
    ],
  );

  blocTest<FamilyBloc, FamilyState>(
    'FamilyMemberAdded chama o repositório com o uid correto',
    setUp: () {
      when(() => repo.watchMembers('u1')).thenAnswer((_) => const Stream.empty());
      when(
        () => repo.addMember('u1', name: 'Ana', relationship: 'Cônjuge'),
      ).thenAnswer((_) async {});
    },
    build: buildBloc,
    act: (b) async {
      b.add(const FamilyWatchStarted('u1'));
      await Future<void>.delayed(Duration.zero);
      b.add(const FamilyMemberAdded(name: 'Ana', relationship: 'Cônjuge'));
    },
    verify: (_) => verify(
      () => repo.addMember('u1', name: 'Ana', relationship: 'Cônjuge'),
    ).called(1),
  );

  blocTest<FamilyBloc, FamilyState>(
    'falha ao adicionar emite errorMessage',
    setUp: () {
      when(() => repo.watchMembers('u1')).thenAnswer((_) => const Stream.empty());
      when(
        () => repo.addMember(any(), name: any(named: 'name'), relationship: any(named: 'relationship')),
      ).thenThrow(Exception('offline'));
    },
    build: buildBloc,
    act: (b) async {
      b.add(const FamilyWatchStarted('u1'));
      await Future<void>.delayed(Duration.zero);
      b.add(const FamilyMemberAdded(name: 'Ana', relationship: 'Cônjuge'));
    },
    expect: () => [
      const FamilyState(errorMessage: 'Não foi possível adicionar o membro.'),
    ],
  );

  blocTest<FamilyBloc, FamilyState>(
    'FamilyMemberRemoved chama o repositório',
    setUp: () {
      when(() => repo.watchMembers('u1')).thenAnswer((_) => const Stream.empty());
      when(() => repo.removeMember('u1', '1')).thenAnswer((_) async {});
    },
    build: buildBloc,
    act: (b) async {
      b.add(const FamilyWatchStarted('u1'));
      await Future<void>.delayed(Duration.zero);
      b.add(const FamilyMemberRemoved('1'));
    },
    verify: (_) => verify(() => repo.removeMember('u1', '1')).called(1),
  );
}
