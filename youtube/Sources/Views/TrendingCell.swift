//
//  TrendingCell.swift
//  youtube
//
//  Created by aney on 2017. 2. 19..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {

	override func fetchVideos() {
		ApiService.sharedInstance.fetchTrendingFeed { (videos) in
			self.videos = videos
			self.collectionView.reloadData()
		}
	}
}
