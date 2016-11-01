//
//  RootViewController.m
//  左侧拉键
//
//  Created by Medalands on 15/9/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

#import "LeftSliderViewController.h"



#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

@interface RootViewController ()

@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"主界面"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.view setBackgroundColor:[UIColor blueColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 18)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    // Do any additional setup after loading the view.
}


- (void) openOrCloseLeftList{
   
    LeftSliderViewController *leftSlider = [LeftSliderViewController sharedLeftSlider];
    
    [leftSlider openLeftVC];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
