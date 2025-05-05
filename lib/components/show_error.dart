import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void showError(String? loginResult) {
   String errorMessage;
  // Handle Firebase error codes
  switch (loginResult) {
    case "invalid-email":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "wrong-password":
      errorMessage = "Your password is wrong.";
      break;
    case "user-not-found":
      errorMessage = "User with this email doesn't exist.";
      break;
    case "user-disabled":
      errorMessage = "User with this email has been disabled.";
      break;
    case "too-many-requests":
      errorMessage = "Too many requests. Please try again later.";
      break;
    case "operation-not-allowed":
      errorMessage = "Signing in with Email and Password is not enabled.";
      break;
    default:
      errorMessage = "An undefined error occurred. Please try again.";
  }
 showToast(ToastificationType.error, errorMessage);
}

void showToast(ToastificationType type, String message) {
  toastification.show(
    type: type,
    description: Text(message),
    autoCloseDuration: Duration(seconds: 3),
  );
}