//
//  ViewController.swift
//  AVPlayer
//
//  Created by Kyle Redfearn on 11/14/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    var player: AVPlayer!
    var playerStatusKVO: NSKeyValueObservation!
    var playerTimeControlStatusKVO: NSKeyValueObservation!
    var playerErrorKVO: NSKeyValueObservation!
    var itemStatusKVO: NSKeyValueObservation!
    var itemErrorKVO: NSKeyValueObservation!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")!
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        let item = AVPlayerItem(asset: asset)
        itemStatusKVO = item.observe(\.status, options: .new) { item, change in
            switch item.status {
            case .unknown:
                print("ItemStatus: unknown")
            case .readyToPlay:
                print("ItemStatus: readyToPlay")
            case .failed:
                print("ItemStatus: failed")
            @unknown default:
                print("ItemStatus: default")
            }
        }
        itemErrorKVO = item.observe(\.error, options: .new) { item, change in
            if let error = item.error {
                print("Item Error: \(error)")
            }
        }
        player = AVPlayer(playerItem: item)
        let oneHalfOfASecond = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: oneHalfOfASecond, queue: .main) { time in
            let currentSeconds = TimeInterval(time.value) / TimeInterval(time.timescale)
            print("\(currentSeconds)")
        }
        playerStatusKVO = player.observe(\.status, options: .new) { player, change in
            switch player.status {
            case .unknown:
                print("playerStatus: unknown")
            case .readyToPlay:
                print("playerStatus: readyToPlay")
                player.play()
            case .failed:
                print("playerStatus: failed")
            @unknown default:
                print("playerStatus: default")
            }
        }
        playerTimeControlStatusKVO = player.observe(\.timeControlStatus, options: .new) { player, change in
            switch player.timeControlStatus {
            case .playing:
                print("timeControlStatus: playing")
            case .paused:
                print("timeControlStatus: paused")
            case .waitingToPlayAtSpecifiedRate:
                print("timeControlStatus: waitingToPlayAtSpecifiedRate")
            @unknown default:
                print("timeControlStatus: default")
            }
        }
        playerErrorKVO = player.observe(\.error, options: .new) { player, change in
            if let error =  player.error {
                print("error: \(error)")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidStall), name: .AVPlayerItemPlaybackStalled, object: nil)
        player.play()
        
        let controller = AVPlayerViewController()
        controller.player = player
        addChild(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.frame
        controller.didMove(toParent: self)
        
    }

    @objc func avPlayerDidFinish() {
        print("Recording avPlayerDidFinish")
    }
    
    @objc func avPlayerDidStall() {
        print("Recording avPlayerDidStall")
    }

}

