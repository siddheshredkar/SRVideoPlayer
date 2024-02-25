//
//  SRVideoPlayerBuilder.swift
//  SRAVPlayer
//
//  Created by Siddhesh Redkar on 24/02/24.
//


import Foundation


public class SRVideoPlayerBuilder: SRVideoPlayerBuilderProtocol {
    
    private weak var delegate: SRVideoPlayerDelegate?
    private var urls: [URL] = []
    private var frame: CGRect = .zero
    private var padding: CGFloat = 20
    private var isMuted: Bool = true
    
    public init() {}
    
    public func setURLs(_ urls: [URL]) -> Self {
        self.urls = urls
        return self
    }
    
    public func setIsMuted(_ isMuted: Bool) -> Self {
        self.isMuted = isMuted
        return self
    }
    
    public func setFrame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    public func setPadding(_ padding: CGFloat) -> Self {
        self.padding = padding
        return self
    }
    
    public func setDelegate(_ delegate: SRVideoPlayerDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    public func build() -> SRVideoPlayer {
        let player = SRVideoPlayer(frame: frame, padding: padding, isMuted: isMuted)
        player.loadVideos(with: urls)
        player.delegate = delegate
        return player
    }
}
