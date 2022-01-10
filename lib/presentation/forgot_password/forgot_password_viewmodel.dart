import 'dart:async';

import 'package:complete_advanced_flutter/domain/usecase/forgotPassword_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInput, ForgotPasswordViewModeloutput {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  var email = "";

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get isAllInputsIsValid => _isAllInputValidStreamController.sink;

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _isAllInputValid());

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  _isAllInputValid() {
    return isEmailValid;
  }

  isEmailValid(String email) {
    return email.isNotEmpty && email.contains("@");
  }

  _validate() {
    isAllInputsIsValid.add(null);
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
    }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }
}

abstract class ForgotPasswordViewModelInput {
  forgotPassword();
  setEmail(String email);

  Sink get inputEmail;
  Sink get isAllInputsIsValid;
}

abstract class ForgotPasswordViewModeloutput {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsAllInputsValid;
}
