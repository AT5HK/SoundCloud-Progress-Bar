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
    @IBOutlet weak var progressView: UIProgressView!

    var scrollableWaveformView = SCScrollableWaveformView()
    var player = AVAudioPlayer()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollableWaveformView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        scrollableWaveformView.center = view.center
        
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL((NSURL(string: "https://p.scdn.co/mp3-preview/cb96e21d8c98fea5ad7ae0966da17e5a275af260")!), completionHandler: { (location, response, error) -> Void in
            
            
            //move file path so track doesn't get deleted after block
            let path = location.path!.stringByAppendingString(".mp3")
            let newurl = NSURL(fileURLWithPath: path)!
            let asset = AVURLAsset(URL: newurl, options: nil)
            NSFileManager.defaultManager().moveItemAtURL(location, toURL: newurl, error: nil)
            println("duration of asset: \(asset.duration.value)")
            
            
            self.player = AVAudioPlayer(contentsOfURL: asset.URL, error: nil)
            
                //.685
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.scrollableWaveformView.waveformView.precision = 0.2;
                self.scrollableWaveformView.waveformView.lineWidthRatio = 0.65;
                self.scrollableWaveformView.waveformView.normalColor = UIColor.grayColor();
                self.scrollableWaveformView.waveformView.channelsPadding = 1;
                self.scrollableWaveformView.waveformView.progressColor = UIColor.orangeColor();
                
                
                self.scrollableWaveformView.alpha = 0.8;
                
                
                self.scrollableWaveformView.waveformView.asset = asset;
                
                let progressTime = CMTimeMakeWithSeconds(
                    1.0 * CMTimeGetSeconds(self.scrollableWaveformView.waveformView.asset.duration),
                    self.scrollableWaveformView.waveformView.asset.duration.timescale)
                
                self.scrollableWaveformView.waveformView.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), progressTime); //change progress time to change how long track is
                
                self.view.addSubview(self.scrollableWaveformView)
                
                //call timer to update progress bar
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
                
                self.scrollableWaveformView.contentOffset = CGPoint(x: 0, y: 0)
                
            })
            self.player.play()
        })
        task.resume()

    }
    
    //MARK - helper methods
    
    func updateProgress() {
        var time = player.currentTime
        var duration = player.duration
        var songCurrentTime = CMTimeMakeWithSeconds(Float64(time), Int32(duration))
            
        self.scrollableWaveformView.waveformView.progressTime = songCurrentTime

        }

}

