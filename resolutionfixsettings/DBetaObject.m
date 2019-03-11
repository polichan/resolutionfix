//
//  DBetaObject.m
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/5.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DBetaObject.h"
#import "DRequest.h"
#import "DEncryption.h"
#import "DRSACryption.h"
#import "ACPlainStringManager.h"
#import "DTrailTimeManager.h"

@interface DBetaObject()
@end

@implementation DBetaObject

+ (void)verifyBetaWithServerURL:(NSString *)url bundleName:(NSString *)bundleName udid:(NSString *)udid publicKey:(NSString *)publicKey publicKeyPem:(NSString *)publicKeyPem verifySuccessBlock:(VerifySuccessBlock)verifySuccessBlock verifyFailureBlock:(VerifyFailureBlock)verifyFailureBlock{
    NSDictionary *dict = @{
                           @"package":bundleName,
                           @"udid":udid
                           };
    NSDictionary *requestDict = [DEncryption encryptWithDictionary:dict publicKey:publicKey];
    [DRequest postWithUrlString:url parameters:requestDict success:^(NSDictionary *dict) {
        NSLog(@"dict----->%@",dict);
        NSString *code = [dict valueForKey:@"code"];
        NSInteger checkCode = [code integerValue];
        // 如果状态码是 200
        if (checkCode == 200) {
            NSString *status = [dict valueForKey:@"status"];
            NSString *created_time = [dict valueForKey:@"created_time"];
            NSString *future_time = [dict valueForKey:@"future_time"];
            NSString *license = [dict valueForKey:@"license"];
            NSString *message = [dict valueForKey:@"message"];
            NSString *signature = [dict valueForKey:@"signature"];
            NSString *time = [dict valueForKey:@"time"];
            ACPlainStringManager *plainStringManager = [[ACPlainStringManager alloc]init];
            NSString *plainString = [plainStringManager trailerWithPlainStringAppendingByCode:code createdTime:created_time futureTime:future_time license:license message:message status:status time:time];
            NSString *licensePlainString = [plainStringManager trailerLicenseWithPlainStringAppendingByPackage:bundleName udid:udid createdTime:created_time futureTime:future_time];
            DRSACryption *rsaCryption = [[DRSACryption alloc]init];
            SecKeyRef pubKey = [DRSACryption publicKeyFromPem:publicKeyPem keySize:2048];
            rsaCryption.publicKey = pubKey;
            BOOL result = [rsaCryption rsaSHA256VertifyingString:plainString withSignature:signature];
            if (result) {
                // 如果签名通过
               BOOL p =  [DTrailTimeManager compareWithCreatedTime:created_time futureTime:future_time currentTime:time];
                if (p) {
                    //设置为未过期
                    verifySuccessBlock(NO,license,licensePlainString);
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
//                    [dict setObject:license forKey:@"license"];
//                    [dict setObject:licensePlainString forKey:@"plainString"];
//                    NSNotification *notif = [NSNotification notificationWithName:@"signatureSuccess" object:nil userInfo:dict];
//                    [[NSNotificationCenter defaultCenter]postNotification:notif];
                }
            }else{
                verifyFailureBlock(YES);
            }
        }else if(checkCode == 406){
            verifyFailureBlock(YES);
//            NSNotification *notif = [NSNotification notificationWithName:@"expired" object:nil];
//            [[NSNotificationCenter defaultCenter]postNotification:notif];
        }else if(checkCode == 403){
            verifyFailureBlock(YES);
//            NSNotification *notif = [NSNotification notificationWithName:@"invalidPackage" object:nil];
//            [[NSNotificationCenter defaultCenter]postNotification:notif];
        }
    } failure:^(NSError *error) {
        NSLog(@"error---->%@",[error localizedDescription]);
    }];
}

@end
