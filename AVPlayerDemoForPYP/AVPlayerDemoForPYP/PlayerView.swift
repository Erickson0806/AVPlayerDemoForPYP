//
//  PlayerView.swift
//  AVPlayerDemoForPYP
//
//  Created by Erickson on 16/5/9.
//  Copyright © 2016年 Erickson. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerView: UIView {

    override class func layerClass()->AnyClass {
        return AVPlayerLayer.self
    }
    
    func player() ->AVPlayer {
        let layer:AVPlayerLayer = self.layer as! AVPlayerLayer
        return layer.player!
    }
    
    func setPlayer(player:AVPlayer) {
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
        
    }
    func haha() {
        print("ahhahahhaha")
    }
    func setVideoFillMode(fillMode: String) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.videoGravity = fillMode as String
    }
    
    func videoFillMode() -> String {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        return layer.videoGravity
    }
    
}
