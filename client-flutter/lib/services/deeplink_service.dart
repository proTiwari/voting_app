// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/globals.dart' as globals;

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');
  ValueNotifier<String> moneyreferrerCode = ValueNotifier<String>('');


  var dynamicLink = FirebaseDynamicLinks.instance;

  handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    if (data != null) {
      try {
        globals.dynamiclink = data.link.toString().split("%22")[1].split('refer-')[1];

      } catch (e) {
        return null;
      }

      _handleDeepLink(data);
    }

    //handle foreground
    // data.onLink.listen((event) {
    //   var result = _handleDeepLink(event);
    //   return result;
    // }).onError((v) {
    //   debugPrint('Failed: $v');
    //   return null;
    // });
  }

  Future<String> createReferLink(String referCode, property) async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://evotingapp.page.link',
      link: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.pucosa.bvoting&/refer?code="$referCode"'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.pucosa.bvoting&/refer?code="$referCode"'),
        packageName: 'com.pucosa.bvoting',
        minimumVersion: 4,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Join Out Voting Event Now',
        description: '',
        imageUrl: Uri.parse(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3VQEM57ArMza1oYaCqDoz4ZA1xOyeQF234w&usqp=CAU'),
      ),
    );

    final shortLink = await dynamicLink.buildLink(dynamicLinkParameters);

    return shortLink.toString();
  }

  _handleDeepLink(PendingDynamicLinkData data) async {
    dynamicLink = data.link as FirebaseDynamicLinks;
    return dynamicLink;
  }

  static Future<String?> checkForInviteId(PendingDynamicLinkData? data) async {
    print('dynamic link data: ${data?.link}');
    if (data != null) {
      try {
        if(data.link.path == '/invite') {
          return data.link.queryParameters['inviteId'];
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<Uri> createInviteDeepLink(String inviteId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://evotingapp.page.link',
      link: Uri.parse('https://bvoting.pucosa.com/invite?inviteId=$inviteId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.pucosa.bvoting',
      ),
    );

    final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicUrl.shortUrl;
  }
}
