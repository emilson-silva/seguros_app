import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:seguros_app/core/storage/local_storage.dart';
import 'package:seguros_app/features/auth/data/auth_remote_datasource.dart';
import 'package:seguros_app/features/auth/data/auth_repository_impl.dart';
import 'package:seguros_app/features/auth/domain/auth_repository.dart';
import 'package:seguros_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/family/data/family_firestore_datasource.dart';
import 'package:seguros_app/features/family/data/family_repository_impl.dart';
import 'package:seguros_app/features/family/domain/family_repository.dart';
import 'package:seguros_app/features/family/domain/usecases/family_usecases.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    // externos
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<LocalStorage>(() => LocalStorage(getIt()))
    // auth
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt(), getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        getCurrentUser: GetCurrentUser(getIt()),
        signIn: SignIn(getIt()),
        register: Register(getIt()),
        signOut: SignOut(getIt()),
      ),
    )
    // family
    ..registerLazySingleton<FamilyFirestoreDataSource>(
      () => FamilyFirestoreDataSource(getIt()),
    )
    ..registerLazySingleton<FamilyRepository>(
      () => FamilyRepositoryImpl(getIt()),
    )
    ..registerFactory<FamilyBloc>(
      () => FamilyBloc(
        watchFamily: WatchFamily(getIt()),
        addFamilyMember: AddFamilyMember(getIt()),
        removeFamilyMember: RemoveFamilyMember(getIt()),
      ),
    );
}
