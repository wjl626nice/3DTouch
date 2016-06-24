//
//  ViewController.m
//  02-PreviewUsingSegue
//
//  Created by 青云-wjl on 16/4/17.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *sampleDatas;
@end

@implementation FirstViewController
-(NSArray *)sampleDatas{
    if (_sampleDatas == nil) {
        _sampleDatas = @[@"item1",@"item2",@"item3"];
    }
    return _sampleDatas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //判断设置是否支持 3D touch 功能
    if (self.traitCollection.forceTouchCapability != UIForceTouchCapabilityAvailable) {
        //弹出视图提示用户（该设备不支持 3D Touch 功能）
    }
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sampleDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.sampleDatas[indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //判断触发这个segue的是个cell
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        //获取目标视图控制器
        UIViewController *destinationVC = segue.destinationViewController;
        //destinationVC.preferredContentSize = CGSizeMake(0, 360);
        
        NSString *destinationString = ((UITableViewCell *)sender).textLabel.text;
        [destinationVC setValue:destinationString forKey:@"sampleTitle"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
