//
//  TQZAVPlayer.m
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import "TQZAVPlayer.h"
#import "AVPlayerDownBar.h"

#define APP_W [UIScreen mainScreen].bounds.size.width
#define APP_H [UIScreen mainScreen].bounds.size.height
@interface TQZAVPlayer ()<deviceOrientationDelegate>{

  
    
}

@end

@implementation TQZAVPlayer

+ (id)shareManager{

    static TQZAVPlayer * player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[TQZAVPlayer alloc]init];
    });
    return player;
}

+ (id)managerWithAVUrl:(NSString *)url andAVplayerFrame:(CGRect)frame andVc:(UIViewController *)vc isLocal:(BOOL)isLocal{
    
    static TQZAVPlayer * player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[TQZAVPlayer alloc]init];
        player.showVc = vc;
    });
    [player initWithAVUrl:url andAVplayerFrame:frame isLocal:isLocal];
    return player;
}

- (void)manage2WithAVUrl:(NSString *)url andAVplayerFrame:(CGRect)frame andVc:(UIViewController *)vc isLocal:(BOOL)isLocal{
    
   
    self.showVc = vc;
    [self initWithAVUrl:url andAVplayerFrame:frame isLocal:isLocal];

}


- (UIView *)bg{
    
    return self.bgView;

}

- (id)init{
    
    
    if (self = [super init]){
        
    }
    return self;

}

- (void)initWithAVUrl:(NSString *)url andAVplayerFrame:(CGRect)frame isLocal:(BOOL)isLocal{

    [self __configureWithAVUrl:url andAVplayerFrame:frame isLocal:isLocal];
  
}

- (void)__configureWithAVUrl:(NSString *)url andAVplayerFrame:(CGRect)frame isLocal:(BOOL)isLocal{
    AVPlayerItem * playerItem = nil;
    if (isLocal){
    
        NSURL *sourceMovieUrl = [NSURL fileURLWithPath:url];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
        playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    }else {
    
        playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    }

    _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    _avLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _avLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _avLayer.frame = frame;
    
    _manager = [AVPlayerManager shareManager];
    _manager.delegate = self;
    [_manager addObserver:playerItem];
    [_manager addObserverWithAVPlayer:_avPlayer];
    
    _downView = [[AVPlayerDownBar alloc] initWithFrame:CGRectMake(0,_avLayer.frame.size.height - 50, _avLayer.frame.size.width, 50)];
    _downView.manager = _manager;
    _downView.manager.managerDelegate = _downView;
    
    _isShowBar = false;
    
    _bgView = [[UIView alloc] initWithFrame:_avLayer.frame];
    _bgView.clipsToBounds = YES;
    [_bgView.layer addSublayer:_avLayer];
    [_bgView addSubview:_downView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndHide:)];
    [_bgView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * tap2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_bgView addGestureRecognizer:tap2];
    
}

- (void)pan:(UIPanGestureRecognizer*)tap {

    CGPoint veloctyPoint = [tap velocityInView:_bgView];
    CGPoint point        = [tap locationInView:_bgView];
    CGFloat x;
    if (tap.state == UIGestureRecognizerStateBegan){
        [_downView showAni];
        [_downView stopAni];
        
        NSLog(@"%f,%f",veloctyPoint.x,veloctyPoint.y);
        CGFloat x = fabs(veloctyPoint.x);
        CGFloat y = fabs(veloctyPoint.y);
        if (x>y){
            NSLog(@"横向");
            self.direction  = PanDirectionHorizontalMoved;
            self.startPoint = point;
            CMTime time     = _avPlayer.currentTime;
            CGFloat sumTime = time.value/time.timescale;
            _downView.currentTime = sumTime;
            [_downView setCurrentTime:sumTime];
            _downView.isDrag = true;
            NSLog(@"%f",sumTime);
        }else {
            NSLog(@"竖向");
        }
        
    }else if (tap.state == UIGestureRecognizerStateChanged){
        
        switch (self.direction) {
            case PanDirectionHorizontalMoved:
                
                 x = point.x - _startPoint.x;
                NSLog(@"%f",x);
                [_downView changeTheProgress:x];
                break;
                
            default:
                break;
        }
        
    }else if (tap.state == UIGestureRecognizerStateEnded){
    
        [_downView hideAni];
        _downView.isDrag = false;
        [_downView endDrag];
    }
}

- (void)showAndHide:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:_bgView];
    
    if (_downView.alpha == 0.0){
    
         [_downView showAndHide];
    }else {
        
        if (!CGRectContainsPoint(_downView.frame, point)){
    
             [_downView showAndHide];
        }
    }
}


- (void)ccc{

    NSLog(@"ccc");
}

- (void)startF{
     [self.avPlayer play];
}

- (void)start{

    [self.avPlayer play];
}

- (void)stop{
    
    [self.avPlayer pause];
}

#pragma mark 监听屏幕横竖屏


- (void)__resetFrameAndBar:(BOOL)isVertical{
    
    if (isVertical){
        
        self.isShowBar  = false;
        _avLayer.frame  = CGRectMake(0,15, APP_W , APP_H/3-10);
        _bgView.frame   = CGRectMake(0,15, APP_W , APP_H/3-10);
        _downView.frame = CGRectMake(0,_avLayer.frame.size.height - 50, _avLayer.frame.size.width, 50);
        [_avLayer setNeedsLayout];
        
    }else {
    
        self.isShowBar = true;
        _avLayer.frame = CGRectMake(0, 0, APP_W , APP_H);
        _bgView.frame   = CGRectMake(0, 0, APP_W , APP_H);
        _downView.frame = CGRectMake(0,_avLayer.frame.size.height - 50, _avLayer.frame.size.width, 50);
        [_avLayer setNeedsLayout];
    }

}

- (void)resetProgress:(id)second{

    [self stop];
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds([second floatValue], NSEC_PER_SEC)];
    [self start];
}

/**
 *
 *
 *  @paramEvent_tqz 播放结束
 */


@end
