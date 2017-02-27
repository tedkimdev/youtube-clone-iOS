//
//  MenuBar.swift
//  youtube
//
//  Created by aney on 2017. 2. 9..
//  Copyright © 2017년 aney. All rights reserved.
//

import UIKit


//MARK:- MenuCell Class

class MenuCell: BaseCell {
	
	//MARK: Properties
	
	override var isHighlighted: Bool {
		didSet {
			imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(colorLiteralRed: 91, green: 14, blue: 13)
		}
	}
	
	override var isSelected: Bool {
		didSet {
			imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(colorLiteralRed: 91, green: 14, blue: 13)
		}
	}
	
	
	//MARK: UI
	
	let imageView: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
		iv.tintColor = UIColor.rgb(colorLiteralRed: 91, green: 14, blue: 13)
		return iv
	}()
	
	override func setupViews() {
		super.setupViews()
		
		addSubview(imageView)
		addConstraintsWithFormat("H:[v0(28)]", views: imageView)
		addConstraintsWithFormat("V:[v0(28)]", views: imageView)
		
		addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
}


//MARK:- MenuBar Class

class MenuBar: UIView {
	
	
	//MARK: Properties
	
	let cellId = "cellId"
	let imageNames = ["home", "trending", "subscriptions", "account"]
	var homeController: HomeController?
	var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
	
	//MARK: UI
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = UIColor.rgb(colorLiteralRed: 230, green: 32, blue: 31)
		cv.dataSource = self
		cv.delegate = self
		return cv
	}()
	
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
		
		addSubview(collectionView)
		addConstraintsWithFormat("H:|[v0]|", views: collectionView)
		addConstraintsWithFormat("V:|[v0]|", views: collectionView)
		
		let selectedIndexPath = IndexPath(item: 0, section: 0)
		collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
		
		setupHorizontalBar()
	}
	
	func setupHorizontalBar() {
		let horizontalBarView = UIView()
		horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1)
		horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(horizontalBarView)
		
		//old school frame way of doing things
//        horizontalBarView.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
		
		//new school way of laying out our views
		//in ios9
		//need x, y, width, height constraints
		horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
		horizontalBarLeftAnchorConstraint?.isActive = true
		horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
		horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
}


//MARK:- UICollectionViewDataSource

extension MenuBar: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
		
		cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
		cell.tintColor = UIColor.rgb(colorLiteralRed: 91, green: 14, blue: 13)
		
		return cell
	}
}


//MARK:- UICollectionViewDelegate

extension MenuBar: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		//        print(indexPath.item)
		//        let x = CGFloat(indexPath.item) * frame.width / 4
		//        horizontalBarLeftAnchorConstraint?.constant = x
		//
		//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
		//            self.layoutIfNeeded()
		//        }, completion: nil)
		
		homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
	}
}


//MARK:- UICollectionViewDelegateFlowLayout

extension MenuBar: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: frame.width/4, height: frame.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
