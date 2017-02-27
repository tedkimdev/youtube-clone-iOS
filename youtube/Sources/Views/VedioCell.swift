//
//  VideoCell.swift
//  youtube
//
//  Created by aney on 2017. 2. 9..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit


//MARK:- BaseCell Class

class BaseCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	func setupViews() {
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


//MARK:- VideoCell Class

class VideoCell: BaseCell {
	
	//MARK: Properties
	
	var titleLabelHeightConstraint: NSLayoutConstraint?
	
	var video: Video? {
		didSet {
			titleLabel.text = video?.title
			
			setupThumbnailImage()
			
			setupProfileImage()
			
			if let channelName = video?.channel?.name,
				let numberOfViews = video?.number_of_views {
				
				let numberFormatter = NumberFormatter()
				numberFormatter.numberStyle = .decimal
				
				let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberOfViews)!) - 2 years ago"
				subtitleTextView.text = subtitleText
			}
			
			//measure title text
			if let title = video?.title {
				
				let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
				let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
				let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
				
				if estimatedRect.size.height > 20 {
					titleLabelHeightConstraint?.constant = 44
				} else {
					titleLabelHeightConstraint?.constant = 20
				}
			}
		}
	}
	
	
	//MARK: UI
	
	let thumbnailImageView: CustomImageView = {
		let imageView = CustomImageView()
		imageView.image = UIImage(named: "emptyTumbnail")
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let userProfileImageView: CustomImageView = {
		let imageView = CustomImageView()
		imageView.image = UIImage(named: "emptyTumbnail")
		imageView.layer.cornerRadius = 22
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		
		return imageView
	}()
	
	let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1)
		return view
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Taylor Swift - Blank Space"
		label.numberOfLines = 2
		return label
	}()
	
	let subtitleTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.text = "TaylorSwiftVEVO - 1,604,684,607 views - 2 years ago"
		textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
		textView.textColor = UIColor.lightGray
		
		return textView
	}()
	
	
	func setupProfileImage() {
		if let profileImageUrl = video?.channel?.profile_image_name {
			
			userProfileImageView.loadImageUsingUrlString(profileImageUrl)
			
		}
	}
	
	func setupThumbnailImage() {
		if let thumbnailImageUrl = video?.thumbnail_image_name {
			
			thumbnailImageView.loadImageUsingUrlString(thumbnailImageUrl)
			
		}
	}
	
	override func setupViews() {
		super.setupViews()
		
		addSubview(thumbnailImageView)
		addSubview(separatorView)
		addSubview(userProfileImageView)
		addSubview(titleLabel)
		addSubview(subtitleTextView)
		
		addConstraintsWithFormat("H:|-16-[v0]-16-|", views: thumbnailImageView)
		
		addConstraintsWithFormat("H:|-16-[v0(44)]", views: userProfileImageView)
		
		//vertical constraints
		addConstraintsWithFormat("V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
		
		addConstraintsWithFormat("H:|[v0]|", views: separatorView)
		
		//top contraints
		addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
		
		//left constraints
		addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
		
		//right constraints
		addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
		
		//height constraints
		titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
		
		//top constraints
		addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
		//left constraints
		addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
		//right constraints
		addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
		//height constraints
		addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
		
	}
}

