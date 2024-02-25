//
//  ViewController.swift
//  SRAVPlayer
//
//  Created by Siddhesh Redkar on 24/02/24.
//

import UIKit
import SRVideoPlayerFramework

class ViewController: UIViewController {
    
    let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Example Usage:
        setUpConstraints()
        buildPlayer()
        // Do any additional setup after loading the view.
    }
    
    func buildPlayer(){
        let videoPlayer = SRVideoPlayerBuilder()
            .setURLs([URL(string: "https://storage.googleapis.com/gvabox/media/samples/android.mp4")!])
            .setFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            .setPadding(20)
            .setIsMuted(false)
            .setDelegate(self)
            .build()
        playerView.addSubview(videoPlayer)
    }
        
    func setUpConstraints(){
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}

extension ViewController:SRVideoPlayerDelegate{
    func didChangeMuteStatus(isMuted: Bool) {
        print("isMuted:\(isMuted)")
    }
    
    func didChangePlayPauseStatus(isPlaying: Bool) {
        print("isPlaying:\(isPlaying)")
    }
}

