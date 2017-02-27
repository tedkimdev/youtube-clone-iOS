//
//  Vedio.swift
//  youtube
//
//  Created by aney on 2017. 2. 9..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit


//MARK:- SafeJsonObject Class

class SafeJsonObject: NSObject {
	override func setValue(_ value: Any?, forKey key: String) {
		let uppercasedFirstCharacter = String(key.characters.first!).uppercased()
		
		let range = key.startIndex..<key.index(key.startIndex, offsetBy: 1)
		
		let selectorString = key.replacingCharacters(in: range, with: uppercasedFirstCharacter)
		
		let selector = NSSelectorFromString("set\(selectorString):")
		let responds = self.responds(to: selector)
		
		if !responds {
			return
		}
		
		super.setValue(value, forKey: key)
	}
}


//MARK:- Video Class

class Video: SafeJsonObject {
	
	//MARK: Properties
	var thumbnail_image_name: String?
	var title: String?
	var number_of_views: NSNumber?
	var uploadDate: Date?
	var duration: NSNumber?
	var channel: Channel?
	
//	var number_likes: NSNumber?
	
	override func setValue(_ value: Any?, forKey key: String) {
		if key == "channel" {
			//custom channel setup
			self.channel = Channel()
			self.channel?.setValuesForKeys(value as! [String: AnyObject])
		} else {
			super.setValue(value, forKey: key)
		}
	}
	
	init(dictionary: [String:AnyObject]) {
		super.init()
		setValuesForKeys(dictionary)
	}
}


//MARK:- Channel Class

class Channel: SafeJsonObject {
    var name: String?
    var profile_image_name: String?
}
