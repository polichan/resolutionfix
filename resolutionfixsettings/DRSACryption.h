//
//  DRSACryption.h
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/6.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRSACryption : NSObject
@property (nonatomic, assign)SecKeyRef publicKey;
/**
 loadPublicKeyFromPem

 @param pemFile the path of publicKey.pem
 @param size 2048
 @return publicKey
 */
+ (SecKeyRef )publicKeyFromPem:(NSString *)pemFile keySize:(size_t )size;
/**
 *  Vertification of Sign 256
 *
 *  @param plainString The string for verifying
 *  @param signature The string of signed
 *
 *  @return Success of sha vertifying
 */
- (BOOL)rsaSHA256VertifyingString:(NSString *)plainString withSignature:(NSString *)signature;

@end
