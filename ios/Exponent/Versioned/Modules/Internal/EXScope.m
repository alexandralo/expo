// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXScope.h"
#import "EXVersionManager.h"
#import "EXFileSystem.h"
#import "EXUnversioned.h"

#import <React/RCTAssert.h>

EX_DEFINE_SCOPED_MODULE(EXScope, scope)

@implementation EXScope

+ (NSString *)moduleName { return @"ExponentScope"; }

- (instancetype)initWithParams:(NSDictionary *)params
{
  NSDictionary *manifest = params[@"manifest"];
  RCTAssert(manifest, @"Need manifest to get experience id.");
  NSString *experienceId = manifest[@"id"];
  return [self initWithExperienceId:experienceId kernelModule:nil params:params];
}

- (instancetype)initWithExperienceId:(NSString *)experienceId kernelModule:(id)unversionedKernelModule params:(NSDictionary *)params
{
  if (self = [super initWithExperienceId:experienceId kernelModule:unversionedKernelModule params:params]) {
    NSString *subdir = [EXVersionManager escapedResourceName:self.experienceId];
    _documentDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
                           stringByAppendingPathComponent:@"ExponentExperienceData"]
                          stringByAppendingPathComponent:subdir];
    _cachesDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                         stringByAppendingPathComponent:@"ExponentExperienceData"]
                        stringByAppendingPathComponent:subdir];

    _initialUri = params[@"initialUri"];
    if (params[@"constants"] && params[@"constants"][@"appOwnership"]) {
      _appOwnership = params[@"constants"][@"appOwnership"];
    }
  }
  return self;
}

- (NSString *)scopedPathWithPath:(NSString *)path withOptions:(NSDictionary *)options
{
  NSString *prefix = _documentDirectory;
  if ([options objectForKey:@"cache"] && [[options objectForKey:@"cache"] boolValue]) {
    prefix = _cachesDirectory;
  }

  if (![EXFileSystem ensureDirExistsWithPath:prefix]) {
    return nil;
  }

  NSString *scopedPath = [[NSString stringWithFormat:@"%@/%@", prefix, path] stringByStandardizingPath];
  if ([scopedPath hasPrefix:[prefix stringByStandardizingPath]]) {
    return scopedPath;
  } else {
    return nil;
  }
}

- (NSString *)apnsToken
{
  // TODO: this is a hack until we formalize kernelspace modules and provide real access to this.
  // at the moment it duplicates logic inside EXRemoteNotificationManager.
  NSData *apnsData = [[NSUserDefaults standardUserDefaults] objectForKey:EX_UNVERSIONED(@"EXCurrentAPNSTokenDefaultsKey")];
  if (apnsData) {
    NSCharacterSet *brackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    return [[[apnsData description] stringByTrimmingCharactersInSet:brackets] stringByReplacingOccurrencesOfString:@" " withString:@""];
  }
  return nil;
}

@end

