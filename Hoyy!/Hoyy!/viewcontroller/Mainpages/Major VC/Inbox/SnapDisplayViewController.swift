//
//  SnapDisplayViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/5/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//
import UIKit
import SDWebImage
import Firebase


class SnapDisplayViewController: UIViewController {

    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var msgLabel: UILabel!
    var snap : Snaps?
    var imageName = ""
    var snapID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let message = snap?.message {
            if let imageName = snap?.imageName {
                if let imageURL = snap?.imageURL {
                    msgLabel.text = message
                    self.imageName = imageName
                    if let url = URL(string: imageURL) {
                        snapImageView.sd_setShowActivityIndicatorView(true)
                        snapImageView.sd_setIndicatorStyle(.white)
                        if snap?.msgType == "pic" {
                            self.snapImageView.contentMode = .scaleAspectFit
                            snapImageView.sd_setImage(with: url, completed: nil)
                        }
                        else {
                            self.snapImageView.contentMode = .scaleAspectFill
                           snapImageView.sd_setImage(with: url, completed: nil)
                        }
                        
                    }
                }
            }
        }
        if let snapID = snap?.snapID {
            self.snapID = snapID
        }
        
        

        
    }

    @IBAction func cancel(_ sender: Any) {
        if let curUid = Auth.auth().currentUser?.uid {
            DataService.instance.removeSnap(curUid: curUid, snapID: self.snapID)
            Storage.storage().reference().child("images").child(self.imageName).delete(completion: nil)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    

}
