// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXScopedBridgeModule.h"

@implementation EXScopedBridgeModule

+ (NSString *)moduleName
{
  NSAssert(NO, @"EXScopedBridgeModule is abstract, you should only export subclasses to the bridge.");
  return @"ExponentScopedBridgeModule";
}

- (instancetype)initWithExperienceId:(NSString *)experienceId kernelModule:(id)unversionedKernelModule params:(NSDictionary *)params
{
  if (self = [super init]) {
    _experienceId = experienceId;
  }
  return self;
}

@end
