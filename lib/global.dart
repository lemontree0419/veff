import 'package:firebase_auth/firebase_auth.dart';

String currentUserID = FirebaseAuth.instance.currentUser!.uid;
String? chosenAge;
String? chosenCountry;
String? chosenCity;
String? chosenGender;
String fcmServerToken = "key=AAAAMNyXi2A:APA91bGZmRHpi2kEw_T8aCSnSB8GG_8ObZxkf7ZhJ2Y_afnGXsK4hT5lGpkXMQm59XX9zZn-RLrF6SeoDr3komUrA6lYjFJTwpmjaVmyRXPdITS6yl7cm_uFs_0qjf2FNvPWi9QIMh7F";