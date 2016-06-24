//
//  SecondViewController.m
//  02-PreviewUsingDelegate
//
//  Created by 青云-wjl on 16/4/17.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic, strong) NSString *sampleTitle;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _sampleTitle;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *action1 = [self previewActionForTitle:@"Default Action" style:UIPreviewActionStyleDefault];
    UIPreviewAction *action2 = [self previewActionForTitle:@"Destructive Action" style:UIPreviewActionStyleDestructive];
    
    UIPreviewAction *subAction1 = [self previewActionForTitle:@"Sub Action 1" style:UIPreviewActionStyleDefault];
    UIPreviewAction *subAction2 = [self previewActionForTitle:@"Sub Action 2" style:UIPreviewActionStyleDefault];
    UIPreviewActionGroup *actionGroup = [UIPreviewActionGroup actionGroupWithTitle:@"Sub Actions..." style:UIPreviewActionStyleDefault actions:@[subAction1,subAction2]];
    return @[action1,action2,actionGroup];
}

-(UIPreviewAction *)previewActionForTitle:(NSString *)title style:(UIPreviewActionStyle)style{
    
    return [UIPreviewAction actionWithTitle:title style:style handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"title:%@",title);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
