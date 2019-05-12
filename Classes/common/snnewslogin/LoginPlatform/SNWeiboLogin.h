//
//  SNWeiboLogin.h
//  sohunews
//
//  Created by wang shun on 2017/4/7.
//  Copyright © 2017年 Sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "SNThirdLoginSuccess.h"

@interface SNWeiboLogin : NSObject

@property (nonatomic, strong) SNThirdLoginSuccess* thirdLoginSuccess;
@property (nonatomic,strong) NSDictionary* userInfoDic;//绑定之前已经拿到的userinfo

+ (void)weiboLogin:(NSDictionary*)params WithSuccess:(void (^)(NSDictionary*))method;

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end
