//
//  AVPlayerVideoVC.h
//  Voice
//
//  Created by wangfang on 2016/10/22.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// AVPlayer播放-本地视频
@interface AVPlayerVideoVC : UIViewController

@property (strong, nonatomic) AVPlayer *player;//播放器对象

@property (weak, nonatomic) IBOutlet UIView *container; //播放器容器
@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮
@property (weak, nonatomic) IBOutlet UIProgressView *progress;//播放进度

- (IBAction)playClick:(UIButton *)sender;

@end
