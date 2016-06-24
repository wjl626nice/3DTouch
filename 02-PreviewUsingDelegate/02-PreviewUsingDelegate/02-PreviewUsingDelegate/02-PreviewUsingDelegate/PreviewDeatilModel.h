//
//  PreviewDeatil.h
//  02-PreviewUsingDelegate
//
//  Created by 青云-wjl on 16/4/17.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreviewDeatilModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic)         float preferredHeight;
-(instancetype)initWithTitle:(NSString *)title preferredHeight:(float)height;
+(instancetype)modelWithTitle:(NSString *)title preferredHeight:(float)height;
@end
