import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seguros_app/features/family/data/family_firestore_datasource.dart';

void main() {
  late FakeFirebaseFirestore db;
  late FamilyFirestoreDataSource ds;

  setUp(() {
    db = FakeFirebaseFirestore();
    ds = FamilyFirestoreDataSource(db);
  });

  test('add grava em users/{uid}/family e o stream reflete', () async {
    expect(await ds.watch('u1').first, isEmpty);

    await ds.add('u1', 'Ana', 'Cônjuge');
    await ds.add('u1', 'Leo', 'Filho(a)');

    final members = await ds.watch('u1').first;
    expect(members.map((m) => m.name), ['Ana', 'Leo']);
    expect(members.first.relationship, 'Cônjuge');
  });

  test('dados de um usuário não aparecem para outro', () async {
    await ds.add('u1', 'Ana', 'Cônjuge');
    expect(await ds.watch('u2').first, isEmpty);
  });

  test('remove apaga o documento', () async {
    await ds.add('u1', 'Ana', 'Cônjuge');
    final id = (await ds.watch('u1').first).single.id;

    await ds.remove('u1', id);

    expect(await ds.watch('u1').first, isEmpty);
  });
}
