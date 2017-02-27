//
//  HomeController.swift
//  youtube
//
//  Created by aney on 2017. 2. 8..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	//MARK: Properties
	
	let cellId = "cellId"
	let trendingCellId = "trendingCellId"
	let subscriptionCellId = "subscriptionCellId"
	let titles = ["Home", "Trending", "Subscriptions", "Account"]
	

	//MARK: UI
    
	lazy var menuBar: MenuBar = {
		let mb = MenuBar()
		mb.homeController = self
		
		return mb
	}()
	
	lazy var settingLauncher: SettingLauncher = {
		let launcher = SettingLauncher()
		launcher.homeController = self
		return launcher
	}()
	
	//MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.isTranslucent = false
		
		let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
		titleLabel.text = "  Home"
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 20)
		
		navigationItem.titleView = titleLabel
		
		setupCollectionView()
		
		setupMenuBar()
		
		setupNavBarButtons()
	}
	
    
	private func setupMenuBar() {
		navigationController?.hidesBarsOnSwipe = true
		
		let redView = UIView()
		redView.backgroundColor = UIColor.rgb(colorLiteralRed: 230, green: 32, blue: 31)
		view.addSubview(redView)
		view.addConstraintsWithFormat("H:|[v0]|", views: redView)
		view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
		
		view.addSubview(menuBar)
		view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
		view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)

		menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
	}
    
	private func setupCollectionView() {
		if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
			flowLayout.scrollDirection = .horizontal
			flowLayout.minimumLineSpacing = 0
		}
		
		collectionView?.backgroundColor = UIColor.white
		
		collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
		collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
		
		collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
		collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
		
		collectionView?.isPagingEnabled = true
	}
    
	private func setupNavBarButtons() {
		let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
		let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
		
		let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
		
		navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
	}
	
	func handleMore() {
		settingLauncher.showSettings()
	}
    
	func showControllerForSetting(setting: Setting) {
		let dummySettingsViewController = UIViewController()
		
		dummySettingsViewController.view.backgroundColor = UIColor.white
		dummySettingsViewController.navigationItem.title = setting.name
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		navigationController?.navigationBar.tintColor = UIColor.white
		navigationController?.pushViewController(dummySettingsViewController, animated: true)
	}
	
	func handleSearch() {
		scrollToMenuIndex(menuIndex: 2)
	}
	
	func scrollToMenuIndex(menuIndex: Int) {
		let indexPath = IndexPath(item: menuIndex, section: 0)
		collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		
		setTitleForIndex(index: menuIndex);
	}
	
	private func setTitleForIndex(index: Int) {
		if let titleLabel = navigationItem.titleView as? UILabel {
			titleLabel.text = "  \(titles[index])"
		}
	}
	
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
		
		menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x/4
	}
    
    
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
			
		let index = targetContentOffset.pointee.x / view.frame.width
		
		let indexPath = IndexPath(item: Int(index), section: 0)
		menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
		
		setTitleForIndex(index: Int(index));
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return 4
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let identifier: String
		
		if indexPath.item == 1 {
			identifier = trendingCellId
		} else if indexPath.item == 2 {
			identifier = subscriptionCellId
		} else {
			identifier = cellId
		}
			
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
		
		return cell
	}
    
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: view.frame.height - 50)
	}
    
}
