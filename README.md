iOS音频/视频框架

一：MediaPlayer 框架  <MediaPlayer/MediaPlayer.h>

Media Player 框架是 iOS 平台上一个用于音频和视频播放的高层级接口，它包含了一个你可以在应用中直接使用的默认的用户界面。你可以使用它来播放用户在 iPod 库中的项目，或者播放本地文件以及网络流。

另外，这个框架也包括了查找用户媒体库中内容的 API，同时还可以配置像是在锁屏界面或者控制中心里的音频控件。


二：AudioToolbox框架 <AudioToolbox/AudioToolbox.h>

AudioToolbox 这个库是C的接口，偏向于底层，用于在线流媒体音乐的播放，可以调用该库的相关接口自己封装一个在线播放器类。


三：AVFoundation框架 <AVFoundation/AVFoundation.h>

是苹果的现代媒体框架，它包含了一些不同的用途的 API 和不同层级的抽象。其中有一些是现代 Objective-C 对于底层 C 语言接口的封装。除了少数的例外情况，AVFoundation 可以同时在 iOS 和 OS X 中使用。

这个 API 的基本概念是建立一个音频的节点图，从源节点 (播放器和麦克风) 以及过处理 (overprocessing) 节点 (混音器和效果器) 到目标节点 (硬件输出)。每一个节点都具有一定数量的输入和输出总线，同时这些总线也有良好定义的数据格式。这种结构使得它非常的灵活和强大。而且它集成了音频单元 (audio unit)。


四：Audio Unit 框架 <AudioUnit/AudioUnit.h>

Audio Unit 框架是一个底层的 API；所有 iOS 中的音频技术都构建在 Audio Unit 这个框架之上。音频单元是用来加工音频数据的插件。一个音频单元链叫做音频处理图。

如果你需要非常低的延迟 (如 VoIP 或合成乐器)、回声消除、混音或者音调均衡的话，你可能需要直接使用音频单元，或者自己写一个音频单元。但是其中的大部分工作可以使用 AVFoundation 的 AVAudioEngine 的 API 来完成。如果你不得不写自己的音频单元的话，你可以将它们与 AVAudioUnit 节点一起集成在 AVAudioEngine 处理图中。

跨应用程序音频：
Audio Unit 的 API 可以在 iOS 中进行跨应用音频。音频流 (和 MIDI 命令) 可以在应用程序之间发送。比如说：一个应用程序可以提供音频的效果器或者滤波器。另一个应用程序可以将它的音频发送到第一个应用程序中，并使用其中的音频效果器处理音频。被过滤的音频又会被实时地发送回原来的应用程序中。 CoreAudioKit 提供了一个简单的跨应用程序的音频界面。


四：Audio Unit 框架 <AudioUnit/AudioUnit.h>

用于H264视频编解码
