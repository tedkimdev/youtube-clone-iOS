//
//  ApiService.swift
//  youtube
//
//  Created by aney on 2017. 2. 12..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
	static let sharedInstance = ApiService()
	
	let baseUrl = "http://s3-us-west-2.amazonaws.com/youtubeassets"
    
	func fetchVideos(completion: @escaping ([Video])->()) {
		fetchFeedForUrlString(urlString: "\(baseUrl)/home_num_likes.json", completion: completion)
	}

	func fetchTrendingFeed(completion: @escaping ([Video])->()) {
		fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
	}
	
	func fetchSubscriptionFeed(completion: @escaping ([Video])->()) {
		fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
	}
	
	func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video])->()) {
		let url = URL(string: urlString)
		URLSession.shared.dataTask(with: url!) { (data, response, error) in
			
			if error != nil {
				print(error!)
				return
			}
			
			do {
				if let unwrappedData = data,
					let jsonDictinaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]]{
					
					DispatchQueue.main.async(execute: {
						completion(jsonDictinaries.map({ return Video(dictionary: $0) }))
					})
				}
			} catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
}
