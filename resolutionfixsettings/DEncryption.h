//
//  DEncryption.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/9.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEncryption : NSObject
+ (NSDictionary *)encryptWithDictionary:(NSDictionary *)dict publicKey:(NSString *)publicKey;
@end
