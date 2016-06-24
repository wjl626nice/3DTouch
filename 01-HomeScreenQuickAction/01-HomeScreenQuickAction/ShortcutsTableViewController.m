//
//  ViewController.m
//  01-HomeScreenQuickAction
//
//  Created by 青云-wjl on 16/3/31.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ShortcutsTableViewController.h"

@interface ShortcutsTableViewController ()<UITableViewDataSource,UITabBarDelegate>
//声明静态shortcuts，从Info.plist中获取
@property (nonatomic, strong) NSArray <UIApplicationShortcutItem *> *staticShortcuts;
//声明动态dynamicShortcuts ,通过应用程序设置和修改
@property (nonatomic, strong) NSMutableArray <UIApplicationShortcutItem *> *dynamicShortcuts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ShortcutsTableViewController
//懒加载静态快捷方式
-(NSArray <UIApplicationShortcutItem *> *) staticShortcuts {
    if (_staticShortcuts == nil) {
        //从Info.plist中获取UIApplicationShortcutItems，假如不可用，就没有static shortcuts
        NSArray *shortcuts = [NSBundle mainBundle].infoDictionary[@"UIApplicationShortcutItems"];
        if (shortcuts.count == 0) return @[];
        NSMutableArray *shortcutItems = [NSMutableArray array];
        //假如可用，用flatMap
        for (NSDictionary *dict in shortcuts) {
            //成功的创建一个UIApplicationShortcutItem必须需要 UIApplicationShortcutItemType 和 UIApplicationShortcutItemTitle
            NSString *shortcutType = dict[@"UIApplicationShortcutItemType"];
            NSString *shortcutTitle = dict[@"UIApplicationShortcutItemTitle"];
            if (shortcutType.length !=0 && shortcutTitle != 0) {
                //获取本地化的标题
                NSString *localizedShortcutTitle = [NSBundle mainBundle].localizedInfoDictionary[shortcutTitle];
                //假如副标题存在，获取副标题
                NSString *shortcutSubtitle = dict[@"UIApplicationShortcutItemSubtitle"];
                NSString *localizedShortcutSubtitle = nil;
                if (shortcutSubtitle.length != 0) {
                    localizedShortcutSubtitle = [NSBundle mainBundle].localizedInfoDictionary[shortcutSubtitle];
                }
                UIApplicationShortcutItem *applicationShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:shortcutType localizedTitle:localizedShortcutTitle localizedSubtitle:localizedShortcutSubtitle icon:nil userInfo:nil];
                [shortcutItems addObject:applicationShortcutItem];
            };
        }
        _staticShortcuts = shortcutItems;
    }
    return _staticShortcuts;
}
//懒加载动态快捷方式
-(NSMutableArray <UIApplicationShortcutItem *> *)dynamicShortcuts {
    if (_dynamicShortcuts == nil) {
        _dynamicShortcuts = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
//        for (UIApplicationShortcutItem *item in _dynamicShortcuts) {
//            NSLog(@"%@",item.userInfo);
//        }
    }
    return _dynamicShortcuts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark  -UITableViewDataSouce

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? self.dynamicShortcuts.count : self.staticShortcuts.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIApplicationShortcutItem *shortcutItem = nil;
    //根据section来设置应该显示的是静态/动态快捷方式
    if (indexPath.section == 0) {
        shortcutItem = self.staticShortcuts[indexPath.row];
    }else if (indexPath.section == 1) {
        shortcutItem = self.dynamicShortcuts[indexPath.row];
    }
    //根据获取的快捷方式设置表视图中显示的标题和副标题
    cell.textLabel.text = shortcutItem.localizedTitle;
    cell.detailTextLabel.text = shortcutItem.localizedSubtitle;
    return cell;
}

//设置section头标题
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"Static", @"Dynamic"][section];
}

//第1个section中行点击的时候可以跳转页面
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return _tableView.indexPathForSelectedRow.section ? YES : NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoShortcutDetailVC"]) {
        UIViewController *destVC = segue.destinationViewController;
        [destVC setValue:self.dynamicShortcuts[_tableView.indexPathForSelectedRow.row] forKey:@"shortcutItem"];
    }
}

-(IBAction)done:(UIStoryboardSegue *)unwindSegue{
    //取出当前unwindSegue的源视图控制器（ShortcuteDetailViewController）
    UIViewController *sourceVC = [unwindSegue sourceViewController];
    //获取源视图控制器中已经更改的快捷方式
    UIApplicationShortcutItem *updateShortcutItem = [sourceVC valueForKey:@"shortcutItem"];
    //更改当前的self.dynamicShortcuts数组中对应的快捷方式
    [self.dynamicShortcuts replaceObjectAtIndex:_tableView.indexPathForSelectedRow.row withObject:updateShortcutItem];
    //重置应用程序的动态快捷方式
    [UIApplication sharedApplication].shortcutItems = self.dynamicShortcuts;
    //刷新更改的行
    [_tableView reloadRowsAtIndexPaths:@[_tableView.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(IBAction)cancel:(UIStoryboardSegue *)unwindSegue{}

@end
