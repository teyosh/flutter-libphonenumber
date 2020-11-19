import 'dart:async';

import 'libphonenumber-js.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class LibphonenumberPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'codeheadlabs.com/libphonenumber',
        const StandardMethodCodec(),
        registrar.messenger);
    final LibphonenumberPlugin instance = LibphonenumberPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "isValidPhoneNumber":
        return _handleIsValidPhoneNumber(call);
        break;
      case "normalizePhoneNumber":
        return _handleNormalizePhoneNumber(call);
        break;
      case "nationalizePhoneNumber":
        return _handleNationalizePhoneNumber(call);
        break;
      case "getNumberType":
        return _handleGetNumberType(call);
        break;
      case "formatAsYouType":
        return _formatAsYouType(call);
        break;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The libphonenumber plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  bool _handleIsValidPhoneNumber(MethodCall call) {
    final String phoneNumber = call.arguments["phone_number"];
    final String isoCode = call.arguments["iso_code"];
    try {
      return parsePhoneNumber(phoneNumber, isoCode.toUpperCase()).isValid();
    } on Exception catch (_) {
      // Sometimes invalid phone numbers can cause exceptions, e.g. "+1"
      rethrow;
    }
  }

  String _handleNormalizePhoneNumber(MethodCall call) {
    final String phoneNumber = call.arguments["phone_number"];
    final String isoCode = call.arguments["iso_code"];
    try {
      return parsePhoneNumber(phoneNumber, isoCode.toUpperCase())
          .format('E.164');
    } on Exception catch (_) {
      // Sometimes invalid phone numbers can cause exceptions, e.g. "+1"
      rethrow;
    }
  }

  String _handleNationalizePhoneNumber(MethodCall call) {
    final String phoneNumber = call.arguments["phone_number"];
    final String isoCode = call.arguments["iso_code"];
    try {
      return parsePhoneNumber(phoneNumber, isoCode.toUpperCase())
          .formatNational();
    } on Exception catch (_) {
      // Sometimes invalid phone numbers can cause exceptions, e.g. "+1"
      rethrow;
    }
  }

  int _handleGetNumberType(MethodCall call) {
    final String phoneNumber = call.arguments["phone_number"];
    final String isoCode = call.arguments["iso_code"];

    try {
      final t = parsePhoneNumber(phoneNumber, isoCode.toUpperCase()).getType();
      switch (t) {
        case 'FIXED_LINE':
          return 0;
          break;
        case 'MOBILE':
          return 1;
          break;
        case 'FIXED_LINE_OR_MOBILE':
          return 2;
          break;
        case 'TOLL_FREE':
          return 3;
          break;
        case 'PREMIUM_RATE':
          return 4;
          break;
        case 'SHARED_COST':
          return 5;
          break;
        case 'VOIP':
          return 6;
          break;
        case 'PERSONAL_NUMBER':
          return 7;
          break;
        case 'PAGER':
          return 8;
          break;
        case 'UAN':
          return 9;
          break;
        case 'VOICEMAIL':
          return 10;
          break;
        case 'UNKNOWN':
          return -1;
          break;
        default:
          return -1;
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  String _formatAsYouType(MethodCall call) {
    final String phoneNumber = call.arguments["phone_number"];
    final String isoCode = call.arguments["iso_code"];

    final _asYouType = AsYouType(isoCode.toUpperCase());
    String res;
    for (int i = 0; i < phoneNumber.length; i++) {
      res = _asYouType.input(phoneNumber[i]);
    }
    return res;
  }
}
