//
//  MainViewController.swift
//  PageController
//
//  Created by Vinod on 10/25/17.
//  Copyright © 2017 Vinod. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIScrollViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let DefaultEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)//Set edge insets to menu button
    let menuArray = ["First","Second","Third"] // Menu button titles
    let font = UIFont.systemFont(ofSize: 14.0)// Font size for button title text
    
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add buttons to MenuScrollView:
        self.addButtonsToMenuScrollView(menuArray)
        
        self.menuScrollView.layer.borderWidth = 1.0
        self.menuScrollView.layer.borderColor = UIColor.lightGray.cgColor
        self.menuScrollView.layer.masksToBounds = true
        
        //Instantiate view controllers those want to add in Page Controller.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
        
        self.addControllersToMainScrollView([firstVC,secondVC,thirdVC])
    }
    // MARK: - Add buttons to scroll View
    
    func addButtonsToMenuScrollView(_ array:[String]) {
        let bHeight: CGFloat = self.menuScrollView.bounds.size.height
        var cWidth: CGFloat = 0.0
        for i in 0...array.count - 1 {
            
            let bWidth: CGFloat = self.calculateButtonWidth(array[i], DefaultEdgeInset) // Width of button considering attributes
            let frame: CGRect = CGRect(x: cWidth, y: 0, width: bWidth, height: bHeight)
            let menuButton = self.createButtonProgramaticallyAndCustomise(array[i], frame, i)
            self.menuScrollView.addSubview(menuButton)
            
            //Add bottom view to button to show selected status
            let bottomViewFrame = CGRect(x: 0, y: menuButton.frame.size.height - 5, width: menuButton.frame.size.width, height: 5)
            let selectionView = self.createButtonBottomView(bottomViewFrame)
            menuButton.addSubview(selectionView)
            
            if i == 0 {
                menuButton.isSelected = true
                selectionView.isHidden = false
            } else {
                selectionView.isHidden = true
            }
            cWidth += bWidth
        }
        
        self.menuScrollView.contentSize = CGSize(width: cWidth, height: self.menuScrollView.bounds.size.height)
    }
    
    func createButtonProgramaticallyAndCustomise(_ title:String, _ frame: CGRect, _ tag: Int) -> UIButton {
        //Create button programatically and add to Menu ScrollView
        let button: UIButton = UIButton(type: .custom)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        
        //Set selected and normat color propreties to button
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .selected)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.tag = tag
        
        return button
    }
    
    func createButtonBottomView(_ btnViewFrame: CGRect) -> UIView {
        let bottomView = UIView(frame: btnViewFrame)
        bottomView.backgroundColor = UIColor.red
        bottomView.tag = 999
        return bottomView
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let bWidth: CGFloat = 0
        
        for case let btn as UIButton in self.menuScrollView.subviews {
            let btmView = btn.viewWithTag(999)
            if btn.tag == sender.tag {
                btn.isSelected = true
                btmView?.isHidden = false
            } else {
                btn.isSelected  = false
                btmView?.isHidden = true
            }
        }
        
        let width = screenWidth * CGFloat(sender.tag)
        self.containerScrollView.setContentOffset(CGPoint(x:width, y:0), animated: true)
        let xCordinate = screenWidth * CGFloat(sender.tag) * (bWidth / screenWidth) - bWidth
        self.menuScrollView.scrollRectToVisible(CGRect(x:xCordinate, y:0, width:screenWidth, height:self.menuScrollView.frame.size.height), animated: true)
    }
    
    func calculateButtonWidth(_ title: String, _ buttonEdgeInsets: UIEdgeInsets) -> CGFloat {
        
        let size: CGSize = title.size(withAttributes: [NSAttributedStringKey.font: font])
        let dividedSize = (screenWidth / CGFloat(menuArray.count))
        return (dividedSize < size.width) ? (size.width + buttonEdgeInsets.left + buttonEdgeInsets.right) : (dividedSize + buttonEdgeInsets.left + buttonEdgeInsets.right)
    }
    
    func addControllersToMainScrollView(_ viewController:[UIViewController]) {
        for i in 0...viewController.count - 1 {
            let vc = viewController[i]
            var frame = CGRect(x: 0, y: 0, width: self.containerScrollView.frame.size.width, height: self.containerScrollView.frame.size.height)
            frame.origin.x = screenWidth * CGFloat(i)
            vc.view.frame = frame
            self.addChildViewController(vc)
            self.containerScrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
        self.containerScrollView.contentSize = CGSize(width: screenWidth * CGFloat(viewController.count), height:0)
        self.containerScrollView.delegate = self
        self.containerScrollView.isPagingEnabled = true
    }
    
    //MARK: - ScrollView Delegate Methods:
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x / screenWidth))
        var buttonWidth: CGFloat = 0.0
        for case let button as UIButton in self.menuScrollView.subviews {
            let btmView = button.viewWithTag(999)
            if button.tag == page {
                button.isSelected = true
                buttonWidth = button.frame.size.width
                btmView?.isHidden =  false
            } else {
                button.isSelected = false
                btmView?.isHidden = true
            }
        }
        let xCoordinate = scrollView.contentOffset.x * (buttonWidth / screenWidth) - buttonWidth
        self.menuScrollView.scrollRectToVisible(CGRect(x:xCoordinate, y:0, width:screenWidth, height:self.menuScrollView.frame.size.height), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
