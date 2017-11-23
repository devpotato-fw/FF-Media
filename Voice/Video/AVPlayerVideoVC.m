//
//  AVPlayerVideoVC.m
//  Voice
//
//  Created by wangfang on 2016/10/22.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import "AVPlayerVideoVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerVideoVC ()

@property (strong, nonatomic) AVPlayer *player;//播放器对象

@property (weak, nonatomic) IBOutlet UIView *container; //播放器容器
@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮
@property (weak, nonatomic) IBOutlet UIProgressView *progress;//播放进度

@end

@implementation AVPlayerVideoVC

-(void)dealloc{
  [self removeObserverFromPlayerItem:self.player.currentItem];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initPlayer];
}

#pragma mark - 初始化

-(void)initPlayer{
  //创建播放器层
  AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
  playerLayer.frame=self.container.bounds;
  playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
  [self.container.layer addSublayer:playerLayer];
}

/**
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
  if (!_player) {
    AVPlayerItem *playerItem=[self getPlayItem];
    _player=[AVPlayer playerWithPlayerItem:playerItem];
    
    [self addObserverToPlayerItem:playerItem];
    [self addProgressObserver];
    [self addNotification];
  }
  return _player;
}

-(AVPlayerItem *)getPlayItem {
  // 播放前，更改为本地视频文件
  NSString *urlStr= [[NSBundle mainBundle] pathForResource:@"apple.mp4" ofType:nil];
  if (urlStr == nil) {
    NSLog(@"--- 请设置本地视频路径 ---");
  }
  NSURL *url=[NSURL fileURLWithPath:urlStr];
  AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
  return playerItem;
}

#pragma mark - 点击播放/暂停按钮

- (IBAction)playClick:(UIButton *)sender {
  
  if(self.player.rate==0){ //说明时暂停
    [sender setTitle:@"暂停" forState:UIControlStateNormal];
    [self.player play];
  } else if(self.player.rate==1){//正在播放
    [self.player pause];
    [sender setTitle:@"播放" forState:UIControlStateNormal];
  }
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
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
-(void)addProgressObserver{
  AVPlayerItem *playerItem=self.player.currentItem;
  UIProgressView *progress=self.progress;
  
  //这里设置每秒执行一次
  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    float current=CMTimeGetSeconds(time);
    float total=CMTimeGetSeconds([playerItem duration]);
    NSLog(@"当前已经播放%.2fs.",current);
    if (current) {
      [progress setProgress:(current/total) animated:YES];
    }
  }];
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
  
  //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
  [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
  
  //监控网络加载情况属性
  [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  AVPlayerItem *playerItem=object;
  
  if ([keyPath isEqualToString:@"status"]) {
    AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
    if(status==AVPlayerStatusReadyToPlay){
      NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
    }
  } else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
    NSArray *array=playerItem.loadedTimeRanges;
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
    NSLog(@"共缓冲：%.2f",totalBuffer);
  }
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
  [playerItem removeObserver:self forKeyPath:@"status"];
  [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  切换选集，这里使用按钮的tag代表视频名称
 *
 *  @param sender 点击按钮对象
 */
//- (IBAction)navigationButtonClick:(UIButton *)sender {
//    [self removeNotification];
//    [self removeObserverFromPlayerItem:self.player.currentItem];
//    AVPlayerItem *playerItem=[self getPlayItem:sender.tag];
//    [self addObserverToPlayerItem:playerItem];
//    //切换视频
//    [self.player replaceCurrentItemWithPlayerItem:playerItem];
//    [self addNotification];
//}

@end

