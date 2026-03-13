//
// import 'package:flutter/cupertino.dart';
// import 'package:islamic_marriage_app/application/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../configurations/enums.dart';
// import '../infrastructure/models/user.dart';
// import '../infrastructure/services/auth.dart';
// import '../infrastructure/services/user.dart';
// import 'error_string.dart';
//
//
// class LoginBusinessLogic {
//   final UserServices _userServices = UserServices();
//
//   /// Unified Login Logic for Client & Waiter
//   Future<UserModel?> loginUserLogic(
//       BuildContext context, {
//         required String email,
//         required String password,
//         required bool isRemember,
//         required bool isClientSelected,
//       }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var login = Provider.of<AuthServices>(context, listen: false);
//     // var chatProvider = Provider.of<ChatUserProvider>(context, listen: false);
//     var userProvider = Provider.of<UserProvider>(context, listen: false);
//     var auth = Provider.of<AuthServices>(context, listen: false);
//     var errorString = Provider.of<ErrorString>(context, listen: false);
//
//     return login.signIn(context, email: email, password: password).then(
//           (User? user) async {
//         if (user != null) {
//           return await _userServices.getUpdatedUserData(user.uid).then((event) {
//             if (event.isClient == isClientSelected) {
//               /// Role matches selected tab
//               // userProvider.saveUserDate(event);
//               // chatProvider.saveUserDetails(ChatUserModel(
//               //   docId: event.docId, name: event.name, image: event.image
//               // ));
//               prefs.setString("USER_DATA", userModelToJson(event));
//               prefs.setBool("LOGIN_STATUS", true);
//               return event;
//             } else {
//               /// Wrong tab (client trying waiter or waiter trying client)
//               auth.setState(Status.Unauthenticated);
//
//               if (event.isClient && !isClientSelected) {
//                 errorString.saveErrorString(
//                   "This account is registered as a Client. Please login as Client.",
//                 );
//               } else if (!event.isClient && isClientSelected) {
//                 errorString.saveErrorString(
//                   "This account is registered as a Waiter. Please login as Waiter.",
//                 );
//               } else {
//                 errorString.saveErrorString("Role mismatch. Please try again.");
//               }
//
//               return null;
//             }
//           });
//         } else {
//           return null;
//         }
//       },
//     );
//   }
//
// }
//
