//
//  ViewController.m
//  02-PreviewUsingDelegate
//
//  Created by 青云-wjl on 16/4/17.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "FirstViewController.h"
#import "PreviewDeatilModel.h"
@interface FirstViewController ()<UIViewControllerPreviewingDelegate,UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sampleDatas;
@end

@implementation FirstViewController

- (NSArray *)sampleDatas {
    if (_sampleDatas == nil) {
        PreviewDeatilModel *samllPreviewmodel = [PreviewDeatilModel modelWithTitle:@"Small" preferredHeight:160.0];
        PreviewDeatilModel *mediumPreviewmodel = [PreviewDeatilModel modelWithTitle:@"Medium" preferredHeight:320.0];
        PreviewDeatilModel *largePreviewmodel = [PreviewDeatilModel modelWithTitle:@"Large" preferredHeight:0.0];
        _sampleDatas = @[samllPreviewmodel,mediumPreviewmodel,largePreviewmodel];
    }
    return _sampleDatas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //检测当前的设备是否支持force touch功能，如果支持添加 force touch/previewing 的功能
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //为peek和pop注册UIViewControllerPreviewingDelegate，当视图控制器销毁的时候，代理自定取消注册。
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }else{
        //弹出视图，提示用户 @“该设备不支持 3D Touch 功能”
    }
}



#pragma mark - UIViewControllerPreviewingDelegate(iOS9.0之后有效)
//Create a previewing view controller to be shown at "Peek".
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //获取点击的单元格的indexPath
    NSIndexPath *selectedIndexPath = _tableView.indexPathForSelectedRow;
    //根据indexPath获取单元格
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:selectedIndexPath];
    
    //获取当前选中单元格对应的模型
    PreviewDeatilModel *model = self.sampleDatas[_tableView.indexPathForSelectedRow.row];
    
    //获取secondViewController,并且设置属性
    UIViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
    [secondVC setValue:model.title forKey:@"sampleTitle"];
#warning 什么意思
    //通过设置第二个视图控制器的首选的内容大小来设置预览时的高度，宽度需要设置为0.0,因为屏幕正常情况下无用。
    secondVC.preferredContentSize = CGSizeMake(0.0, model.preferredHeight);
    // Set the source rect to the cell frame, so surrounding elements are blurred.
    [previewingContext setSourceRect:cell.frame];
    return secondVC;
}
// Present the view controller for the "Pop" action.
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}



#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sampleDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = ((PreviewDeatilModel *)self.sampleDatas[indexPath.row]).title;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        PreviewDeatilModel *model = self.sampleDatas[_tableView.indexPathForSelectedRow.row];
        UIViewController *destinationVC = segue.destinationViewController;
        [destinationVC setValue:model.title forKey:@"sampleTitle"];
        
    }
}
@end
