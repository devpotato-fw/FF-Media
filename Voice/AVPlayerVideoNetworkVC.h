//
//  AVPlayerVideoNetworkVC.h
//  Voice
//
//  Created by wangfang on 2016/10/22.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

// AVPlayer播放-网络视频
@interface AVPlayerVideoNetworkVC : UIViewController

@property (strong, nonatomic) AVPlayer *player;//播放器对象

@property (weak, nonatomic) IBOutlet UIView *container; //播放器容器
@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *stop; //停止按钮

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;// 视频总时间

@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;//缓存视频进度

@property (weak, nonatomic) IBOutlet UISlider *slider;//播放进度

- (IBAction)playClick:(UIButton *)sender;// 点击播放/暂停按钮
- (IBAction)sliderValueChange:(UISlider *)sender;// 调节视频进度

@end
