import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/auth_state.dart';
import 'package:messaging_app/services/auth/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized(isLoading: true)) {
    //register
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null, 
        isLoading: false,
      ));
    },);

    //forgot password 
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      final email = event.email;
      if (email == null) {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        return;
      }

      bool didSendEmail;
      Exception? exception;

      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });

    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    },);

    //register
    on<AuthEventRegister>((event, emit) async {
      try {
        final email = event.email;
        final password = event.password;
        final username = event.username;

        final user = await provider.createUser(
          email: email, 
          password: password,
        );

        await provider.saveUsername(uid: user.id, username: username);

        await provider.sendEmailVerification();
        emit(AuthStateNeedsVerification(isLoading: false));
      } on Exception catch(e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    },);

    //initialize
    on<AuthEventInitialize>((event, emit) async {
    await provider.initialize();
    final user = provider.currentUser;

    if (user == null) {
      // No user logged in
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ));
    } else if (!user.isEmailVerified) {
      // User exists but email not verified
      emit(const AuthStateNeedsVerification(isLoading: false));
    } else {
      // User exists and verified
      emit(AuthStateLoggedIn(
        user: user,
        isLoading: false,
      ));
    }
  });

    //login
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null, 
        isLoading: true,
        loadingText: 'Please wait while we log you in...',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email, 
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
            exception: null, 
            isLoading: false,
          ));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null, 
            isLoading: false,
          ));
          emit(AuthStateLoggedIn(
            user: user, 
            isLoading: false,
          ));
        }
      } on Exception catch(e) {
        emit(AuthStateLoggedOut(
          exception: e, 
          isLoading: false,
        ));
      }
    },);

    //logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        provider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null, 
          isLoading: false,
        ));
      } on Exception catch(e) {
        emit(AuthStateLoggedOut(
          exception: e, 
          isLoading: false,
        ));
      }
    },);
  }
}