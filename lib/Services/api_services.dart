import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inbetrieb/Models/SignUp_LogIn_Model.dart';
import 'package:inbetrieb/Models/api_response.dart';
import 'package:inbetrieb/Models/forgetPasswordModel.dart';

class ApiServices {

               // SIGN UP API FUNCTION
  Future<APIResponse<SignUpLogInClass>> signUpAPI(Map data) async {

    String signupApiUrl = 'https://tree.eigix.net/public/api/signup';
    return http.post(Uri.parse(signupApiUrl), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);

        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse
            .fromMap(json.decode(value.body))
            .status,
        message: APIResponse
            .fromMap(json.decode(value.body))
            .message,
      );
    }).onError((error, stackTrace) =>
        APIResponse<SignUpLogInClass>(
          status: error.toString(),
          message: stackTrace.toString(),
        ),
    );
  }

              // LOG IN API FUNCTION
  Future<APIResponse<SignUpLogInClass>> logInAPI(Map data) async {
    String signInApiUrl = 'https://tree.eigix.net/public/api/login';
    return http.post(Uri.parse(signInApiUrl), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<SignUpLogInClass>(
      status: error.toString(),
      message: stackTrace.toString(),
    ));
  }

             // FORGET PASSWORD API FUNCTION
  Future<APIResponse<DataForget>> forgetPassword(Map data) async {
    String api = 'https://tree.eigix.net/public/api/forget_password';
    return http.post(Uri.parse(api), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['data'] != null) {
          final itemCat = DataForget.fromMap(jsonData['data']);
          return APIResponse<DataForget>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<DataForget>(
              data: DataForget(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<DataForget>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<DataForget>(
      status: error.toString(),
      message: stackTrace.toString(),
    ));
  }

            // modify password using otp api
  Future<APIResponse<SignUpLogInClass>> updateForgetPassword(Map data) {
    String api = 'https://tree.eigix.net/public/api/reset_password';
    return http.post(Uri.parse(api), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse
            .fromMap(json.decode(value.body))
            .status,
        message: APIResponse
            .fromMap(json.decode(value.body))
            .message,
      );
    }).onError((error, stackTrace) =>
        APIResponse<SignUpLogInClass>(
          status: error.toString(),
          message: stackTrace.toString(),
        ),
    );
  }

}