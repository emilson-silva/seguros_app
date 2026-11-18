import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seguros_app/features/auth/data/auth_remote_datasource.dart';

void main() {
  test('register cria o usuário no Auth e o perfil no Firestore', () async {
    final auth = MockFirebaseAuth();
    final db = FakeFirebaseFirestore();
    final ds = AuthRemoteDataSource(auth, db);

    final user = await ds.register('Caio Maximo', '529.982.247-25', '123456');

    final doc = await db.collection('users').doc(user.uid).get();
    expect(doc.exists, isTrue);
    expect(doc.data()!['name'], 'Caio Maximo');
    expect(doc.data()!['cpf'], '52998224725');
    expect(user.name, 'Caio Maximo');
  });

  test('currentUser sem sessão retorna null', () async {
    final ds = AuthRemoteDataSource(MockFirebaseAuth(), FakeFirebaseFirestore());
    expect(await ds.currentUser(), isNull);
  });
}
