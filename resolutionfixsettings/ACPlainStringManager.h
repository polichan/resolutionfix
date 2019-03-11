//
//  ACPlainStringManager.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/9.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ACPlainStringManager : NSObject
- (NSString *)payTweakWithPlainStringAppendingByCode:(NSString *)code orderNumber:(NSString *)orderNumber scheme:(NSString *)scheme status:(NSString *)status url:(NSString *)url;
- (NSString *)getActivationCodeWithPlainStringAppeddingByActivateCode:(NSString *)activateCode code:(NSString *)code status:(NSString *)status;
- (NSString *)activateTweakWithPlainStringAppeningByCode:(NSString *)code license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time;
- (NSString *)activateTweakWithPlainStringAppeningByActivationCode:(NSString *)activationCode udid:(NSString *)udid time:(NSString *)time;
- (NSString *)trailerWithPlainStringAppendingByCode:(NSString *)code createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time;
- (NSString *)trailerLicenseWithPlainStringAppendingByPackage:(NSString *)package udid:(NSString *)udid createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime;
@end

