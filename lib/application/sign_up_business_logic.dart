//
// import 'package:flutter/material.dart';
//
// import '../infrastructure/models/user.dart';
// import '../infrastructure/services/auth.dart';
// import '../infrastructure/services/user.dart';
//
// enum SignUpStatus { Initial, Registered, Registering, Failed }
//
// enum ValidatedStatus { Validated, NotValidated }
//
// class SignUpBusinessLogic with ChangeNotifier {
//   SignUpStatus _status = SignUpStatus.Initial;
//   ValidatedStatus _vStatus = ValidatedStatus.NotValidated;
//
//   SignUpStatus get status => _status;
//
//   void setState(SignUpStatus status) {
//     _status = status;
//     notifyListeners();
//   }
//
//   final AuthServices _authServices = AuthServices.instance();
//
//   final UserServices _userServices = UserServices();
//
//   ///Register new user and Add its details in Firestore
//   Future<String> registerNewUser({
//     required String email,
//     required String password,
//     required UserModel userModel,
//     required BuildContext context,
//   }) async {
//     _status = SignUpStatus.Registering;
//     notifyListeners();
//
//     try {
//       User? user = await _authServices.signUp(
//         context,
//         email: email,
//         password: password,
//       );
//
//       if (user != null) {
//         setState(SignUpStatus.Registering); // Keep as registering until user is created
//
//         // Create user in database
//         await _userServices.createUser(
//           context,
//           model: userModel,
//           userID: user.uid,
//         );
//
//         setState(SignUpStatus.Registered);
//         return user.uid; // Return user ID on success
//       } else {
//         setState(SignUpStatus.Failed);
//         return 'ERROR: User registration failed';
//       }
//     } catch (e) {
//       setState(SignUpStatus.Failed);
//       return 'ERROR: ${e.toString()}';
//     }
//   }
// }
