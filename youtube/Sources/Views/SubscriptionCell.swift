//
//  SubscriptionCell.swift
//  youtube
//
//  Created by aney on 2017. 2. 19..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {

	override func fetchVideos() {
		ApiService.sharedInstance.fetchSubscriptionFeed { (videos) in
			self.videos = videos
			self.collectionView.reloadData()
		}
	}

}
