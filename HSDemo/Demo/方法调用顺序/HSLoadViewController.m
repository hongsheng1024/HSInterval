//
//  HSLoadViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/3.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSLoadViewController.h"
#import "HSPerson.h"
#import "HSStudent.h"

@interface HSLoadViewController ()

@end

@implementation HSLoadViewController


- (void)loadView{
    [super loadView];
    NSLog(@"%s", __func__);
    //HSPerson *hsPerson = [[HSPerson alloc]init];
    HSStudent *hsStudent = [[HSStudent alloc]init];
    //[HSPerson test];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)dealloc{
    NSLog(@"%s", __func__);
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
