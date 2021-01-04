// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _kChannel =
    MethodChannel('plugins.flutter.io/g_package_info');

/// Application metadata. Provides application bundle information on iOS and
/// application package information on Android.
///
/// ```dart
/// PackageInfo packageInfo = await PackageInfo.fromPlatform()
/// print("Version is: ${packageInfo.version}");
/// ```
class GPackageInfo {
  /// Constructs an instance with the given values for testing. [GPackageInfo]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  ///
  /// See [fromPlatform] for the right API to get a [GPackageInfo] that's
  /// actually populated with real data.
  GPackageInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
    this.versionCode,
  });

  static GPackageInfo _fromPlatform;

  static Map<String, dynamic> _metaData;

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<GPackageInfo> fromPlatform() async {
    if (_fromPlatform != null) {
      return _fromPlatform;
    }

    final Map<String, dynamic> map =
        await _kChannel.invokeMapMethod<String, dynamic>('getAll');
    _fromPlatform = GPackageInfo(
      appName: map["appName"],
      packageName: map["packageName"],
      version: map["version"],
      buildNumber: map["buildNumber"],
      versionCode: map['versionCode']
    );
    return _fromPlatform;
  }

  /// Retrieves meta data information from the AndroidManifest.xml.
  /// The result is cached.
  static Future<Map<String, dynamic>> withMetaData() async {
    if (_metaData != null) {
      return _metaData;
    }
    final Map<String, dynamic> map =
    await _kChannel.invokeMapMethod<String, dynamic>('getAll');
    _metaData = map;
    return map;
  }

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The package versionCode. only support in android
  final String versionCode;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String buildNumber;

}
