//
//  SettingLauncher.swift
//  youtube
//
//  Created by aney on 2017. 2. 11..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class SettingLauncher: NSObject {
	
	
	//MARK: Properties
	
	let cellId = "cellId"
	let cellHeight: CGFloat = 50
	let settings: [Setting] = {
		return [Setting(name: "Settings", imageName: "settings"),
		        Setting(name: "Terms & privacy policy", imageName: "privacy"),
		        Setting(name: "Send Feedback", imageName: "feedback"),
		        Setting(name: "Help", imageName: "help"),
		        Setting(name: "Cancel", imageName: "cancel"),
		        ]
	}()
	var homeController: HomeController?
	
	
	//MARK: UI
	
	let blackView = UIView()
	
	let collectionView: UICollectionView = {
			let layout = UICollectionViewFlowLayout()
			let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
			cv.backgroundColor = UIColor.white
			return cv
	}()
    
	func showSettings() {
		//show menu
		if let window = UIApplication.shared.keyWindow {
				
			blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
			
			blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
			
			window.addSubview(blackView)
			
			window.addSubview(collectionView)
			
			let height: CGFloat = CGFloat(settings.count) * cellHeight
			let y = window.frame.height - height
			collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
			
			blackView.frame = window.frame
			blackView.alpha = 0
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
					
					self.blackView.alpha = 1
					
					self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
					
			}, completion: nil)
		}
	}
	
	func handleDismiss(setting: Setting) {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				
				self.blackView.alpha = 0
				
				if let window = UIApplication.shared.keyWindow {
					self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
				}
				
		}) { (completed: Bool) in
				
			if setting.name != "" && setting.name != "Cancel" {
				self.homeController?.showControllerForSetting(setting: setting)
			}
				
		}
	}
	
	override init() {
		super.init()
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
	}
}


//MARK:- UICollectionViewDataSource

extension SettingLauncher: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return settings.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SettingCell
		
		let setting = settings[indexPath.item]
		
		cell.setting = setting
		
		return cell
	}
}


//MARK:- UICollectionViewDelegate

extension SettingLauncher: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let setting = settings[indexPath.item]
		handleDismiss(setting: setting)
		
	}
}


//MARK:- UICollectionViewDelegateFlowLayout

extension SettingLauncher: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
