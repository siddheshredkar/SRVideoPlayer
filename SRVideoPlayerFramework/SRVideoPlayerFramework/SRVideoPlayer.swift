//
//  SRVideoPlayer.swift
//  SRAVPlayer
//
//  Created by Siddhesh Redkar on 24/02/24.
//

import UIKit
import AVFoundation


// SRVideoPlayerDelegate.swift

public protocol SRVideoPlayerDelegate: AnyObject {
    func didChangeMuteStatus(isMuted: Bool)
    func didChangePlayPauseStatus(isPlaying: Bool)
}

// SRVideoPlayerBuilderProtocol.swift

public protocol SRVideoPlayerBuilderProtocol {
    func setURLs(_ urls: [URL]) -> Self
    func setFrame(_ frame: CGRect) -> Self
    func setPadding(_ padding: CGFloat) -> Self
    func setIsMuted(_ isMuted: Bool) -> Self 
    func setDelegate(_ delegate: SRVideoPlayerDelegate) -> Self
    func build() -> SRVideoPlayer
}

public enum Constants {
    static let playIcon = "play.fill"
    static let pauseIcon = "pause.fill"
    static let muteIcon = "speaker.slash.fill"
    static let unmuteIcon = "speaker.wave.3.fill"
    static let playPauseButtonSize: CGFloat = 60
    static let muteUnmuteButtonSize: CGFloat = 60
}

// SRVideoPlayer.swift

import UIKit
import AVFoundation

public class SRVideoPlayer: UIView {
    
    // delegate property
    weak var delegate: SRVideoPlayerDelegate?
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        let playIcon = UIImage(systemName: Constants.playIcon)
        let pauseIcon = UIImage(systemName: Constants.pauseIcon)
        button.setImage(playIcon, for: .normal)
        button.setImage(pauseIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        return button
    }()
    
    lazy var muteUnmuteButton: UIButton = {
        let button = UIButton()
        let muteIcon = UIImage(systemName: Constants.muteIcon)
        let unmuteIcon = UIImage(systemName: Constants.unmuteIcon)
        button.setImage(muteIcon, for: .normal)
        button.setImage(unmuteIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        return button
    }()
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVQueuePlayer?
    private var playerItems: [AVPlayerItem]?
    
    private var padding: CGFloat
    public var isMuted: Bool {
        didSet {
            self.player?.isMuted = self.isMuted
            self.muteUnmuteButton.isSelected = self.isMuted
        }
    }
    
    init(frame: CGRect, padding: CGFloat,isMuted: Bool) {
        self.padding = padding
        self.isMuted = isMuted
        super.init(frame: frame)
        configure(padding: padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(padding: CGFloat) {
        backgroundColor = .systemBackground
        setUpConstraints()
        configurePlayPauseButton(padding: padding)
        configureMuteUnmuteButton(padding: padding)
    }
    
    func setUpConstraints() {
        addSubview(videoView)
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            videoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configurePlayPauseButton(padding: CGFloat) {
        addSubview(playPauseButton)
        playPauseButton.accessibilityIdentifier = "playPauseButton"
        playPauseButton.addTarget(self, action: #selector(onTapPlayPauseVideoButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            playPauseButton.leadingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: padding),
            playPauseButton.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -padding),
            playPauseButton.widthAnchor.constraint(equalToConstant: Constants.playPauseButtonSize),
            playPauseButton.heightAnchor.constraint(equalToConstant: Constants.playPauseButtonSize),
        ])
    }
    
    private func configureMuteUnmuteButton(padding: CGFloat) {
        addSubview(muteUnmuteButton)
        muteUnmuteButton.accessibilityIdentifier = "muteUnmuteButton"
        muteUnmuteButton.addTarget(self, action: #selector(onTapMuteUnmuteButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            muteUnmuteButton.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -padding),
            muteUnmuteButton.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -padding),
            muteUnmuteButton.widthAnchor.constraint(equalToConstant: Constants.muteUnmuteButtonSize),
            muteUnmuteButton.heightAnchor.constraint(equalToConstant: Constants.muteUnmuteButtonSize)
        ])
    }
    
    public func loadVideo(with url: URL) {
        self.loadVideos(with: [url])
    }
    
    public func loadVideos(with urls: [URL]) {
        guard !urls.isEmpty else {
            print("🚫 URLs not available.")
            return
        }
        
        guard let player = self.player(with: urls) else {
            print("🚫 AVPlayer not created.")
            return
        }
        
        self.player = player
        let playerLayer = self.playerLayer(with: player)
        self.videoView.layer.insertSublayer(playerLayer, at: 0)
    }
    
    public func playVideo() {
        self.player?.play()
        self.playPauseButton.isSelected = true
        delegate?.didChangePlayPauseStatus(isPlaying: true)
    }
    
    public func pauseVideo() {
        self.player?.pause()
        self.playPauseButton.isSelected = false
        delegate?.didChangePlayPauseStatus(isPlaying: false)
    }
    
    // MARK: Button Action Methods
    @objc private func onTapPlayPauseVideoButton(_ sender: UIButton) {
        if sender.isSelected {
            self.pauseVideo()
        } else {
            self.playVideo()
        }
    }
    
    @objc func onTapMuteUnmuteButton(_ sender: UIButton) {
        self.isMuted = !sender.isSelected
        delegate?.didChangeMuteStatus(isMuted: self.isMuted)
    }
    
    // MARK: - Private Methods
    private func player(with urls: [URL]) -> AVQueuePlayer? {
        var playerItems = [AVPlayerItem]()
        
        urls.forEach { (url) in
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            playerItems.append(playerItem)
        }
        
        guard !playerItems.isEmpty else {
            return nil
        }
        
        let player = AVQueuePlayer(items: playerItems)
        self.playerItems = playerItems
        return player
    }
    
    private func playerLayer(with player: AVQueuePlayer) -> AVPlayerLayer {
        self.layoutIfNeeded()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspect
        playerLayer.contentsGravity = .resizeAspect
        self.playerLayer = playerLayer
        return playerLayer
    }
}
