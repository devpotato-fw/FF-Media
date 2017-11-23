//
//  AVPlayerVideoNetworkVC.m
//  Voice
//
//  Created by wangfang on 2016/10/22.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import "AVPlayerVideoNetworkVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerVideoNetworkVC ()

@property (strong, nonatomic) AVPlayer *player;//播放器对象

@property (weak, nonatomic) IBOutlet UIView *container; //播放器容器
@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *stop; //停止按钮

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;// 视频总时间

@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;//缓存视频进度

@property (weak, nonatomic) IBOutlet UISlider *slider;//播放进度

@end

@implementation AVPlayerVideoNetworkVC

- (void)dealloc{
  [self removeObserverFromPlayerItem:self.player.currentItem];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.playOrPause.enabled = NO;
  self.stop.enabled = NO;
  
  [self initPlayer];
}

#pragma mark - 初始化

- (void)initPlayer{
  //创建播放器层
  AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
  playerLayer.frame = self.container.bounds;
  //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
  [self.container.layer addSublayer:playerLayer];
}

/**
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
  if (!_player) {
    AVPlayerItem *playerItem = [self getPlayItem];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [self addObserverToPlayerItem:playerItem];
    [self addProgressObserver];
    [self addNotification];
  }
  return _player;
}

-(AVPlayerItem *)getPlayItem{
  
  NSURL *url = [NSURL URLWithString:@"http://images.apple.com/media/cn/apple-events/2016/5102cb6c_73fd_4209_960a_6201fdb29e6e/keynote/apple-event-keynote-tft-cn-20160908_1536x640h.mp4"];
  
  AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
  return playerItem;
}

#pragma mark - 播放/暂停
- (IBAction)playClick:(UIButton *)sender {
  //    AVPlayerItemDidPlayToEndTimeNotification
  //AVPlayerItem *playerItem= self.player.currentItem;
  if(self.player.rate == 0){
    [sender setTitle:@"暂停" forState:UIControlStateNormal];
    [self.player play];
  }else if(self.player.rate==1){//正在播放
    [self.player pause];
    [sender setTitle:@"播放" forState:UIControlStateNormal];
  }
}

- (IBAction)sliderValueChange:(UISlider *)sender {
  
  CGFloat value = sender.value;
  [self.player seekToTime:CMTimeMake(value,1)];
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
- (void)addNotification {
  //给AVPlayerItem添加播放完成通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(playbackFinished:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:self.player.currentItem];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
  NSLog(@"视频播放完成.");
  [self.playOrPause setTitle:@"播放" forState:UIControlStateNormal];
}

#pragma mark - 监控

/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver {
  
  //    AVPlayerItem *playerItem=self.player.currentItem;
  UISlider *slider=self.slider;
  UILabel *timeLabel = self.timeLabel;
  //这里设置每秒执行一次
  
  __weak typeof(self)weakSelf = self;
  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    float current=CMTimeGetSeconds(time);
    //        float total=CMTimeGetSeconds([playerItem duration]);
    NSLog(@"当前已经播放%.2fs.",current);
    if (current) {
      //            [progress setProgress:(current/total) animated:YES];
      slider.value = current;
      timeLabel.text = [weakSelf convertTime:current];// 转换成播放时间
    }
  }];
}

// 给AVPlayerItem添加监控
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
  //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
  [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
  //监控网络加载情况属性
  [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

// 通过KVO监控播放器状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  AVPlayerItem *playerItem=object;
  if ([keyPath isEqualToString:@"status"]) {
    
    AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
    if(status==AVPlayerStatusReadyToPlay){
      // 获取视频总长度
      NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
    }
    
    if ([playerItem status] == AVPlayerStatusReadyToPlay) {
      NSLog(@"AVPlayerStatusReadyToPlay");
      self.playOrPause.enabled = YES;
      self.stop.enabled = YES;
      
      CMTime duration = playerItem.duration;// 获取视频总长度
      CGFloat totalSecond = duration.value / duration.timescale;// 转换成秒
      self.timeLabel.text = @"00:00";
      self.totalTimeLabel.text = [NSString stringWithFormat:@"/%@", [self convertTime:totalSecond]];// 转换成播放时间
      [self.slider setMaximumValue:totalSecond];
      
    } else if ([playerItem status] == AVPlayerStatusFailed) {
      NSLog(@"AVPlayerStatusFailed");
    }
  } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
    NSArray *array=playerItem.loadedTimeRanges;
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
    NSLog(@"共缓冲：%.2f",totalBuffer);
    [self.cacheProgress setProgress:(totalBuffer/CMTimeGetSeconds(playerItem.duration)) animated:YES];
  }
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
  [playerItem removeObserver:self forKeyPath:@"status"];
  [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (NSString *)convertTime:(CGFloat)second{
  NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  if (second/3600 >= 1) {
    [formatter setDateFormat:@"HH:mm:ss"];
  } else {
    [formatter setDateFormat:@"mm:ss"];
  }
  NSString *showtimeNew = [formatter stringFromDate:d];
  return showtimeNew;
}

@end

