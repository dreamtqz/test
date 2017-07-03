//
//  TQZAVPlayer.h
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AVPlayerDownBar.h"
#import "AVPlayerManager.h"
#import "UIDevice+XJDevice.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
@interface TQZAVPlayer : NSObject

@property (nonatomic , strong) UIView        * bgView;
@property (nonatomic , strong) AVPlayer      * avPlayer;
@property (nonatomic , strong) AVPlayerLayer * avLayer;
@property (nonatomic , strong) NSURL         * remoteUrl;
@property (nonatomic , strong) UIViewController * showVc;
@property (nonatomic , assign) BOOL            isShowBar;
@property (nonatomic , strong) AVPlayerDownBar * downView;
@property (nonatomic , strong) AVPlayerManager * manager;
@property (nonatomic , assign) CGPoint           startPoint;
@property (nonatomic , assign) PanDirection      direction;

+ (id)shareManager;

/**
 *
 *
 *  @paramEvent_tqz 设置成单例获取
 */

- (void)manage2WithAVUrl:(NSString *)url andAVplayerFrame:(CGRect)frame andVc:(UIViewController *)vc isLocal:(BOOL)isLocal;
- (void)start;

- (void)stop;

- (void)startF;

- (void)resetProgress:(id)second;

- (UIView *)bg;
@end
