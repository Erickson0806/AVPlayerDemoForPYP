//
//  ViewController.swift
//  AVPlayerDemoForPYP
//
//  Created by Erickson on 16/5/9.
//  Copyright © 2016年 Erickson. All rights reserved.
//

import UIKit

let dataList = [
    "http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
    "http://45.32.48.22/html/1456117847747a_x264.mp4",
    "http://45.32.48.22/html/14525705791193.mp4",
    "http://45.32.48.22/html/1456459181808howtoloseweight_x264.mp4",
    "http://45.32.48.22/html/1455968234865481297704.mp4",
    "http://45.32.48.22/html/1455782903700jy.mp4",
    "http://45.32.48.22/html/14564977406580.mp4",
    "http://45.32.48.22/html/1456316686552The.mp4",
    "http://45.32.48.22/html/1456480115661mtl.mp4",
    "http://45.32.48.22/html/1456665467509qingshu.mp4",
    "http://45.32.48.22/html/1455614108256t(2).mp4",
    "http://45.32.48.22/html/1456317490140jiyiyuetai_x264.mp4",
    "http://45.32.48.22/html/1455888619273255747085_x264.mp4",
    "http://45.32.48.22/html/1456734464766B(13).mp4",
    "http://45.32.48.22/html/1456653443902B.mp4",
    "http://45.32.48.22/html/1456231710844S(24).mp4"]

class ViewController: UIViewController {

    @IBOutlet weak var playLayerView: PlayerView!
    @IBOutlet weak var slideView: UISlider!
    @IBOutlet weak var pregressView: UIProgressView!
    let mananger = PYPPlayManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        let videoUrl = NSURL(string: dataList[0])
        mananger.url = videoUrl
        playLayerView.setPlayer(mananger.player)
        mananger.delegate = self
        mananger.play()

    }
    var a = 0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        a += 1
        if a>=dataList.count-1 {
            a = 0
        }
        mananger.nextVideo(dataList[a])
    }
    
    @IBAction func slideValueChanged(sender: AnyObject) {
        mananger.changeSlide(sender.value)
    }
    
    @IBAction func slideValueChangeEnd(sender: AnyObject) {
        mananger.changeSlideEnd(sender.value)
    }

}
extension ViewController : PYPPlayManagerDelegate {
    func currentValueOfSlide(second:Float){
        self.slideView.value = second
    }
    
    func totalTime(totalTime: String, currentTime current: String) {
        
    }
    
    func videoBufferOfProgress(progress:Float){
        print("progress:\(progress)")
        self.pregressView.setProgress(progress, animated: true)
    }
    
    func maximumValueOfSlide(value:Float) {
//        print("value:\(value)")
        self.slideView.maximumValue = value
    }
    
    func videoDidEnd() {
        print("videoDidEnd")
        
    }
}
