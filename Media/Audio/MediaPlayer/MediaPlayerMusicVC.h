//
//  MediaPlayerMusicVC.h
//  Media
//
//  Created by Json.Wang on 2019/5/24.
//  Copyright © 2019 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

// MediaPlayer播放音频
@interface MediaPlayerMusicVC : UIViewController

- (IBAction)playLocalMusic:(id)sender;
- (IBAction)playNetworkMusic:(id)sender;

@end

NS_ASSUME_NONNULL_END
