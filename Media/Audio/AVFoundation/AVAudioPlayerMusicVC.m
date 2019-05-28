//
//  AVAudioPlayerMusicVC.m
//  Media
//
//  Created by Json.Wang on 2019/5/25.
//  Copyright © 2019 onefboy. All rights reserved.
//

#import "AVAudioPlayerMusicVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayerMusicVC ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;// 只能播放本地文件，X流式媒体

@end

@implementation AVAudioPlayerMusicVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSError *playerError;
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"yxqc.mp3" withExtension:nil];
  
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
  
  // 设置播放循环次数
  [self.player setNumberOfLoops:0];
  
  // 音量，0-1之间
  [self.player setVolume:1];
  
  [self.player setDelegate:self];
  
  // 分配播放所需的资源，并将其加入内部播放队列
  [self.player prepareToPlay];
  
  
  // 开始播放录音
  [self.player play];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  NSLog(@"--- 播放结束 ---");
}

@end

