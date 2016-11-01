//
//  LeftSliderViewController.h
//  最新的侧滑
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSliderViewController : UIViewController



// -- 侧滑是否关闭 yes->显示mainVC
@property (nonatomic , assign) BOOL closed;


/**
 单例方法

 @return 当前类的对象
 */
+ (instancetype) sharedLeftSlider;


/**
 *@brief 初始化侧滑控制器
 *
 *@param leftVC 左侧的视图控制器
 *       mainVC 中间的视图控制器
 *
 *@result instancetype 初始化生成的对象
 */
+ (instancetype) creatLeftSliderCotrollerWithLeftViewController:(UIViewController *)leftVC andMainViewController:(UIViewController *)mainViewController;

/**
 *@brief 初始化侧滑控制器
 *
 *@param leftVC 左侧的视图控制器
 *       mainVC 中间的视图控制器
 *
 *@result instancetype 初始化生成的对象
 */
- (instancetype) initWithLeftViewController:(UIViewController *)leftVC andMainViewController:(UIViewController *)mainViewController;

/**
 *@brief 打开左视图控制器
 */
- (void) openLeftVC;

/**
 *@brief 关闭中间的视图控制器
 */
- (void) closeLeftVC;

/**
 *@brief 设置滑动开关是否开启
 *
 *YES表示开启   NO表示关闭
 */
- (void) setPanEabled:(BOOL) enabled;



/**
 跳转到controller

 @param vc controller
 */
- (void) pushToController:(UIViewController *)vc;


@end
