//
//  MediaPlayerVideoVC.m
//  Voice
//
//  Created by Json on 2017/11/23.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import "MediaPlayerVideoVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerVideoVC ()

@property (strong, nonatomic) MPMoviePlayerController *playerController;
@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;//播放器对象

@end

@implementation MediaPlayerVideoVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (MPMoviePlayerViewController *)playerViewController {
  if (_playerViewController == nil) {
    // 1.获取视频的URL
    // 播放前，更改为本地视频文件
    NSString *urlStr= [[NSBundle mainBundle] pathForResource:@"apple.mp4" ofType:nil];
    if (urlStr == nil) {
      NSLog(@"--- 请设置本地视频路径 ---");
    }
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  }
  return _playerViewController;
}

- (MPMoviePlayerController *)playerController {
  if (_playerController == nil) {
    // 1.获取视频的URL
    // 播放前，更改为本地视频文件
    NSString *urlStr= [[NSBundle mainBundle] pathForResource:@"apple.mp4" ofType:nil];
    if (urlStr == nil) {
      NSLog(@"--- 请设置本地视频路径 ---");
    }
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
    _playerController.view.frame = self.view.bounds;
    
  }
  return _playerController;
}

- (IBAction)playVideo {
  //  MPMoviePlayerController 需要添加到 View 上
//  [self.view addSubview:self.playerController.view];
//  [self.playerController play];
  
  [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

@end

