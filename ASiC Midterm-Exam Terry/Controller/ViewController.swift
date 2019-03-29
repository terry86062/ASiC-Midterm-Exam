//
//  ViewController.swift
//  ASiC Midterm-Exam Terry
//
//  Created by 黃偉勛 Terry on 2019/3/29.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var avPlayerView: UIView!
    
    @IBOutlet weak var noVideoLabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var playStopButton: UIButton!
    
    @IBOutlet weak var fastForwardButton: UIButton!
    
    @IBOutlet weak var rewindButton: UIButton!
    
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var volumeButton: UIButton!
    
    @IBOutlet weak var showHideControlButton: UIButton!
    
    var avPlayer: AVPlayer?
    
    var avPlayerLayer: AVPlayerLayer?
    
    var isPlaying: Bool = false
    
    var progressSeconds: Float64 = 0
    
    var totalSeconds: Float64 = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        resetViewWhenRotate(UIDevice.current.orientation)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        resetViewWhenRotate(UIDevice.current.orientation)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        avPlayerLayer?.frame = avPlayerView.frame
        
    }
    
    func resetViewWhenRotate(_ orientation: UIDeviceOrientation) {
        
        switch orientation {
            
        case .portrait:
            
            helpResetViewWhenRotate(itemsIsHidden: false, itemsColor: .black, playerViewColor: .white, noLabelColor: .gray)
            
            fullScreenButton.isSelected = false
            
            showHideControlButton.isHidden = true
            
            showHideControlButton.isSelected = false
            
            helpShowHideControl(false)
            
        default:
            
            helpResetViewWhenRotate(itemsIsHidden: true, itemsColor: .white, playerViewColor: .black, noLabelColor: .white)
            
            fullScreenButton.isSelected = true
            
            showHideControlButton.isHidden = false
            
        }
        
    }
    
    private func helpResetViewWhenRotate(itemsIsHidden: Bool, itemsColor: UIColor, playerViewColor: UIColor, noLabelColor: UIColor) {
        
        navigationController?.navigationBar.isHidden = itemsIsHidden
        
        searchTextField.isHidden = itemsIsHidden
        
        searchButton.isHidden = itemsIsHidden
        
        currentTimeLabel.textColor = itemsColor
        
        totalTimeLabel.textColor = itemsColor
        
        playStopButton.tintColor = itemsColor
        
        fastForwardButton.tintColor = itemsColor
        
        rewindButton.tintColor = itemsColor
        
        fullScreenButton.tintColor = itemsColor
        
        volumeButton.tintColor = itemsColor
        
        avPlayerView.backgroundColor = playerViewColor
        
        noVideoLabel.textColor = noLabelColor
        
    }
    
    // Set Up Video
    
    @IBAction func search(_ sender: UIButton) {
        
        searchTextField.resignFirstResponder()
        
        playStop(UIButton())
        
        avPlayer = nil
        
        setUpAVPlayer()
        
    }
    
    func setUpAVPlayer() {
        
        guard let urlString = searchTextField.text else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        avPlayer = AVPlayer(url: url)
        
        if avPlayerLayer == nil {
            
            avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            
            view.layer.addSublayer(avPlayerLayer!)
            
            avPlayerLayer!.frame = avPlayerView.frame
            
        } else {
            
            avPlayerLayer?.player = avPlayer
            
        }
        
        avPlayer?.play()
        
        isPlaying = true
        
        playStopButton.isSelected = true
        
        avPlayer?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        // track player progress
        
        let interval = CMTime(value: 1, timescale: 2)
        
        avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
            
            guard let weakSelf = self else { return }
            
            weakSelf.progressSeconds = CMTimeGetSeconds(progressTime)
            
            guard !(weakSelf.progressSeconds.isNaN || weakSelf.progressSeconds.isInfinite) else { return }
            
            let secondsString = String(format: "%02d", Int(weakSelf.progressSeconds) % 60)
            
            let minutesString = String(format: "%02d", Int(weakSelf.progressSeconds) / 60)
            
            weakSelf.currentTimeLabel.text = "\(minutesString):\(secondsString)"
            
            //lets move the slider thumb
            
            if let duration = weakSelf.avPlayer?.currentItem?.duration {
                
                let durationSeconds = CMTimeGetSeconds(duration)
                
                weakSelf.timeSlider.value = Float(weakSelf.progressSeconds / durationSeconds)
                
            }
            
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == "currentItem.loadedTimeRanges" else { return }
        
        guard let duration = avPlayer?.currentItem?.duration else { return }
        
        totalSeconds = CMTimeGetSeconds(duration)
        
        guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else { return }
        
        let secondsText = Int(totalSeconds) % 60
        
        let minutesText = String(format: "%02d", Int(totalSeconds) / 60)
        
        totalTimeLabel.text = "\(minutesText):\(secondsText)"
        
    }
    
    // Control Video
    
    @IBAction func playStop(_ sender: UIButton) {
        
        if playStopButton.isSelected {
            
            avPlayer?.pause()
            
            isPlaying = false
            
        } else {
            
            avPlayer?.play()
            
            isPlaying = true
            
        }
        
        playStopButton.isSelected = !playStopButton.isSelected
        
    }
    
    @IBAction func changeVideoTime(_ sender: UISlider) {
        
        guard let duration = avPlayer?.currentItem?.duration else { return }
        
        avPlayer?.pause()
        
        let totalSeconds = CMTimeGetSeconds(duration)
        
        let value = Float64(timeSlider.value) * totalSeconds
        
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        
        avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
            
        })
        
    }
    
    @IBAction func endChangeVideoTime(_ sender: UISlider) {
        
        if isPlaying {
            
            avPlayer?.play()
            
            playStopButton.isSelected = true
            
        }
        
    }
    
    @IBAction func fastForward(_ sender: UIButton) {
        
        helpFastOrRewind(closure: { return progressSeconds + 10 })
        
    }
    
    @IBAction func rewind(_ sender: UIButton) {
        
        helpFastOrRewind(closure: { return progressSeconds - 10 })
        
    }
    
    private func helpFastOrRewind(closure: () -> Double) {
        
        if isPlaying {
            
            avPlayer?.pause()
            
            let seekTime = CMTime(value: Int64(closure()), timescale: 1)
            
            avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in })
            
            avPlayer?.play()
            
        } else {
            
            let seekTime = CMTime(value: Int64(closure()), timescale: 1)
            
            avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in })
            
        }
        
    }
    
    @IBAction func changeVolume(_ sender: UIButton) {
        
        guard let player = avPlayer else {return }
        
        player.isMuted = !player.isMuted
        
        volumeButton.isSelected = !volumeButton.isSelected
        
    }
    
    @IBAction func changeFullScreen(_ sender: UIButton) {
        
        if UIDevice.current.orientation == .portrait {
            
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            
            UIDevice.current.setValue(value, forKey: "orientation")
            
        } else {
            
            let value = UIInterfaceOrientation.portrait.rawValue
            
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
        
    }
    
    @IBAction func showHideControl(_ sender: UIButton) {
        
        guard UIDevice.current.orientation != .portrait else { return }
        
        if showHideControlButton.isSelected {
            
            helpShowHideControl(false)
            
            showHideControlButton.isSelected = false
            
        } else {
            
            helpShowHideControl(true)
            
            showHideControlButton.isSelected = true
            
        }
        
    }
    
    private func helpShowHideControl(_ bool: Bool) {
        
        timeSlider.isHidden = bool
        
        currentTimeLabel.isHidden = bool
        
        totalTimeLabel.isHidden = bool
        
        playStopButton.isHidden = bool
        
        fastForwardButton.isHidden = bool
        
        rewindButton.isHidden = bool
        
        fullScreenButton.isHidden = bool
        
        volumeButton.isHidden = bool
        
    }
    
    @objc func videoEnd(notification: Notification) {
        
        playStop(UIButton())
        
    }
    
}
