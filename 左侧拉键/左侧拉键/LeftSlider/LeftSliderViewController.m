//
//  LeftSliderViewController.m
//  最新的侧滑
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "LeftSliderViewController.h"

#define KScreenWidth       [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight      [[UIScreen mainScreen] bounds].size.height

// -- MainVC 滑到右面剩下的距离
#define KMainVCDisdance    100

// -- mainVC的缩放比例
#define KMainScale         1

// -- mainVC 滑到右面的中心点的位置
#define KMainVCCenter      CGPointMake(KScreenWidth*KMainScale/2 + KScreenWidth-KMainVCDisdance, KScreenHeight/2)

// -- 初始的LeftVCTableView的center的x
#define KLeftVCTableViewCenterX 30

// -- 初始的LeftVC蒙版的透明度
#define KLeftVCContentViewAlpha 0.9

#define KLeftVCContentViewMinAlpha 0.1

#define KMainVCContentViewAlpha 0.5

// -- leftVC的缩放比例
#define KLeftVCTableViewScale 1

// -- 实际滑动距离的比例
#define KSpeed 0.9


@interface LeftSliderViewController ()<UIGestureRecognizerDelegate>
{
    CGFloat scalef;
}

// 左侧的controller
@property (nonatomic , strong) UIViewController *leftVC;

// 中间的controller
@property (nonatomic , strong) UIViewController *mainVC;

// -- 蒙版的View
@property (nonatomic , strong) UIView *leftContentView;

// -- 侧滑的速度 即 手指滑 10 实际滑的为 10 x speed;
@property (nonatomic , assign) CGFloat speed;

@property (nonatomic , strong) UIPanGestureRecognizer *pan;

@property (nonatomic , strong) UITapGestureRecognizer *sideslipTapGes;

@property (nonatomic , strong) UITableView *leftTableView;

// 侧滑展开时mainViewController的蒙版View
@property (nonatomic , strong) UIView *mainContentView;

@end

@implementation LeftSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 单例方法 -
    static id _instance = nil;
+ (instancetype) sharedLeftSlider{
    
    if (_instance == nil) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
    
}

#pragma mark - 构造函数 -
+ (instancetype)creatLeftSliderCotrollerWithLeftViewController:(UIViewController *)leftVC andMainViewController:(UIViewController *)mainViewController{
    return [[[self class] alloc] initWithLeftViewController:leftVC andMainViewController:mainViewController];
}

- (instancetype) initWithLeftViewController:(UIViewController *)leftVC andMainViewController:(UIViewController *)mainVC
{
    self = [super init];
    if (self) {
        // -- 初始化 scalef
        scalef = 0;
        // -- 初始化 speed
        self.speed = KSpeed;
        // -- 初始化显示MainVC
        self.closed = YES;
        /*对leftVC进行初始化*/
        self.leftVC = leftVC;
        // -- 对LeftVC蒙版的View进行设置
        self.leftContentView = [[UIView alloc] initWithFrame:self.leftVC.view.bounds];
        [self.leftContentView setBackgroundColor:[UIColor blackColor]];
        [self.leftContentView setAlpha:0.9];
        [self.leftVC.view addSubview:self.leftContentView];

        // 找到tableView
        for (UITableView *tableView in self.leftVC.view.subviews) {
            if ([tableView isKindOfClass:[UITableView class]]) {
                self.leftTableView = tableView;
            }
        }
        
        [self.leftTableView setFrame:CGRectMake(0, 0, KScreenWidth-KMainVCDisdance, KScreenHeight)];
    
        [self.leftTableView setBackgroundColor:[UIColor clearColor]];
        [self.leftTableView setCenter:CGPointMake(KLeftVCTableViewCenterX, KScreenHeight/2)];
        self.leftTableView.transform = CGAffineTransformMakeScale(KLeftVCTableViewScale, KLeftVCTableViewScale);
        
        [self.view addSubview:self.leftVC.view];
        
        /*对mainVC 进行设置*/
        self.mainVC = mainVC;
        
        [self.view addSubview:self.mainVC.view];
        
        // 蒙版View
        self.mainContentView = [[UIView alloc] initWithFrame:self.mainVC.view.bounds];
        
        [self.mainContentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.mainContentView setAlpha:0];
        
        [self.mainVC.view addSubview:self.mainContentView];
        
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [self.pan setCancelsTouchesInView:YES];
        [self.pan setDelegate:self];
        [self.mainVC.view addGestureRecognizer:self.pan];
           }
    return self;
}

#pragma mark - 滑动收手势 -
/*滑动的手势*/
- (void) panHandle:(UIPanGestureRecognizer *)pan
{
    // -- 获得point 即获得手指滑动的 x 和 y 的值
    CGPoint point = [pan translationInView:pan.view];
//    scalef = scalef + point.x*self.speed;
    
    // -- 是否随着手势改变
    BOOL canMoveViewPan = YES;
    
    // -- 在这些情况下不能滑动
    if (self.mainVC.view.frame.origin.x > (KScreenWidth-KMainVCDisdance) ||  self.mainVC.view.frame.origin.x < 0)
    {
        canMoveViewPan = NO;
    }
    
    if (canMoveViewPan && (self.mainVC.view.frame.origin.x >= 0) && ((self.mainVC.view.frame.origin.x <= (KScreenWidth-KMainVCDisdance)))) {
        
        // -- mainVC 移动的距离
        CGFloat mainVCCenterX = pan.view.center.x + point.x*self.speed;
        
        // -- 如果超出位置 调整位置
        if (mainVCCenterX < KScreenWidth/2) {
            mainVCCenterX = KScreenWidth/2;
        }
        
        if (mainVCCenterX > KMainVCCenter.x) {
            mainVCCenterX = KMainVCCenter.x;
        }
        
        // -- 更改 mainVC.view 的center
        self.mainVC.view.center = CGPointMake(mainVCCenterX, KScreenHeight/2);
        
        // mainContentView的透明度
        // 0 ~ qwe
        CGFloat mainContentViewAlpha = self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance) * KMainVCContentViewAlpha;
        
        [self.mainContentView setAlpha:mainContentViewAlpha];
        
        
        // -- 更改 mainVC.view 的scale
//        (self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance) 比例关系
//        (1-KMainScale)：缩小的比例 * 比例关系 ：当前缩小的比例
//        1-当前缩小的比例 ，当前的比例
        CGFloat mainScale = 1 - (1-KMainScale)*(self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance));
        self.mainVC.view.transform = CGAffineTransformMakeScale(mainScale, mainScale);
        
        [pan setTranslation:CGPointZero inView:pan.view];
        
        // -- 更改 leftVC.view
        CGFloat leftVCCenterX = KLeftVCTableViewCenterX + ((KScreenWidth-KMainVCDisdance)/2 - KLeftVCTableViewCenterX )*(self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance));
        
        self.leftTableView.center = CGPointMake(leftVCCenterX, KScreenHeight/2);
        
        CGFloat leftScale = KLeftVCTableViewScale + (1-KLeftVCTableViewScale)*(self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance));
        
        self.leftTableView.transform = CGAffineTransformMakeScale(leftScale, leftScale);
        
        // -- leftcontentView 的alpha
        //KLeftVCContentViewAlpha ~ KLeftVCContentViewMinAlpha
        CGFloat leftContentViewAlpha = KLeftVCContentViewAlpha -  (KLeftVCContentViewAlpha - KLeftVCContentViewMinAlpha)*(self.mainVC.view.frame.origin.x/(KScreenWidth-KMainVCDisdance));
        self.leftContentView.alpha = leftContentViewAlpha;
    }
    else
    {
        if (pan.view.frame.origin.x<0) {
            [self closeLeftVC];
        
        }
        else if(pan.view.frame.origin.x>(KScreenWidth-KMainVCDisdance))
        {
            [self openLeftVC];
            
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if(self.mainVC.view.frame.origin.x < (KScreenWidth - KMainVCDisdance)/2){
            [self closeLeftVC];
        }
        else{
            [self openLeftVC];
        }
    }
}

#pragma mark - 添加或者删除轻点手势
- (void) tapOpen{
    
    if (self.sideslipTapGes == nil) {
        self.sideslipTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self.sideslipTapGes setCancelsTouchesInView:YES];
        
        [self.mainContentView addGestureRecognizer:self.sideslipTapGes];
        
    }
}

// -- 关闭手势
- (void) tapClose{
    
    if (self.sideslipTapGes) {
        [self.mainContentView removeGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes = nil;
    }
}

// --  手势的点击事件
- (void) tapGesture:(UITapGestureRecognizer *)tap{
    if ((!self.closed)&&(tap.state == UIGestureRecognizerStateEnded) ) {
        [self closeLeftVC];
        
    }
}

#pragma mark - 打开或者关闭左视图
/*打开左视图*/
- (void) openLeftVC
{
    [UIView beginAnimations:nil context:nil];
    
    // -- 对 mainVC 进行设置
    self.mainVC.view.center = KMainVCCenter;
    self.mainVC.view.transform = CGAffineTransformMakeScale(KMainScale, KMainScale);
    // -- 设置closed
    self.closed = NO;
    
    // -- 对 leftVC 进行设置
    self.leftTableView.center = CGPointMake((KScreenWidth-KMainVCDisdance)/2, KScreenHeight/2);
    self.leftContentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [self.leftContentView setAlpha:0.0];
    
    [self.mainContentView setAlpha:KMainVCContentViewAlpha];
    
    [UIView commitAnimations];
    [self tapOpen];
    
}

/*关闭左视图*/
- (void) closeLeftVC
{
    [UIView beginAnimations:nil context:nil];
    // -- 对mainVC进行设置
    self.mainVC.view.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    self.mainVC.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    // -- 设置closed
    self.closed = YES;
    
    // -- 对 leftVC 进行设置
    [self.leftTableView setCenter:CGPointMake(KLeftVCTableViewCenterX, KScreenHeight/2)];
    self.leftTableView.transform = CGAffineTransformMakeScale(KLeftVCTableViewScale, KLeftVCTableViewScale);
    [self.leftContentView setAlpha:KLeftVCContentViewAlpha];
    [self.mainContentView setAlpha:0];
    [UIView commitAnimations];
    
    [self tapClose];
}

-(void)setPanEabled:(BOOL)enabled
{
    [self.pan setEnabled:enabled];
}


#pragma mark - 跳转到controller
- (void)pushToController:(UIViewController *)vc{
    
    if ([self.mainVC isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)self.mainVC) pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
