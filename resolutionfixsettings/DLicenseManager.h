//
//  DLicenseManager.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/10.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLicenseManager : NSObject

/**
 验证签名类方法

 @param licenseFilePath dat 格式的 license 文件路径
 @param plainStringFilePath dat 格式的 等验证字符串
 @param publicKeyFile 公钥文件，pem 后缀名
 @return 返回值确定了这个签名是否有效
 */
+ (BOOL)verifyLicenseFileWithPath:(NSString *)licenseFilePath plainStringFilePath:(NSString *)plainStringFilePath publicKeyFile:(NSString *)publicKeyFile;
+ (void)generateLicenseWithLicenseString:(NSString *)licenseString atPath:(NSString *)licensePath plainString:(NSString *)plainString atPath:(NSString *)plainStringPath;
@end
