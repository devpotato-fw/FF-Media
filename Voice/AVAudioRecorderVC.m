//
//  AVAudioRecorderVC.m
//  Voice
//
//  Created by wangfang on 2016/10/12.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import "AVAudioRecorderVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVAudioRecorderVC ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;// 录音
@property (strong, nonatomic) AVAudioPlayer *player;// 只能播放本地文件，X流式媒体

@end

@implementation AVAudioRecorderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 初始化
    [self.recordingLabel setHidden:YES];
    [self.activityIndicatorView setHidden:YES];
    [self.stopButton setHidden:YES];
    [self.stoPlayRecordButton setHidden:YES];
    [self.timeLabel setHidden:YES];
    
    [self initAudioRecorder];
}

- (void)initAudioRecorder {

    //----------------AVAudioRecorder----------------
    // 录音会话设置
    NSError *errorSession = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; // 得到AVAudioSession单例对象
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &errorSession];// 设置类别,表示该应用同时支持播放和录音
    [audioSession setActive:YES error: &errorSession];// 启动音频会话管理,此时会阻断后台音乐的播放.
    
    // 设置成扬声器播放
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    
    /*
     AVFormatIDKey  音频格式
     
     kAudioFormatLinearPCM
     kAudioFormatMPEG4AAC
     kAudioFormatAppleLossless
     kAudioFormatAppleMA4
     kAudioFormatiLBC
     kAudioFormatULaw
     
     指定kAudioFormatLinearPCM会将未压缩的音频流写入到文件中.这种格式保真度最高,不过相应的文件也最大.选择诸如kAudioFormatMPEG4AAC或者kAudioFormatAppleMA4的压缩格式会显著缩小文件,也能保证高质量的音频内容.
     
     注意,指定的音频格式一定要和URL参数定义的文件类型一致.否则会返回错误信息.
     */
    
    // 创建录音配置信息的字典
    NSDictionary *setting = @{
                               AVFormatIDKey : @(kAudioFormatAppleIMA4),// 音频格式
                               AVSampleRateKey : @44100.0f,// 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
                               AVNumberOfChannelsKey : @1,// 音频通道数 1 或 2
                               AVEncoderBitDepthHintKey : @16,// 线性音频的位深度 8、16、24、32
                               AVEncoderAudioQualityKey : @(AVAudioQualityHigh)// 录音的质量
                               };
    
    
    // 1.创建存放录音文件的地址（音频流写入文件的本地文件URL）
    NSURL *url = [NSURL URLWithString:[self filePath]];
    
    // 2.初始化 AVAudioRecorder 对象
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    
    if (self.audioRecorder) {
        
        self.audioRecorder.delegate = self;// 3.设置代理
        self.audioRecorder.meteringEnabled = YES;
        
        // 4.设置录音时长，超过这个时间后，会暂停 单位是 秒
    //    [self.audioRecorder recordForDuration:10];
        
        // 5.创建一个音频文件，并准备系统进行录制
        [self.audioRecorder prepareToRecord];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

// 开始/暂停录音
- (IBAction)record:(id)sender {

    // 录音前先判断是否正在播放录音
    if ([self.player isPlaying]) {
        [self.player stop];
        [self.playRecordButton setTitle:@"播放录音" forState:UIControlStateNormal];
        
        [self.recordingLabel setHidden:YES];
        [self.activityIndicatorView setHidden:YES];
        [self.stoPlayRecordButton setHidden:YES];
    }
    
    // 判断是否正在录音中
    if (![self.audioRecorder isRecording]) {
        // 开始暂停录音
        [self.audioRecorder record];
        [self.recordButton setTitle:@"暂停录音" forState:UIControlStateNormal];
        
        [self.activityIndicatorView startAnimating];
        
        [self.recordingLabel setText:@"录音中..."];
    } else {
        // 暂停录音
        [self.audioRecorder pause];
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.recordingLabel setText:@"录音暂停"];
    }
    
    [self.recordingLabel setHidden:NO];
    [self.activityIndicatorView setHidden:NO];
    [self.stopButton setHidden:NO];
}

// 停止录音按钮
- (IBAction)stop:(id)sender {

    // 停止录制并关闭音频文件
    [self.audioRecorder stop];
    [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    
    [self.activityIndicatorView stopAnimating];
    [self.recordingLabel setHidden:YES];
    [self.activityIndicatorView setHidden:YES];
    [self.stopButton setHidden:YES];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {

    NSLog(@"--- 录音结束 ---");
}

// 播放录音
- (IBAction)playRecord:(id)sender {
    
    // 播放前先判断是否正在录音
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        
        [self.activityIndicatorView stopAnimating];
        [self.recordingLabel setHidden:YES];
        [self.activityIndicatorView setHidden:YES];
        [self.stopButton setHidden:YES];
    }
    
    //----------------AVAudioPlayer----------------
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self filePath]] error:&playerError];
    
    if (self.player) {
        
        // 设置播放循环次数
        [self.player setNumberOfLoops:0];
        
        // 音量，0-1之间
        [self.player setVolume:1];
        
        [self.player setDelegate:self];
        
        // 分配播放所需的资源，并将其加入内部播放队列
        [self.player prepareToPlay];
    } else {
        NSLog(@"Error: %@", [playerError localizedDescription]);
    }
    
    
    // 判断是否正在播放录音中
    if (![self.player isPlaying]) {
        // 开始播放录音
        [self.player play];
        [self.playRecordButton setTitle:@"暂停播放" forState:UIControlStateNormal];
        
        [self.activityIndicatorView startAnimating];
        
        [self.recordingLabel setText:@"播放中..."];
    } else {
        // 暂停播放录音
        [self.player pause];
        [self.playRecordButton setTitle:@"播放录音" forState:UIControlStateNormal];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.recordingLabel setText:@"播放暂停"];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"音频时长：%f秒", self.player.duration];
    
    [self.recordingLabel setHidden:NO];
    [self.activityIndicatorView setHidden:NO];
    [self.stoPlayRecordButton setHidden:NO];
    [self.timeLabel setHidden:NO];
}

// 停止播放录音
- (IBAction)stopPlayRecord:(id)sender {
    [self.player stop];
    [self.playRecordButton setTitle:@"播放录音" forState:UIControlStateNormal];
    
    [self.recordingLabel setHidden:YES];
    [self.activityIndicatorView setHidden:YES];
    [self.stoPlayRecordButton setHidden:YES];
    [self.timeLabel setHidden:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

    NSLog(@"--- 播放结束 ---");
    
    [self.playRecordButton setTitle:@"播放录音" forState:UIControlStateNormal];
    
    [self.recordingLabel setHidden:YES];
    [self.activityIndicatorView setHidden:YES];
    [self.stoPlayRecordButton setHidden:YES];
    [self.timeLabel setHidden:YES];
}

- (IBAction)playMusic:(id)sender {

    // 播放前先判断是否正在录音
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        
        [self.activityIndicatorView stopAnimating];
        [self.recordingLabel setHidden:YES];
        [self.activityIndicatorView setHidden:YES];
        [self.stopButton setHidden:YES];
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], @"/yxqc.mp3"];
    
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&playerError];
    
    if (self.player) {
        
        // 设置播放循环次数
        [self.player setNumberOfLoops:0];
        
        // 音量，0-1之间
        [self.player setVolume:1];
        
        [self.player setDelegate:self];
        
        // 分配播放所需的资源，并将其加入内部播放队列
        [self.player prepareToPlay];
    } else {
        NSLog(@"Error: %@", [playerError localizedDescription]);
    }
    
    [self.player play];
    
    [self.activityIndicatorView startAnimating];
    
    self.timeLabel.text = [NSString stringWithFormat:@"音频时长：%f秒", self.player.duration];
    
    [self.recordingLabel setText:@"播放中..."];
    
    [self.recordingLabel setHidden:NO];
    [self.activityIndicatorView setHidden:NO];
    [self.stoPlayRecordButton setHidden:NO];
    [self.timeLabel setHidden:NO];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    
    CGFloat value = sender.value;
    self.player.volume = value;
}

#pragma mark - getter

// 获取沙盒路径
- (NSString *)filePath {

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"voice.caf"];
    
    return filePath;
}

@end
