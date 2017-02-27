//
//  VideoLauncher.swift
//  youtube
//
//  Created by aney on 2017. 2. 26..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
	
	//MARK: Properties
	var player: AVPlayer?
	var isPlaying = false
	
	//MARK: UI
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		aiv.translatesAutoresizingMaskIntoConstraints = false
		aiv.startAnimating()
		return aiv
	}()
	
	lazy var pausePlayButton: UIButton = {
		let button = UIButton(type: .system)
		let image = UIImage(named: "pause")
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .white
		button.isHidden = true
		
		button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
		
		return button
	}()
	
	let controlsContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 0.5)
		return view
	}()
	
	let videoLengthLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "00:00"
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 13)
		label.textAlignment = .right
		return label
	}()
	
	let currentTimeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "00:00"
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 13)
		return label
	}()
	
	let videoSlider: UISlider = {
		let slider = UISlider()
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.minimumTrackTintColor = .red
		slider.maximumTrackTintColor = .white
		slider.setThumbImage(UIImage(named:"thumb"), for: .normal)
		
		slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
		
		return slider
	}()
	
	func handlePause() {
		
		if isPlaying {
			player?.pause()
			pausePlayButton.setImage(UIImage(named:"play"), for: .normal)
		} else {
			player?.play()
			pausePlayButton.setImage(UIImage(named:"pause"), for: .normal)
		}
		
		isPlaying = !isPlaying
	}
	
	func handleSliderChange() {
		print(videoSlider.value)
		
		if let duration = player?.currentItem?.duration {
			let totalSeconds = CMTimeGetSeconds(duration)
			
			let value = Float64(videoSlider.value) * totalSeconds
			
			let seekTime = CMTime(value: Int64(value), timescale: 1)
			
			player?.seek(
				to: seekTime,
				completionHandler: { (completedSeek) in
					//perhaps do something later here..
			})
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupPlayerView()
		
		setupGradientLayer()
		
		controlsContainerView.frame = self.frame
		self.addSubview(controlsContainerView)
		
		controlsContainerView.addSubview(activityIndicatorView)
		activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
		controlsContainerView.addSubview(pausePlayButton)
		pausePlayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		pausePlayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
		pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		controlsContainerView.addSubview(videoLengthLabel)
		videoLengthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
		videoLengthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
		videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
		videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
		
		controlsContainerView.addSubview(currentTimeLabel)
		currentTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
		currentTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
		currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
		currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
		
		controlsContainerView.addSubview(videoSlider)
		videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
		videoSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
		videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		backgroundColor = .black
	}
	
	private func setupPlayerView() {
		//warning: use your own video url here,
		let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
		if let url = URL(string: urlString) {
			player = AVPlayer(url: url)
			
			let playLayer = AVPlayerLayer(player: player)
			self.layer.addSublayer(playLayer)
			playLayer.frame = self.frame
			
			player?.play()
			
			player?.addObserver(
				self,
				forKeyPath: "currentItem.loadedTimeRanges",
				options: .new,
				context: nil
			)
			
			//track player progress
			
			let interval = CMTime(value: 1, timescale: 2)
			player?.addPeriodicTimeObserver(
				forInterval: interval,
				queue: DispatchQueue.main,
				using: { (progressTime) in
					
					let seconds = CMTimeGetSeconds(progressTime)
					let secondsString = String(format: "%02d", Int(seconds) % 60)
					let minutesString = String(format: "%02d", Int(seconds / 60))
					self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
					
					//lets move the slider thumb
					if let duration = self.player?.currentItem?.duration {
						let durationSeconds = CMTimeGetSeconds(duration)
						
						self.videoSlider.value = Float(seconds / durationSeconds)
						
					}
				}
			)
		}
	}
	
	override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey : Any]?,
		context: UnsafeMutableRawPointer?
		) {
		
		//this is when the player is ready and rendering
		if keyPath == "currentItem.loadedTimeRanges" {
//			print(change)
			activityIndicatorView.stopAnimating()
			controlsContainerView.backgroundColor = .clear
			pausePlayButton.isHidden = false
			isPlaying = true
			
			if let duration = player?.currentItem?.duration {
				let seconds = CMTimeGetSeconds(duration)
				
				let secondsText = Int(seconds) % 60
				let minutesText = String(format: "%02d", Int(seconds) / 60)
				videoLengthLabel.text = "\(minutesText):\(secondsText)"
			}
			
		}
	}
	
	private func setupGradientLayer() {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.bounds
		
		gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gradientLayer.locations = [0.7, 1.2]
		
		controlsContainerView.layer.addSublayer(gradientLayer)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class VideoLauncher: NSObject {
	
	func showVideoPlayer() {
		print("Showing video player animation...")
		
		if let keyWindow = UIApplication.shared.keyWindow {
			let view = UIView(frame: keyWindow.frame)
			view.backgroundColor = .white
			
			view.frame = CGRect(
				x: keyWindow.frame.width - 10,
				y: keyWindow.frame.height - 10,
				width: 10,
				height: 10
			)
			
			//16 x 9 is the aspect ratio of all HD videos
			let height = keyWindow.frame.width * 9 / 16
			let videoPlayerFrame = CGRect(x: 0,
			                              y: 0,
			                              width: keyWindow.frame.width,
			                              height: height)
			let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
			view.addSubview(videoPlayerView)
			
			keyWindow.addSubview(view)
			
			UIView.animate(
				withDuration: 0.5,
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 1,
				options: .curveEaseOut,
				animations: {
					view.frame = keyWindow.frame
				},
				completion: { (comepletedAnimation) in
					//maybe we'll do something here later...
					UIApplication.shared.setStatusBarHidden(true, with: .fade)
				}
			)
			
			
		}
	}
}
