import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import '../application/connectivity_status.dart';
import '../configurations/back_end_configs.dart';
import 'models/error.dart';

var logger = Logger();

class ApiBaseHelper {

  String _getMimeType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }


  Future<Either<GlobalErrorModel, dynamic>> putMultipart({
    required String endPoint,
    required Map<String, File> files,
    required Map<String, String> fields,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
          value,
          ) async {
        if (value == true) {
          var request = http.MultipartRequest(
            'PUT',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );

          if (header != null) {
            request.headers.addAll(header);
          }

          fields.forEach((key, value) {
            request.fields[key] = value;
          });

          for (var entry in files.entries) {
            String fieldName = entry.key;
            File file = entry.value;
            String fileName = file.path.split('/').last;
            String mimeType = _getMimeType(fileName);

            request.files.add(
              await http.MultipartFile.fromPath(
                fieldName,
                file.path,
              ),
            );
          }

          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }
  Future<Either<GlobalErrorModel, dynamic>> getEither({
    required String endPoint,
    required bool isRequiredHeader,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    // ignore: prefer_typing_uninitialized_variables
    Either<GlobalErrorModel, dynamic> responseJson;
    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          final response = await http.get(
            Uri.parse(BackendConfigs.apiUrl + endPoint),
            headers: isRequiredHeader ? header! : null,
          );
          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> postGroupPostEither({
    required String groupId,
    required String postText,
    required File? media,
    required String? checkIn,
    required String? feeling,
    required List<String>? taggedPeople,
    required String token,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
          value,
          ) async {
        if (value == true) {
          final uri = Uri.parse(BackendConfigs.apiUrl + 'social/group-posts');
          final request = http.MultipartRequest('POST', uri);
          request.headers.addAll({'Authorization': 'Bearer $token'});
          request.fields['groupId'] = groupId;
          request.fields['postText'] = postText;
          if (checkIn != null && checkIn.trim().isNotEmpty) {
            request.fields['checkIn'] = checkIn;
          }
          if (feeling != null && feeling.trim().isNotEmpty) {
            request.fields['feeling'] = feeling;
          }
          if (taggedPeople != null && taggedPeople.isNotEmpty) {
            request.fields['taggedPeople'] = taggedPeople.join(',');
          }
          if (media != null && await media.exists()) {
            final multipartFile = await http.MultipartFile.fromPath(
              'media',
              media.path,
            );
            request.files.add(multipartFile);
          }
          final response = await request.send();
          final responseString = await response.stream.bytesToString();

          final Map<String, dynamic> responseData = jsonDecode(responseString);

          if (response.statusCode == 200 || response.statusCode == 201) {
            responseJson = Right(responseData);
          } else {
            responseJson = Left(
              GlobalErrorModel(
                error: responseData['message'] ?? 'Failed to create post',
              ),
            );
          }
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> /api/social/group-posts || Status Code -> ${response.statusCode.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );

          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      logger.e("Unexpected Error: ${e.toString()}");
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }
  Future<Either<GlobalErrorModel, dynamic>> postEither({
    required String endPoint,
    required bool isRequiredHeader,
    required bool hasBody,
    dynamic body,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    // ignore: prefer_typing_uninitialized_variables
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          final response = await http.post(
            Uri.parse(BackendConfigs.apiUrl + endPoint),
            headers: isRequiredHeader ? header! : null,
            body: hasBody == true ? jsonEncode(body) : null,
          );

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> putEither({
    required String endPoint,
    required bool isRequiredHeader,
    required bool hasBody,
    dynamic body,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          final response = await http.put(
            Uri.parse(BackendConfigs.apiUrl + endPoint),
            headers: isRequiredHeader ? header! : null,
            body: hasBody == true ? jsonEncode(body) : null,
          );

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> putMultipartEither({
    required String endPoint,
    required bool isRequiredHeader,
    Map<String, String>? header,
    List<String>? imagesPaths,
    String? videoPath,
    String? voicePath,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          var request = http.MultipartRequest(
            'PUT',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );

          if (isRequiredHeader && header != null) {
            request.headers.addAll(header);
          }

          if (imagesPaths != null && imagesPaths.isNotEmpty) {
            for (String imagePath in imagesPaths) {
              request.files.add(
                await http.MultipartFile.fromPath('images', imagePath),
              );
            }
          }

          // Add video
          if (videoPath != null && videoPath.isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath('video', videoPath),
            );
          }

          if (voicePath != null && voicePath.isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath('voice', voicePath),
            );
          }

          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }
  Future<Either<GlobalErrorModel, dynamic>> putIdentityEither({
    required String endPoint,
    required bool isRequiredHeader,
    required String frontImagePath,
    required String backImagePath,
    String? type,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((value) async {
        if (value == true) {
          // Create multipart request
          var request = http.MultipartRequest(
            'PUT',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );

          // Add headers
          if (isRequiredHeader && header != null) {
            request.headers.addAll(header);
          }

          // Add type field (if provided)
          if (type != null && type.isNotEmpty) {
            request.fields['type'] = type;
          }

          // Add front image
          request.files.add(
            await http.MultipartFile.fromPath(
              'frontImage',
              frontImagePath,
            ),
          );

          // Add back image
          request.files.add(
            await http.MultipartFile.fromPath(
              'backImage',
              backImagePath,
            ),
          );

          // Send request
          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> putSelfieEither({
    required String endPoint,
    required bool isRequiredHeader,
    required String selfieImagePath,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((value) async {
        if (value == true) {
          // Create multipart request
          var request = http.MultipartRequest(
            'PUT',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );

          // Add headers
          if (isRequiredHeader && header != null) {
            request.headers.addAll(header);
          }

          // Add selfie image
          request.files.add(
            await http.MultipartFile.fromPath(
              'selfieImage',
              selfieImagePath,
            ),
          );

          // Send request
          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> deleteEither({
    required String endPoint,
    required bool isRequiredHeader,
    required bool hasBody,
    dynamic body,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    // ignore: prefer_typing_uninitialized_variables
    Either<GlobalErrorModel, dynamic> responseJson;
    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          final response = await http.delete(
            Uri.parse(BackendConfigs.apiUrl + endPoint),
            headers: isRequiredHeader ? header! : null,
            body: hasBody == true ? jsonEncode(body) : null,
          );
          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      return Left(GlobalErrorModel(error: "Something went wrong."));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> postMultiPartEither({
    required String endPoint,
    required bool isRequiredHeader,
    required bool hasBody,
    String? path,
    required bool hasFile,
    dynamic body,
    Map<String, String>? header,
  }) async {
    log(body.toString());
    DateTime executionTime = DateTime.now();
    // ignore: prefer_typing_uninitialized_variables
    Either<GlobalErrorModel, dynamic> responseJson;
    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );
          if (hasBody) request.fields.addAll(body);
          request.headers.addAll(header!);
          if (hasFile) {
            request.files.add(await http.MultipartFile.fromPath('file', path!));
          }
          http.StreamedResponse streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);

          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Status Code -> ${response.reasonPhrase.toString()} || ${DateTime.now()}",
          );

          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      rethrow;
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }

  Future<Either<GlobalErrorModel, dynamic>> postMultipleImageMultiPartEither({
    required String endPoint,
    required bool isRequiredHeader,
    required bool hasBody,
    List<String>? path,
    required bool hasFile,
    dynamic body,
    Map<String, String>? header,
  }) async {
    log(body.toString());
    DateTime executionTime = DateTime.now();
    // ignore: prefer_typing_uninitialized_variables
    Either<GlobalErrorModel, dynamic> responseJson;
    try {
      return await InternetConnectivityHelper.checkConnectivity().then((
        value,
      ) async {
        if (value == true) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );
          if (hasBody) request.fields.addAll(body);
          request.headers.addAll(header!);
          if (hasFile) {
            // path!.map((e)async{
            request.files.add(
              await http.MultipartFile.fromPath('file', path![0]),
            );
            if (path.length > 1) {
              request.files.add(
                await http.MultipartFile.fromPath('template', path[1]),
              );
            }

            // }).toList();
          }
          http.StreamedResponse streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          responseJson = _returnResponseEither(response);

          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Status Code -> ${response.reasonPhrase.toString()} || ${DateTime.now()}",
          );

          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
              "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry." +
              "\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      rethrow;
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }



  /// Ask Mufti - Voice Recording Only
  /// Sends only voice recording as multipart form-data
// In api_helper.dart - Update postMuftiVoiceOnlyEither() method:

  Future<Either<GlobalErrorModel, dynamic>> postMuftiVoiceOnlyEither({
    required String endPoint,
    required bool isRequiredHeader,
    required String voiceRecordingPath,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;

    try {
      return await InternetConnectivityHelper.checkConnectivity().then((value) async {
        if (value == true) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(BackendConfigs.apiUrl + endPoint),
          );

          // Add headers - Remove Content-Type as multipart sets it automatically
          if (isRequiredHeader && header != null) {
            final cleanedHeaders = Map<String, String>.from(header);
            cleanedHeaders.remove('Content-Type');
            request.headers.addAll(cleanedHeaders);
          }

          // Add voice recording file
          if (voiceRecordingPath.isNotEmpty) {
            File voiceFile = File(voiceRecordingPath);

            if (await voiceFile.exists()) {
              List<int> fileBytes = await voiceFile.readAsBytes();

              // Determine file extension
              String extension = voiceRecordingPath.split('.').last.toLowerCase();
              MediaType contentType;
              String filename;

              // Fix MIME type mapping - use audio/mpeg for MP3 and M4A
              switch (extension) {
                case 'mp3':
                  contentType = MediaType('audio', 'mpeg');
                  filename = 'recording.mp3';
                  break;
                case 'm4a':
                // Use audio/mpeg instead of audio/mp4 for better compatibility
                  contentType = MediaType('audio', 'mpeg');
                  filename = 'recording.mp3';  // Rename to .mp3
                  break;
                case 'wav':
                  contentType = MediaType('audio', 'wav');
                  filename = 'recording.wav';
                  break;
                case 'ogg':
                  contentType = MediaType('audio', 'ogg');
                  filename = 'recording.ogg';
                  break;
                case 'webm':
                  contentType = MediaType('audio', 'webm');
                  filename = 'recording.webm';
                  break;
                default:
                // Default to MPEG (MP3)
                  contentType = MediaType('audio', 'mpeg');
                  filename = 'recording.mp3';
              }

              var multipartFile = http.MultipartFile.fromBytes(
                'voiceRecording',
                fileBytes,
                filename: filename,
                contentType: contentType,
              );

              request.files.add(multipartFile);

              logger.i('Voice file added: $filename');
              logger.i('File size: ${fileBytes.length} bytes');
              logger.i('Extension: $extension');
              logger.i('MIME type: ${contentType.mimeType}');
            } else {
              logger.e('Voice file does not exist: $voiceRecordingPath');
              return Left(
                GlobalErrorModel(error: "Voice recording file not found!"),
              );
            }
          } else {
            return Left(
              GlobalErrorModel(error: "Voice recording path is empty!"),
            );
          }

          logger.i('Sending request to: ${BackendConfigs.apiUrl + endPoint}');

          http.StreamedResponse streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          logger.i('Response status code: ${response.statusCode}');
          logger.i('Response body: ${response.body}');

          responseJson = _returnResponseEither(response);

          logger.i(
            "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode.toString()} || Reason Phrase -> ${response.reasonPhrase.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );

          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      logger.i("Socket Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.\nSorry for the inconvenience.",
        ),
      );
    } on HttpException catch (e) {
      logger.i("HTTP Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to complete your request.!",
        ),
      );
    } on TimeoutException catch (e) {
      logger.i("TimeOut Exception");
      logger.e(e.message.toString());
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect our servers.!",
        ),
      );
    } catch (e) {
      logger.e("Ask Mufti Voice API Error: $e");
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }


  Either<GlobalErrorModel, dynamic> _returnResponseEither(
    http.Response response,
  ) {
    log(response.body.toString());
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body.toString());
        return Right(responseJson);
      } else if (response.statusCode == 400) {
        var responseJson = json.decode(response.body.toString());

        var errorModel = GlobalErrorModel.fromJson(responseJson);
        return Left(GlobalErrorModel(error: errorModel.error.toString()));
      } else if (response.statusCode == 401) {
        return Left(
          GlobalErrorModel(
            error: "Sorry! You are not allowed to perform this operation.!",
          ),
        );
      } else if (response.statusCode == 404) {
        var responseJson = json.decode(response.body.toString());

        var errorModel = GlobalErrorModel.fromJson(responseJson);
        return Left(GlobalErrorModel(error: errorModel.error.toString()));
      } else if (response.statusCode == 422) {
        var responseJson = json.decode(response.body.toString());

        var errorModel = GlobalErrorModel.fromJson(responseJson);
        return Left(GlobalErrorModel(error: errorModel.error.toString()));
      } else if (response.statusCode == 403) {
        return Left(GlobalErrorModel(error: "UnAuthorized"));
      } else if (response.statusCode == 500) {
        log(response.reasonPhrase.toString());
        return Left(
          GlobalErrorModel(
            error: "Sorry! We are facing some internal connection issues.!",
          ),
        );
      } else if (response.statusCode == 503) {
        return Left(
          GlobalErrorModel(
            error: "Sorry! We are facing some issues in connection.!",
          ),
        );
      } else {
        return Left(GlobalErrorModel(error: "Sorry! Some thing went wrong!."));
      }
    } catch (e) {
      log(e.toString());
      return Left(GlobalErrorModel(error: "Sorry! Some thing went wrong!."));
    }
  }
  Future<Either<GlobalErrorModel, dynamic>> getEitherWithUri({
    required Uri uri,
    required bool isRequiredHeader,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();
    Either<GlobalErrorModel, dynamic> responseJson;
    try {
      return await InternetConnectivityHelper.checkConnectivity().then((value) async {
        if (value == true) {
          final response = await http.get(
            uri,
            headers: isRequiredHeader ? header! : null,
          );
          responseJson = _returnResponseEither(response);
          logger.i(
            "BaseUrl -> $uri || Status Code -> ${response.statusCode.toString()} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
          );
          return responseJson.fold((l) => Left(l), (r) => Right(r));
        } else {
          return Left(
            GlobalErrorModel(
              error: "Oops! It seems you are not connected to the internet.",
            ),
          );
        }
      });
    } on SocketException catch (e) {
      return Left(GlobalErrorModel(error: "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.\nSorry for the inconvenience."));
    } on HttpException catch (e) {
      return Left(GlobalErrorModel(error: "Sorry! We are unable to complete your request.!"));
    } on TimeoutException catch (e) {
      return Left(GlobalErrorModel(error: "Sorry! We are unable to connect our servers.!"));
    } catch (e) {
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }
  Future<Either<GlobalErrorModel, dynamic>> postMultipartPostEither({
    required String endPoint,
    required String postDescription,
    required String postMediaType,
    List<File>? mediaFiles,
    Map<String, String>? header,
  }) async {
    DateTime executionTime = DateTime.now();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(BackendConfigs.apiUrl + endPoint),
      );
      request.fields['Post_Description'] = postDescription;
      request.fields['Post_Media_Type'] = postMediaType;
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (File file in mediaFiles) {
          request.files.add(
            await http.MultipartFile.fromPath('media_files[]', file.path),
          );
        }
      }
      if (header != null) {
        request.headers.addAll(header);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      var responseJson = _returnResponseEither(response);
      logger.i(
        "BaseUrl -> ${BackendConfigs.baseUrl} || EndPoints -> $endPoint || Status Code -> ${response.statusCode} || Response Time: ${DateTime.now().difference(executionTime).inMilliseconds} ms",
      );
      return responseJson.fold((l) => Left(l), (r) => Right(r));
    } on SocketException catch (e) {
      logger.e("Socket Exception: ${e.message}");
      return Left(
        GlobalErrorModel(
          error:
          "Some of our servers are undergoing maintenance. If you are currently facing difficulty in connecting, kindly wait a little and retry.",
        ),
      );
    } on TimeoutException catch (e) {
      logger.e("TimeOut Exception: ${e.message}");
      return Left(
        GlobalErrorModel(
          error: "Sorry! We are unable to connect to our servers.",
        ),
      );
    } catch (e) {
      logger.e("Exception: $e");
      return Left(GlobalErrorModel(error: e.toString()));
    }
  }
}
