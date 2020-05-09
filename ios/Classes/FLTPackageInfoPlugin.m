// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTPackageInfoPlugin.h"

@implementation FLTPackageInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/package_info"
                                  binaryMessenger:[registrar messenger]];
  FLTPackageInfoPlugin* instance = [[FLTPackageInfoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"getAll"]) {
      NSDictionary *replaceKey = @{
          @"CFBundleDisplayName":@"appName",
          @"CFBundleShortVersionString":@"version",
          @"CFBundleVersion":@"buildNumber",
          @"CFBundleIdentifier":@"packageName"
      };
      NSMutableDictionary *infoDic = [NSMutableDictionary new];
      NSDictionary *info = [NSBundle mainBundle].infoDictionary;
      for (NSString *key in info.allKeys) {
          if ([replaceKey objectForKey:key]) {
            [infoDic setValue:[info objectForKey:key] forKey:[replaceKey objectForKey:key]];
          }else
          [infoDic setValue:[info objectForKey:key] forKey:key];
      }
      result(infoDic);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
