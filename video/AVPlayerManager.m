//
//  AVPlayerManager.m
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import "AVPlayerManager.h"

@implementation AVPlayerManager


+ (instancetype)shareManager{

    static AVPlayerManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AVPlayerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init{

    [self addObserver];
    
    return self;
}

- (void)orientCahnge:(NSNotification *)notification{
    
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    if (orient == UIDeviceOrientationPortrait){
        
        if ([self.delegate respondsToSelector:@selector(__resetFrameAndBar:)]){
            
            [self.delegate __resetFrameAndBar:YES];
            
        }
        
    }else {
    
        if ([self.delegate respondsToSelector:@selector(__resetFrameAndBar:)]){
            
            [self.delegate __resetFrameAndBar:NO];
            
        }
    }
}

- (void)addObserver{

       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientCahnge:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)addObserver:(AVPlayerItem *)item{
    self.playItem = item;
    /** 监听status属性变化 */
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    /** 监听缓存量的变化*/
    [self.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    /** 缓存区空了,需要等待*/
    [self.playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    /** 有足够缓存可以继续播放*/
    [self.playItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    /** 注册监听，视屏播放完成*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerEndPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    /** 视频播放被中断*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayInterrupt:) name:AVPlayerItemPlaybackStalledNotification object:self.playItem];
    /** 当APP挂起状态时 播放器是否仍然继续播放 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    /** APP回到前台时，是否要做出改变 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([object isKindOfClass:[AVPlayerItem class]]){
    
        AVPlayerItem * playerItem = (AVPlayerItem *)object;
        self.playItem   =  playerItem;
        if ([keyPath isEqualToString:@"status"]){
        
            if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            
                CMTime  duration    = playerItem.duration;
                CGFloat totalSecond = CMTimeGetSeconds(duration);
                /** 设置播放总时间*/
                [self.managerDelegate setTotalSecond:totalSecond];
                NSLog(@"播放成功");
                /** 设置当前播放的时间*/
                CGFloat currentSecond = self.playItem.currentTime.value/self.playItem.currentTime.timescale;
                NSLog(@"当前：%f",currentSecond);
                [self.managerDelegate setCurrentSecond:currentSecond];
                
            }else if (playerItem.status == AVPlayerItemStatusUnknown){
                NSLog(@"未知错误");
            }else if (playerItem.status == AVPlayerItemStatusFailed){
            
                NSLog(@"播放失败");
            }
        
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            
            [self setCacheProgress];
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        
            NSLog(@"缓存不好   ");
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        
            NSLog(@"缓存好了");
        }
    }
}



- (void)AVPlayerEndPlay:(NSNotification *)sender{

    NSLog(@"视频播放结束");
}

- (void)AVPlayInterrupt:(NSNotification *)sender{

    NSLog(@"视频播放中断");
}

/** app进入后台 */
-(void)appDidEnterBackground
{
    
}
/** app 进入运行状态 */
-(void)appDidEnterPlayGround
{
    
}

- (void)addObserverWithAVPlayer:(AVPlayer *)player{
    self.palyer  = player;
    self.playBackTimeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
         CGFloat currentSecond = self.playItem.currentTime.value/self.playItem.currentTime.timescale;//获取当前时间
        
        [self.managerDelegate setCurrentSecond:currentSecond];
    }];
}

#pragma mark 设置缓存的长度
- (void)setCacheProgress{
    
    NSTimeInterval timeInterval = [self jxPlayerAvailableDuration];
    CMTime duration             = self.playItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    [self.managerDelegate setCache:(timeInterval/totalDuration)];
}

#pragma mark 计算缓存了多少
- (NSTimeInterval)jxPlayerAvailableDuration{
    NSArray *loadedTimeRanges = [[self.palyer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;//计算缓冲进度
    return result;
}

- (void)dealloc{
    
    [self removeObserver:self.playItem forKeyPath:@"loadedTimeRanges" context:nil];
    [self removeObserver:self.playItem forKeyPath:@"status" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
