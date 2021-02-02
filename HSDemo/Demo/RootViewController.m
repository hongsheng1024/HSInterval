//
//  RootViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//  测试localDevelop分支

#import "RootViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *myTableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:@"内存管理-HSMemoryViewController"];
    [_dataArray addObject:@"Block-HSBlockViewController"];
    [_dataArray addObject:@"定时器-HSTimerViewController"];
    [_dataArray addObject:@"方法调用顺序-HSLoadViewController"];
    [_dataArray addObject:@"KVO和KVC-HSKVViewController"];
    [_dataArray addObject:@"多线程-HSThreadController"];
    [_dataArray addObject:@"RunLoop-HSRunLoopViewController"];
    [_dataArray addObject:@"Runtime-HSRuntimeViewController"];
    [_dataArray addObject:@"UI操作-HSUIViewController"];
    [_dataArray addObject:@"画图-HSDrawViewController"];
    [_dataArray addObject:@"手势讲解-GesViewController"];
    [_dataArray addObject:@"图文混排-GraphicMixedViewController"];
    
    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identificater = @"hsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificater];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificater];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *msg = _dataArray[indexPath.row];
    NSString *clsMsg = [msg componentsSeparatedByString:@"-"].lastObject;
    BaseViewController *VC = [[NSClassFromString(clsMsg) alloc]init];
    VC.funTitle = [msg componentsSeparatedByString:@"-"].firstObject;
    [self.navigationController pushViewController:VC animated:YES];
    
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
