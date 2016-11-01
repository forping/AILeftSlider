//
//  LeftViewController.m
//  左侧拉键
//
//  Created by Medalands on 15/9/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"leftbackiamge"]];
    [self.view addSubview:imageView];
    [self creatDataArr];
    [self creatTableView];
    // Do any additional setup after loading the view.
}

- (void) creatDataArr{
    self.dataArr = [NSMutableArray arrayWithObjects:@"美团",@"大宗点评",@"糯米",@"一号院",@"淘宝",@"天猫"@"阿里巴巴", nil];
    
}

- (void) creatTableView{
    self.tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tmpTableView setDelegate:self];
    [self.tmpTableView setDataSource:self];
    [self.tmpTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tmpTableView];
}

// -- 协议
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:self.dataArr[indexPath.row]];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tmpTableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
