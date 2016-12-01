//
//  AAVPlayerMusicVC.m
//  Voice
//
//  Created by wangfang on 2016/10/19.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import "AVPlayerMusicVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerMusicVC ()

@property (strong, nonatomic) AVPlayer *player;//播放器对象

@end

@implementation AVPlayerMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     与AVAudioPlayer不同之处
     1:可以播放远程音乐。
     2:可以通过替换item来替换播放文件(而不用通过创建新的player)
     */
}

- (IBAction)playLocalMusic:(id)sender {

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"yxqc.mp3" withExtension:nil];
    
    // 2.创建AVPlayerItem
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    // 3.创建AVPlayer
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    [self.player play];
}

- (IBAction)playNetworkMusic:(id)sender {

    NSURL *url = [NSURL URLWithString:@"http://ugc.cdn.qianqian.com/yinyueren/audio/eae34562553f5c48c573d42f281b4b70.mp3"];
    
    // 2.创建AVPlayerItem
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    // 3.创建AVPlayer
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    [self.player play];
}

@end
