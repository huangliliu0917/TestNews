//
//  SNSearchSuggestV2Request.m
//  sohunews
//
//  Created by 李腾 on 2017/1/13.
//  Copyright © 2017年 Sohu.com. All rights reserved.
//

#import "SNSearchSuggestV2Request.h"

@implementation SNSearchSuggestV2Request

#pragma mark - SNRequestProtocol

- (SNRequestMethod)sn_requestMethod {
    return SNRequestMethodGet;
}

- (NSString *)sn_requestUrl {
    return SNLinks_Path_Search_SuggestV2;
}

- (id)sn_parameters {

    return [super sn_parameters];
}

@end
