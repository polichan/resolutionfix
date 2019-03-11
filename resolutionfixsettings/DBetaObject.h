//
//  DBetaObject.h
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/5.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^VerifySuccessBlock)(BOOL expired,NSString *license,NSString *plainString);
typedef void (^VerifyFailureBlock)(BOOL expired);

@interface DBetaObject : NSObject
+ (void)verifyBetaWithServerURL:(NSString *)url bundleName:(NSString *)bundleName udid:(NSString *)udid publicKey:(NSString *)publicKey publicKeyPem:(NSString *)publicKeyPem verifySuccessBlock:(VerifySuccessBlock)verifySuccessBlock verifyFailureBlock:(VerifyFailureBlock)verifyFailureBlock;
@end
