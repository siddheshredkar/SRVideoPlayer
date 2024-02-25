# SRVideoPlayer
AV Framework with custom play/pause and mute/unmute buttons

Add the Framework:

Drag the built framework (SRVideoPlayerFramework.framework) into your project's navigator. Import the Framework:

Import the framework where you need to use it in your Swift files. 
swift Copy code
```
import SRVideoPlayerFramework
```
Update SRVideoPlayer Instantiation:

Use the SRVideoPlayerBuilder to instantiate the SRVideoPlayer with your desired configurations. 
swift Copy code
```
let videoPlayer = SRVideoPlayerBuilder()
    .setURLs([URL(string: "your_video_url_here")!])
    .setFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
    .setPadding(20)
    .setIsMuted(false)
    .setDelegate(yourDelegateInstance)
    .build()
```
Adjust the parameters in the builder as needed for your specific requirements.

Remember to replace "your_video_url_here" with the actual URL of the video you want to play and set other parameters based on your project's needs. This structure is convenient for configuring and creating instances of SRVideoPlayer in a clean and organized way.

Users implementing your framework can then conform to the SRVideoPlayerDelegate protocol and implement these methods to respond to mute/unmute and play/pause events:

swift Copy code
```
// MARK: - YourViewController: SRVideoPlayerDelegate

extension YourViewController: SRVideoPlayerDelegate {

    func didChangePlaybackStatus(isPlaying: Bool) {
        // Handle the playback status change in your view controller
    }

    func didChangeMuteStatus(isMuted: Bool) {
        // Handle the mute status change in your view controller
    }
}
```
