//
//  SNImgFeatureCheckRequest.m
//  sohunews
//
//  Created by 李腾 on 2017/1/19.
//  Copyright © 2017年 Sohu.com. All rights reserved.
//

#import "SNImgFeatureCheckRequest.h"

@implementation SNImgFeatureCheckRequest

#pragma mark - SNRequestProtocol

- (SNRequestMethod)sn_requestMethod {
    return SNRequestMethodPost;
}

- (NSString *)sn_requestUrl {
    return SNLinks_Path_ImgFeatureCheck;
}

- (id)sn_parameters {
    
    return [super sn_parameters];
}

@end
