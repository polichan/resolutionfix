//
//  DLicenseManager.m
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/10.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DLicenseManager.h"
#import "DRSACryption.h"
@implementation DLicenseManager

+ (BOOL)verifyLicenseFileWithPath:(NSString *)licenseFilePath plainStringFilePath:(NSString *)plainStringFilePath publicKeyFile:(NSString *)publicKeyFile{
    // 判断是否存在 dat 文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果存在两个文件都存在，则进行下一步
    if ([fileManager fileExistsAtPath:licenseFilePath] && [fileManager fileExistsAtPath:plainStringFilePath]) {
        // 首先从路径中读取 dat 文件
        NSData *signatureData = [NSData dataWithContentsOfFile:licenseFilePath];
        NSData *plainData = [NSData dataWithContentsOfFile:plainStringFilePath];
        // dat 文件转换成 NSString
        NSString *signature  =[[NSString alloc]initWithData:signatureData encoding:NSUTF8StringEncoding];
        NSString *verifyString = [[NSString alloc]initWithData:plainData encoding:NSUTF8StringEncoding];
        // 加载验签类
        DRSACryption *rsaCryption = [[DRSACryption alloc]init];
        SecKeyRef pubKey = [DRSACryption publicKeyFromPem:publicKeyFile keySize:2048];
        rsaCryption.publicKey = pubKey;
        // 利用 BOOL 接收返回值
        BOOL result = [rsaCryption rsaSHA256VertifyingString:verifyString withSignature:signature];
        NSLog(@"121212121%@",result?@"YES":@"NO");
        if (result) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma mark - 生成 dat 文件

+ (void)generateLicenseWithLicenseString:(NSString *)licenseString atPath:(NSString *)licensePath plainString:(NSString *)plainString atPath:(NSString *)plainStringPath{
    if ([licensePath isEqualToString:@""] || [plainStringPath isEqualToString:@""] ) {
        NSLog(@"请传入写文件目录");
    }
    // 转换为 data
    NSData *licenseData = [licenseString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainStringData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    // 判断文件
    NSFileManager *manager = [[NSFileManager alloc]init];

    if ([manager fileExistsAtPath:licensePath] || [manager fileExistsAtPath:plainStringPath]) {
        NSLog(@"文件已经存在");
        NSLog(@"准备删除文件");
        [manager removeItemAtPath:licensePath error:nil];
        [manager removeItemAtPath:plainStringPath error:nil];
        NSLog(@"已经删除");
        NSLog(@"重新写入");
        // 创建文件
        BOOL isSuccess = [manager createFileAtPath:licensePath contents:nil attributes:nil];
        BOOL isPlainStringSuccess = [manager createFileAtPath:plainStringPath contents:nil attributes:nil];
        if (isSuccess && isPlainStringSuccess) {
          NSLog(@"文件创建成功");
          // 写入文件
          [licenseData writeToFile:licensePath atomically:YES];
          [plainStringData writeToFile:plainStringPath atomically:YES];
        }else{
          NSLog(@"文件创建失败");
        }
    }else{
        BOOL isSuccess = [manager createFileAtPath:licensePath contents:nil attributes:nil];
        BOOL isPlainStringSuccess = [manager createFileAtPath:plainStringPath contents:nil attributes:nil];
        if (isSuccess && isPlainStringSuccess) {
        NSLog(@"文件创建成功");
        // 写入文件
        [licenseData writeToFile:licensePath atomically:YES];
        [plainStringData writeToFile:plainStringPath atomically:YES];
      }
    }
}

@end
