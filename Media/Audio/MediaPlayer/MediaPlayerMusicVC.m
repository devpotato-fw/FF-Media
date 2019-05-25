//
//  MediaPlayerMusicVC.m
//  Media
//
//  Created by Json.Wang on 2019/5/24.
//  Copyright © 2019 onefboy. All rights reserved.
//

#import "MediaPlayerMusicVC.h"

@interface MediaPlayerMusicVC ()

@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;//播放器对象

@end

@implementation MediaPlayerMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)playLocalMusic:(id)sender {
  
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"yxqc.mp3" withExtension:nil];
  
  self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  
  [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

- (IBAction)playNetworkMusic:(id)sender {
  
  NSURL *url = [NSURL URLWithString:@"http://ugc.cdn.qianqian.com/yinyueren/audio/eae34562553f5c48c573d42f281b4b70.mp3"];
  
  self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  
  [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

@end
