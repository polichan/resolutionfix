//
//  NSString+URL.h
//  RSA
//
//  Created by 陈鹏宇 on 2019/3/4.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;
@end

NS_ASSUME_NONNULL_END
