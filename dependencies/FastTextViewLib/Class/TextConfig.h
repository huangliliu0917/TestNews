//
//  TextConfig.h
//  tangyuanReader
//
//  Created by 王 强 on 13-6-8.
//  Copyright (c) 2013年 中文在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeConfig.h"

@interface TextConfig : NSObject
#define ARRSIZE(a) (sizeof(a) / sizeof(a[0]))

+ (AttributeConfig *)editorAttributeConfig;
+ (AttributeConfig *)readerAttributeConfig;
+ (AttributeConfig *)readerTitleAttributeConfig;
+ (NSDictionary *)defaultAttributes;

@end
