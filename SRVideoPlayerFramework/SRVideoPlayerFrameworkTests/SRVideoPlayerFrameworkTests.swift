//
//  SRVideoPlayerFrameworkTests.swift
//  SRVideoPlayerFrameworkTests
//
//  Created by Siddhesh Redkar on 25/02/24.
//

import XCTest
@testable import SRVideoPlayerFramework

class SRVideoPlayerFrameworkTests: XCTestCase {
    
    var videoPlayer: SRVideoPlayer!
    var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        videoPlayer = SRVideoPlayer(frame: CGRect(x: 0, y: 0, width: 300, height: 200), padding: 20, isMuted: true)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        videoPlayer = nil
    }
    
    func testPlayVideo() {
        // Given
        XCTAssertFalse(videoPlayer.playPauseButton.isSelected, "Play button should be initially not selected")
        
        // When
        videoPlayer.playVideo()
        
        // Then
        XCTAssertTrue(videoPlayer.playPauseButton.isSelected, "Play button should be selected after calling playVideo()")
    }
    
    func testPauseVideo() {
        // Given
        videoPlayer.playVideo() // Simulate playing
        
        // When
        videoPlayer.pauseVideo()
        
        // Then
        XCTAssertFalse(videoPlayer.playPauseButton.isSelected, "Play button should be not selected after calling pauseVideo()")
    }
    
    func testMuteVideo() {
        // Given
        expectation = XCTestExpectation(description: "Mute status should be updated")
        XCTAssertTrue(videoPlayer.isMuted, "Video player should be initially muted")
        
        // When
        videoPlayer.delegate = self // Assuming your test class conforms to SRVideoPlayerDelegate
        videoPlayer.onTapMuteUnmuteButton(videoPlayer.muteUnmuteButton)
        
        // Then
        wait(for: [expectation], timeout: 1.0) // Adjust the timeout as needed
    }
    
    func testUnmuteVideo() {
        // Given
        expectation = XCTestExpectation(description: "Mute status should be updated")
        videoPlayer.isMuted = false // Simulate being unmuted
        
        // When
        videoPlayer.delegate = self // Assuming your test class conforms to SRVideoPlayerDelegate
        videoPlayer.onTapMuteUnmuteButton(videoPlayer.muteUnmuteButton)
        
        // Then
        wait(for: [expectation], timeout: 1.0) // Adjust the timeout as needed
    }
}

extension SRAVPlayerTests: SRVideoPlayerDelegate {
    func didChangeMuteStatus(isMuted: Bool) {
        XCTAssertTrue(isMuted, "Video player should be muted after calling onTapMuteUnmuteButton()")
        expectation.fulfill()
    }
    
    func didChangePlayPauseStatus(isPlaying: Bool) {
        // Implement this if needed for play/pause testing
    }
}
