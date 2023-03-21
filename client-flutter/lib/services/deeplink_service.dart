// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/globals.dart';


class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');
  ValueNotifier<String> moneyreferrerCode = ValueNotifier<String>('');

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaanull: ${data}");
    if (data != null) {
      print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${data.link}");
      try {
        dynamiclink = data.link.toString().split("%22")[1].split('refer-')[1];
      } catch (e) {}

      _handleDeepLink(data);
    }

    //handle foreground
    dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      debugPrint('Failed: $v');
    });
  }

  Future<String> createReferLink(String referCode, property) async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://evotingapp.page.link',
      link: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.example.voting_app&/refer?code="$referCode"'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.example.voting_app'),
        packageName: 'com.example.voting_app',
        minimumVersion: 4,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Join Out Voting Event Now',
        description: '',
        imageUrl: Uri.parse('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3VQEM57ArMza1oYaCqDoz4ZA1xOyeQF234w&usqp=CAU'),
      ),
    );

    final shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);

    return shortLink.shortUrl.toString();
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
  }
}
