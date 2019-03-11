//
//  DEncryption.m
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/9.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DEncryption.h"
#import "NSString+URL.h"
#import "RSA.h"
@implementation DEncryption

+ (NSDictionary *)encryptWithDictionary:(NSDictionary *)dict publicKey:(NSString *)publicKey{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    // 将传入进的字典转换为字符串
    NSString *sourceString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 字符串 RSA 加密
    NSString *encryptString = [RSA encryptString:sourceString publicKey:publicKey];
    NSString *urlEncodedString = [encryptString URLEncodedString];
    NSLog(@"----------->%@",urlEncodedString);
    NSDictionary *requestDict = @{
                                  @"secret":urlEncodedString
                                  };
    return requestDict;
}
@end
