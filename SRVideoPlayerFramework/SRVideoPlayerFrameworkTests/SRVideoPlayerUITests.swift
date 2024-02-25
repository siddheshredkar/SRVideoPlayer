//
//  SRVideoPlayerUITests.swift
//  SRAVPlayerUITests
//
//  Created by Siddhesh Redkar on 25/02/24.
//


import Foundation
import XCTest
@testable import SRAVPlayer

class SRVideoPlayerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Launch the app
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Close the app
        if let app = app{
            app.terminate()
        }
    }

    func testPlayPauseButton() {
        // Assuming your app's main screen has the video player
        
        // Tap the play/pause button
        let playPauseButton = app.buttons["playPauseButton"]
        playPauseButton.tap()

        // Verify that the play/pause button state has changed
        XCTAssertTrue(playPauseButton.isSelected)
        
        // Tap the play/pause button again
        playPauseButton.tap()
        
        // Verify that the play/pause button state has changed back
        XCTAssertFalse(playPauseButton.isSelected)
    }

    func testMuteUnmuteButton() {
        // Assuming your app's main screen has the video player
        
        // Tap the mute/unmute button
        let muteUnmuteButton = app.buttons["muteUnmuteButton"]
        muteUnmuteButton.tap()

        // Verify that the mute/unmute button state has changed
        XCTAssertTrue(muteUnmuteButton.isSelected)
        
        // Tap the mute/unmute button again
        muteUnmuteButton.tap()
        
        // Verify that the mute/unmute button state has changed back
        XCTAssertFalse(muteUnmuteButton.isSelected)
    }

    // Add more UI test cases based on your application's UI interactions
}
