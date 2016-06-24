//
//  ShortcutDetailViewController.m
//  01-HomeScreenQuickAction
//
//  Created by 青云-wjl on 16/4/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ShortcutDetailViewController.h"
#import "Common.h"
@interface ShortcutDetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIApplicationShortcutItem *shortcutItem;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic, strong) NSArray *pickerItems;

@end

@implementation ShortcutDetailViewController

-(NSArray *)pickerItems {
    if (_pickerItems == nil) {
        _pickerItems = @[@"Compose", @"Play", @"Pause", @"Add", @"Location", @"Search", @"Share"];
    }
    return _pickerItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleField.text = _shortcutItem.localizedTitle;
    _subTitleField.text = _shortcutItem.localizedSubtitle;
    //NSLog(@"%@",_shortcutItem.userInfo);
    //假如你提供了userInfo，那么提出出来设定的icon type
    NSDictionary *userInfo = _shortcutItem.userInfo;
    if (userInfo.count != 0) {
        NSInteger selectedRow = [userInfo[ApplicationShortcutUserInfoIconKey] integerValue];
        [_pickView selectRow:selectedRow inComponent:0 animated:NO];
    }
    
    //添加通知中心监听(监听当textField文本已经发生改变的的时候，当文本为空的时候，done不可交互)
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldTextDidChanged:(NSNotification *)notification{
    //NSLog(@"%@",notification.object);
    UITextField *textField = notification.object;
    self.navigationItem.rightBarButtonItem.enabled = textField.text.length == 0 ? NO : YES;
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerItems.count;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerItems[row];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //当点击的是done的时候
    if ([segue.identifier isEqualToString:@"ShortcutDetailUpdated"]) {
        //取出当前pickerView中选中的行（对应的就是UIApplicationShortcutIconType）
        NSInteger selectedRow = [_pickView selectedRowInComponent:0];
        //根据上面获取的UIApplicationShortcutIconType创建UIApplicationShortcutIcon
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:selectedRow];
        //更改_shortcutItem
        _shortcutItem = [[UIApplicationShortcutItem alloc] initWithType:_shortcutItem.type localizedTitle:_titleField.text localizedSubtitle:_subTitleField.text icon:icon userInfo:@{ApplicationShortcutUserInfoIconKey:@(selectedRow)}];
    }
}


@end
