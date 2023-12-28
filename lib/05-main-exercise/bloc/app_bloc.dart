import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_state_mgt/05-main-exercise/auth/auth_errors.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_event.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_state.dart';
import 'package:bloc_state_mgt/05-main-exercise/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    // app initialization
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });

    // handling image upload
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;

      // if no user then keep user logged out!
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      // log in the user and set his images
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );

      // upload image
      final file = File(event.filePathToUpload);
      await uploadImage(file: file, userId: user.uid);

      // after upload, grab the latest file ref, emit new image and turn of loading!!
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });

    // handle registration
    on<AppEventRegister>((event, emit) async {
      emit(const AppStateIsInRegistrationView(isLoading: true));

      final email = event.email;
      final password = event.password;

      try {
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // handle go to login
    on<AppEventGoToLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // handle login
    on<AppEventLogIn>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));

      final email = event.email;
      final password = event.password;

      try {
        final credentials =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final images = await _getImages(credentials.user!.uid);
        final user = credentials.user!;
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // handle go to register view
    on<AppEventGoToRegistration>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: false));
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });

    // handle log out
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));

      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // handling profile deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      // start loading
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );

      // delete user folder
      try {
        // first delete the images
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); //maybe handle error??
        }

        // delete the image folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        // delete user
        await user.delete();

        // log user out
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        // might not be able to delete the image folder
        emit(const AppStateLoggedOut(isLoading: false));
      }
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listRes) => listRes.items);
}
