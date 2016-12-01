//
//  AVAudioRecorderVC.h
//  Voice
//
//  Created by wangfang on 2016/10/12.
//  Copyright © 2016年 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>

// AVAudioRecorderVC录音
@interface AVAudioRecorderVC : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView ;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *recordButton;// 开始录音按钮
@property (strong, nonatomic) IBOutlet UIButton *stopButton;// 停止录音按钮

@property (strong, nonatomic) IBOutlet UIButton *playRecordButton;// 播放录音
@property (strong, nonatomic) IBOutlet UIButton *stoPlayRecordButton;// 止播放录音

- (IBAction)record:(id)sender;// 开始录音
- (IBAction)stop:(id)sender;// 停止录音

- (IBAction)playRecord:(id)sender;// 播放录音
- (IBAction)stopPlayRecord:(id)sender;// 停止播放录音

- (IBAction)playMusic:(id)sender;

- (IBAction)sliderValueChange:(UISlider *)sender;

@end

