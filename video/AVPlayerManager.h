//
//  AVPlayerManager.h
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@protocol deviceOrientationDelegate <NSObject>

- (void)__resetFrameAndBar:(BOOL)reset;

@end

@protocol avplayerEventDelegate <NSObject>

- (void)setTotalSecond:(CGFloat)totalSecond;

- (void)setCurrentSecond:(CGFloat)currentSecond;

- (void)setCache:(CGFloat)cacheSecond;
@end

@interface AVPlayerManager : NSObject

@property (nonatomic , strong) AVPlayerItem        * playItem;
@property (nonatomic , assign) UIDeviceOrientation orientation;
@property (nonatomic , weak  ) id<deviceOrientationDelegate>delegate;
@property (nonatomic , strong) id<avplayerEventDelegate>managerDelegate;
@property (nonatomic , strong) id playBackTimeObserver;
@property (nonatomic , strong) AVPlayer * palyer;
+ (instancetype)shareManager;

- (void)addObserver:(AVPlayerItem *)item;

- (void)addObserverWithAVPlayer:(AVPlayer *)player;
@end
