//
//  PreviewDeatil.m
//  02-PreviewUsingDelegate
//
//  Created by 青云-wjl on 16/4/17.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "PreviewDeatilModel.h"

@implementation PreviewDeatilModel

-(instancetype)initWithTitle:(NSString *)title preferredHeight:(float)height{
    if (self = [super init]) {
        _title = title;
        _preferredHeight = height;
    }
    return self;
}
+(instancetype)modelWithTitle:(NSString *)title preferredHeight:(float)height{
    return [[self alloc] initWithTitle:title preferredHeight:height];
}

@end
