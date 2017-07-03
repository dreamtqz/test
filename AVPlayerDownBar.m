//
//  AVPlayerDownBar.m
//  iOS-视频播放
//
//  Created by 汤庆泽 on 17/4/20.
//  Copyright © 2017年 海南凯迪网络有限公司广州分公司. All rights reserved.
//

#import "AVPlayerDownBar.h"


@implementation AVPlayerDownBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]){
    
        [self __configureUI];
    }
    return self;
}

- (void)__configureUI{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.userInteractionEnabled = true;
    self.isDrag  =  false;
    
    self.startBtn     = ({
    
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button setTitle:@"暂停" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTintColor: [UIColor whiteColor]];
        button.selected = true;
        button;
        
    });
    [self addSubview:self.startBtn];
    
    self.progressView = ({
        
        UIProgressView * view = [[UIProgressView alloc] init];
        view.trackTintColor    = [UIColor blackColor];
        view.progressTintColor = [UIColor lightGrayColor];
        view.progress          = 0.0;
        view;
    });
    [self addSubview:self.progressView];
   
    self.slideView    = ({
    
        UISlider * view   = [[UISlider alloc] init];
        view.maximumValue = 100;
        view.minimumValue = 0 ;
        view.value        = 0;
        view.minimumTrackTintColor  = [UIColor whiteColor];
        view.maximumTrackTintColor  = [UIColor clearColor];
        view.thumbTintColor         = [UIColor blueColor];
        [view addTarget:self action:@selector(endDrag) forControlEvents:UIControlEventTouchUpInside];
        [view addTarget:self action:@selector(endDrag) forControlEvents:UIControlEventTouchUpOutside];
        [view addTarget:self action:@selector(progressChange) forControlEvents:UIControlEventValueChanged];
        view;
    });
    [self addSubview:self.slideView];
    
    self.currentLabel = ({
        
        UILabel *currentlab      = [[UILabel alloc]init];
        currentlab.text          = @"00.00.00";
        currentlab.textColor     = [UIColor whiteColor];
        currentlab.font          = [UIFont systemFontOfSize:14.0];
        currentlab.textAlignment = NSTextAlignmentLeft;
        currentlab ;
    
    });
    [self addSubview:self.currentLabel];
    
    self.totalLabel = ({
        
        UILabel *currentlab      = [[UILabel alloc]init];
        currentlab.text          = @"00.00.06";
        currentlab.textColor     = [UIColor whiteColor];
        currentlab.font          = [UIFont systemFontOfSize:14.0];
        currentlab.textAlignment = NSTextAlignmentRight;
        currentlab ;
        
    });
    [self addSubview:self.totalLabel];
    
    self.fullBtn = ({
    
        UIButton * button        = [[UIButton alloc] init];
        button.backgroundColor   = [UIColor yellowColor];
        button.layer.cornerRadius= 15.0f;
        button.alpha             = 0.5f;
        [button addTarget:self action:@selector(fullClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.fullBtn];
    
    self.alpha = 0.0f;
    self.isAni = false;
}


- (void)endDrag{
    [self hideAni];
    
    int second = _slideView.value * self.totalCount / 100;
    [self.manager.delegate performSelector:@selector(resetProgress:) withObject:[NSNumber numberWithInt:second]];
    self.isDrag = false;
    NSLog(@"结束拖拽");
}


- (void)progressChange{
    
    [self hideAni];
    self.isDrag = YES;
    int second = _slideView.value * self.totalCount / 100;
    [self resetCurrentSecond:second];
   // _progressView.progress = _slideView.value/100;
}

- (void)btnClick:(UIButton *)button{
    
    [self hideAni];
    
    button.selected = !button.selected;
    
    if (!button.selected){
        [self.manager.delegate performSelector:@selector(stop) withObject:nil];
    }else {
        [self.manager.delegate performSelector:@selector(start) withObject:nil];
    }
    
}

- (void)layoutSubviews{

    _startBtn.frame      = CGRectMake(20, 5, 40, 40);
    _progressView.frame  = CGRectMake(80, 18, self.frame.size.width - 124, 10);
    _slideView.frame     = CGRectMake(78, 14, self.frame.size.width - 120, 10);
    _currentLabel.frame  = CGRectMake(78, 28, 120, 20);
    _totalLabel.frame    = CGRectMake(CGRectGetMaxX(_slideView.frame)-120, 28, 120, 20);
    _fullBtn.frame       = CGRectMake(CGRectGetMaxX(_totalLabel.frame)+5, 10, 30, 30);
}

- (void)setCurrentSecond:(CGFloat)currentSecond{
    
    if (!self.isDrag){
    
        self.currentCount     = currentSecond;
        NSString * currentStr = [self PlayerTimeStyle:currentSecond];
        if (self.isHour) {
            self.currentLabel.text = currentStr;
        }else{
            self.currentLabel.text = [NSString stringWithFormat:@"%@",currentStr];
        }
        
        [self setSlideViewAndProgressView];
        
    }

}

- (void)resetCurrentSecond:(CGFloat)currentSecond{
    
    self.currentCount     = currentSecond;
    NSString * currentStr = [self PlayerTimeStyle:currentSecond];
    if (self.isHour) {
        self.currentLabel.text = currentStr;
    }else{
        self.currentLabel.text = [NSString stringWithFormat:@"%@",currentStr];
    }
    
    [self setSlideViewAndProgressView];
    

}

- (void)setSlideViewAndProgressView{
    
  
  //  _progressView.progress = self.currentCount/self.totalCount;
    _slideView.value       = self.currentCount/self.totalCount * 100;
    
}

- (void)setTotalSecond:(CGFloat)totalSecond{

    self.totalCount     = totalSecond;
    NSString * totalStr = [self PlayerTimeStyle:totalSecond];
    
    if (self.isHour){
        self.totalLabel.text = totalStr;
    }else {
        self.totalLabel.text = [NSString stringWithFormat:@"%@",totalStr];
    }
    
}

- (void)setCache:(CGFloat)cacheSecond{

    _progressView.progress = cacheSecond;
}

//定义视屏时长样式
- (NSString *)PlayerTimeStyle:(CGFloat)time{
    
    int seconds = (int)time % 60;
    int minutes = ((int)time / 60) % 60;
    int hours = (int)time / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    if (time/3600>1) {
//        _isHour = YES;
//        [formatter setDateFormat:@"HH:mm:ss"];
//    }else{
//        [formatter setDateFormat:@"HH:mm:ss"];
//    }
//    NSString *showTimeStyle = [formatter stringFromDate:date];
//    return showTimeStyle;
}

#pragma mark 全屏切换
- (void)fullClick:(id)sender{

    [self hideAni];
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
    
        [UIDevice setNewOrientation:UIInterfaceOrientationLandscapeLeft];
    }else {
    
        [UIDevice setNewOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)showAndHide{

    if (!self.isAni){
    
        self.isAni = true;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAni = false;
        });
        if (self.alpha == 0){
            
            [UIView animateWithDuration:0.5f animations:^{
                self.alpha = 1.0f;
            }];
            [self hideAni];
        }else if (self.alpha == 1){
            [UIView animateWithDuration:0.5f animations:^{
                self.alpha = 0.0f;
            }];
            [_timer invalidate];
            
        }
    }
}

- (void)showAni{

    if (!self.isAni){
        
        self.isAni = true;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAni = false;
        });
        if (self.alpha == 0){
            
            [UIView animateWithDuration:0.5f animations:^{
                self.alpha = 1.0f;
            }];
            [self hideAni];
        }
    }
}

- (void)hideAni{
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:false block:^(NSTimer * _Nonnull timer) {
        
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
        }];
        NSLog(@"延时执行完毕");
        
    }];
}

- (void)stopAni{
    [_timer invalidate];
    _timer = nil;
}

- (void)changeTheProgress:(CGFloat)progress{

    CGFloat rate = progress/self.frame.size.width;
    CGFloat time = 300 * rate + self.currentTime;
    if (time <0) time = 0;
    if (time >self.totalCount) time = self.totalCount;
    [self resetCurrentSecond:time];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
