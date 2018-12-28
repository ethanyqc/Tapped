//
//  ContainerViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 3/2/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.



import UIKit
import CHIPageControl



class ContainerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageCtrl: CHIPageControlPaprika!
    internal let numberOfPages = 3
    @IBOutlet weak var titleLbl: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        
        let left = self.storyboard?.instantiateViewController(withIdentifier: "postView") as! TapMsgViewController
        self.addChildViewController(left)
        self.scroll.addSubview(left.view)
        self.didMove(toParentViewController: self)
        left.view.frame = scroll.bounds
        
        let mid = self.storyboard?.instantiateViewController(withIdentifier: "camView") as! CameraViewController
        self.addChildViewController(mid)
        self.scroll.addSubview(mid.view)
        self.didMove(toParentViewController: self)
        mid.view.frame = scroll.bounds
        
        var middleFrame: CGRect = mid.view.frame
        middleFrame.origin.x = self.view.frame.width
        mid.view.frame = middleFrame
        
        let right = self.storyboard?.instantiateViewController(withIdentifier: "imgView") as! ImagePickerViewController
        self.addChildViewController(right)
        self.scroll.addSubview(right.view)
        self.didMove(toParentViewController: self)
        right.view.frame = scroll.bounds
        
        var rightFrame: CGRect = right.view.frame
        rightFrame.origin.x = 2 * self.view.frame.width
        right.view.frame = rightFrame
        
        self.scroll.contentSize = CGSize(width: (self.view.frame.width) * 3, height: (self.view.frame.height))
        self.scroll.contentOffset = CGPoint(x: (self.view.frame.width), y: 0)
        


    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        let progress = percent * Double(self.numberOfPages - 1)
        
        pageCtrl.progress = progress

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        let progress = percent * Double(self.numberOfPages - 1)
        if progress == 2 {
            self.titleLbl.setTitleColor(UIColor.white, for: .normal)
        }
        else if progress == 0{
            self.titleLbl.setTitleColor(UIColor.lightGray, for: .normal)
        }
        else if progress == 1 {
            self.titleLbl.setTitleColor(UIColor.white, for: .normal)
            //self.titleLbl.text = "📸"
        }
    }
    

    

    
    


}


