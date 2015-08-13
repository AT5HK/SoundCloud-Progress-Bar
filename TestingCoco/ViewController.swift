//
//  ViewController.swift
//  TestingCoco
//
//  Created by Auston Salvana on 8/13/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var scrollableWaveformView = SCScrollableWaveformView()
//    var scrollableWaveformView = SCScrollableWaveformView()
    var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollableWaveformView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        scrollableWaveformView.center = view.center
        
        let path = NSBundle.mainBundle().pathForResource("Zatar", ofType:"mp3")
        let asset = AVURLAsset.assetWithURL(NSURL(fileURLWithPath: path!)) as! AVAsset
        let playerItem = AVPlayerItem(asset: asset)
        
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1
        //.685
        self.scrollableWaveformView.waveformView.precision = 1;
        self.scrollableWaveformView.waveformView.lineWidthRatio = 1;
        self.scrollableWaveformView.waveformView.normalColor = UIColor.grayColor();
        self.scrollableWaveformView.waveformView.channelsPadding = 10;
        self.scrollableWaveformView.waveformView.progressColor = UIColor.orangeColor();

        
        self.scrollableWaveformView.alpha = 0.8;
        
        self.scrollableWaveformView.waveformView.asset = asset;
    
        
        let progressTime = CMTimeMakeWithSeconds(
            1.0 * CMTimeGetSeconds(self.scrollableWaveformView.waveformView.asset.duration),
            self.scrollableWaveformView.waveformView.asset.duration.timescale)

//        let progressTime = self.scrollableWaveformView.waveformView.asset.duration * 0.5
        
        self.scrollableWaveformView.waveformView.timeRange =  CMTimeRangeMake(CMTimeMakeWithSeconds(0, 10000), progressTime);
        
        println("waveForm frame \(scrollableWaveformView.waveformView.frame)")
        self.view.addSubview(self.scrollableWaveformView)
        player.play()
        
        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 60), queue: dispatch_get_main_queue(), usingBlock: { (time) -> Void in
            self.scrollableWaveformView.waveformView.progressTime = time;
        })
        
        scrollableWaveformView.contentOffset = CGPoint(x: 0, y: 0)
    }

}

