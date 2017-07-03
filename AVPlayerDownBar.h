//
//  AVPlayerDownBar.h
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+XJDevice.h"
#import "AVPlayerManager.h"
@interface AVPlayerDownBar : UIView<avplayerEventDelegate>
@property (nonatomic , strong) UIButton        * startBtn;
@property (nonatomic , strong) UIProgressView  * progressView;
@property (nonatomic , strong) UISlider        * slideView;

@property (nonatomic , strong) AVPlayerManager * manager;
@property (nonatomic , strong) UILabel         * currentLabel;
@property (nonatomic , strong) UILabel         * totalLabel;
@property (nonatomic , strong) UIButton        * fullBtn;

@property (nonatomic , assign) BOOL              isHour;
@property (nonatomic , assign) BOOL              isDrag;
@property (nonatomic , assign) CGFloat           totalCount;
@property (nonatomic , assign) CGFloat           currentCount;

@property (nonatomic , assign) BOOL              isAni;
@property (nonatomic , strong) NSTimer         * timer;
@property (nonatomic , assign) CGFloat           currentTime;
- (void)showAndHide;
- (void)showAni;
- (void)stopAni;
- (void)hideAni;

/**
 *
 *
 *  @paramEvent_tqz 左右滑快进后退
 */
- (void)changeTheProgress:(CGFloat)progress;
- (void)endDrag;
@end
