//
//  AVPlayerVideoNetworkVC.h
//  Voice
//
//  Created by wangfang on 2016/10/22.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>

// AVPlayer播放-网络视频
@interface AVPlayerVideoNetworkVC : UIViewController

- (IBAction)playClick:(UIButton *)sender;// 点击播放/暂停按钮
- (IBAction)sliderValueChange:(UISlider *)sender;// 调节视频进度

@end
