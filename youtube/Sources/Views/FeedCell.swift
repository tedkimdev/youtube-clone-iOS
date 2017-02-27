//
//  FeedCell.swift
//  youtube
//
//  Created by aney on 2017. 2. 12..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
	
	//MARK: Properties
	
	var videos: [Video]?
	let cellId = "cellId"
	
	//MARK: UI
	
	lazy var collectionView: UICollectionView = {
			let layout = UICollectionViewFlowLayout()
			let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
			cv.backgroundColor = UIColor.white
			cv.dataSource = self
			cv.delegate = self
			return cv
	}()
	
	func fetchVideos() {
			ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
					self.videos = videos
					self.collectionView.reloadData()
			}
	}
	
	override func setupViews() {
			super.setupViews()
			
			fetchVideos()
			
			backgroundColor = UIColor.brown
			
			addSubview(collectionView)
			addConstraintsWithFormat("H:|[v0]|", views: collectionView)
			addConstraintsWithFormat("V:|[v0]|", views: collectionView)
			
			collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
	}
	
}


//MARK:- UICollectionViewDataSource

extension FeedCell: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return videos?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
		cell.video = videos?[indexPath.item]
		
		return cell
	}
}


//MARK:- UICollectionViewDelegate

extension FeedCell: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let videoLauncher = VideoLauncher()
		videoLauncher.showVideoPlayer()
	}
}


//MARK:- UICollectionViewDelegateFlowLayout

extension FeedCell: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let height = (frame.width - 16 - 16) * 9 / 16
		return CGSize(width: frame.width, height: height + 16 + 88)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
