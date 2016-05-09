//
//  PYPPlayManager.swift
//  PYPDoctor
//
//  Created by Erickson on 16/3/2.
//  Copyright © 2016年 paiyipai. All rights reserved.
//

import UIKit
import AVFoundation


protocol PYPPlayManagerDelegate : NSObjectProtocol {

    func currentValueOfSlide(second:Float)
    func totalTime(totalTime:String,currentTime current:String)
    func videoBufferOfProgress(progress:Float)
    func maximumValueOfSlide(value:Float)
    func videoDidEnd()
    
}

class PYPPlayManager: NSObject {

    weak var delegate:PYPPlayManagerDelegate?

    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    
    var totalTime : String?
    var timeObserverToken: AnyObject?

    var url:NSURL? {
        didSet {
            if let videoURL = url {
                print("didSet")
                setupPlay(videoURL)
            }
            
        }
        
    }
    
    /**
     播放
     */
    func play(){
        player.play()
    }
    /**
     暂停
     */
    func pause() {
        player.pause()
    }
    
    /**
     切换video
     */
    func nextVideo(videoURL:String) {

        removeNotification(player.currentItem!)
        let nextPlayerItem = AVPlayerItem(URL: NSURL(string: videoURL)!)
        player.replaceCurrentItemWithPlayerItem(nextPlayerItem)
        addNotification(nextPlayerItem)
    }
    /**
     快进快退
     - parameter value: 当前slide的值
     */
    func changeSlide(value:Float) {
        
        let time = CMTimeMakeWithSeconds(Double(value), 1)
        player.seekToTime(time) {(finished) in
            self.player.pause()
        }
    }
    func changeSlideEnd(value:Float) {
        let time = CMTimeMakeWithSeconds(Double(value), 1)
        player.seekToTime(time) {[unowned self] (finished) in
            self.player.play()
        }
    }
    
    private func addNotification(playItem:AVPlayerItem) {
        
        playItem.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        playItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PYPPlayManager.moviePlayDidEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playItem)
    }
    private func removeNotification(playItem:AVPlayerItem) {
        playItem.removeObserver(self, forKeyPath: "status", context: nil)
        playItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playItem)
        
    }
    
    deinit {
        print("deinit-----deinit")
        if let timeObs = timeObserverToken {
            player.removeTimeObserver(timeObs)
        }
        removeNotification(player.currentItem!)

    }
    
    
    private func setupPlay(videoURL:NSURL) {
        print("setupPlay")
        playerItem = AVPlayerItem(URL: videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        addNotification(player.currentItem!)
    }
    
    private func monitoringPlayback(){
        
       timeObserverToken = player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil) {
            [unowned self] time -> Void  in
        
            let t1 = self.player.currentItem!.currentTime().value
            let t2 = self.player.currentItem!.currentTime().timescale
        
            let currentSecond = Float(t1) / Float(t2)
        
            self.delegate?.totalTime(self.totalTime!, currentTime: self.convertTime(currentSecond))
            self.delegate?.currentValueOfSlide(currentSecond)
        
        }
    }
    
    private func customVideoSlide(duration:CMTime) {
        
        delegate?.maximumValueOfSlide(Float(CMTimeGetSeconds(duration)))

    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            print("keyPath == status")
            if self.player.currentItem?.status == .ReadyToPlay {
                
                let duration = self.player.currentItem!.duration
                
                
                let totalSecond = Float(self.player.currentItem!.duration.value) / Float(self.player.currentItem!.duration.timescale)
                
                self.totalTime = self.convertTime(totalSecond)
                
                
                customVideoSlide(duration)
                
                monitoringPlayback()
                
            }
        } else if keyPath == "loadedTimeRanges" {
            print("keyPath == loadedTimeRanges")
            let timeInterval = self.availableDuration()
            let duration = self.player.currentItem!.duration
            let totalDuration = CMTimeGetSeconds(duration)
            delegate?.videoBufferOfProgress(Float(timeInterval) / Float(totalDuration))
        
        }
    }
    private func availableDuration()->NSTimeInterval {
        
        let loadedTimeRanges = player.currentItem?.loadedTimeRanges
        // 获取缓冲区域
        let timeRange = loadedTimeRanges?.first?.CMTimeRangeValue
        if let time = timeRange {
            let startSec = CMTimeGetSeconds(time.start)
            let durationSec = CMTimeGetSeconds(time.duration)
            let result = startSec + durationSec
            
            return result

        } else {
            return 0
        }
    }
    
    private func convertTime(second:Float)->String {
        let fmt = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(second))
        if second / 3600 >= 1 {
            fmt.dateFormat = "HH:mm:ss"
        } else {
            fmt.dateFormat = "mm:ss"
        }
        return fmt.stringFromDate(date)
    }
  
    func moviePlayDidEnd(note:NSNotification) {
        player.seekToTime(kCMTimeZero) { (finished) -> Void in
            if finished {
                self.delegate?.videoDidEnd()
            }
            
        }
    }
    
}
