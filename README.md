AVAudioRecoder、AVAudioPlayer属于AVFoundation框架，使用时需要先导入AVFoundation头文件。

AVFoundation
是苹果的现代媒体框架，它包含了一些不同用途的 API 和不同层级的抽象。
其中有一些是Objective-C 对于底层 C 语言接口的封装。
除了少数的例外情况，AVFoundation 可以同时在 iOS 和 mac OS  中使用。

AVAudioRecorder
录音机，提供了在应用程序中的音频记录能力。
作为与 AVAudioPlayer 相对应的 API，AVAudioRecorder 是将音频录制为文件的最简单的方法。
除了用一个音量计接受音量的峰值和平均值以外，这个 API 简单粗暴，如果你的使用场景很简单的话，这可能恰恰就是你想要的方法。

AVAudioPlayer
这个高层级的 API 为你提供一个简单的接口，用来播放本地或者内存中的音频。
这是一个无界面的音频播放器 (也就是说没有提供 UI 元素)，使用起来也很直接简单。
它不适用于网络音频流或者低延迟的实时音频播放。如果这些问题都不需要担心，那么 AVAudioPlayer 可能就是正确的选择。
音频播放器的 API 也为我们带来了一些额外的功能，比如循环播放、获取音频的音量强度等等。
