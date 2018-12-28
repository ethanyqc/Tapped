//
//  MessageDisplayViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/5/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import UIColor_Hex_Swift

class MessageDisplayViewController: UIViewController {

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var backBoard: phoneView!
    
    @IBOutlet weak var senderName: UILabel!
    
    var snap : Snaps?
    var snapID = ""
    var backBoardPos : CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        backBoardPos = backBoard.frame.origin
        setUpDragable()
        senderName.text = snap?.name
        msgLabel.text = snap?.message
        msgLabel.textColor = getComplementaryForColor(color: UIColor((snap?.msgColor)!))
        //get snapID
        if let snapID = snap?.snapID {
            self.snapID = snapID
        }
        backBoard.backgroundColor = UIColor((snap?.msgColor)!)
    }
    
    func setUpDragable() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.backBoard.addGestureRecognizer(panGestureRecognizer)
    }
    @objc func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: backBoard)
        backBoard.frame.origin = translation
        
        if gesture.state == .ended {
            let velo = gesture.velocity(in: backBoard)
            
            if velo.y >= 1500 {
                if let curUid = Auth.auth().currentUser?.uid {
                    DataService.instance.removeSnap(curUid: curUid, snapID: self.snapID)
                }
                dismiss(animated: true, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backBoard.frame.origin = self.backBoardPos!
                })
            }
            
        }
        
    }

    func getComplementaryForColor(color: UIColor) -> UIColor {
        
        let ciColor = CIColor(color: color)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    

    
}
