//
//  MediaPlayerNetworkVC.m
//  Voice
//
//  Created by Json on 2017/11/23.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import "MediaPlayerNetworkVC.h"

@interface MediaPlayerNetworkVC ()

@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;//播放器对象

@end

@implementation MediaPlayerNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MPMoviePlayerViewController *)playerViewController
{
  if (_playerViewController == nil) {
    // 1.获取视频的URL
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/media/cn/apple-events/2016/5102cb6c_73fd_4209_960a_6201fdb29e6e/keynote/apple-event-keynote-tft-cn-20160908_1536x640h.mp4"];
    // 2.创建控制器
    _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  }
  return _playerViewController;
}

- (IBAction)playVideo {
  // 3.播放视频
  [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

@end
