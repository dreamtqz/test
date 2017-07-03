//
//  ViewController.m
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import "ViewController.h"
#import "TQZAVPlayer.h"
@interface ViewController ()
@property (nonatomic , strong) TQZAVPlayer * player;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //播放本地视频
    NSString * file = [[NSBundle mainBundle] pathForResource:@"8410791-100-1498819253" ofType:@"mp4"];
//    [[TQZAVPlayer shareManager] manage2WithAVUrl:file andAVplayerFrame:self.view.bounds andVc:self isLocal:true];
//    
    //播放网络视频
    [[TQZAVPlayer shareManager] manage2WithAVUrl:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"andAVplayerFrame:self.view.bounds andVc:self isLocal:false];
    [self.view addSubview:[[TQZAVPlayer shareManager] bgView]];
    [[TQZAVPlayer shareManager] startF];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//横屏
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    
    if (self.player){
        
        if (self.player.isShowBar){
            
            return NO;
            
        }else {
            
            return YES;
            
        }
        
    }else {
        
        return NO;
    }
    
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //    NSString *frameString = NSStringFromCGRect(self.viewAvPlayer.frame);
    //
    //    NSLog(@"视频窗口的frame:%@",frameString);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
