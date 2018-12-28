//
//  PreviewViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/3/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase

class PreviewViewController: UIViewController {

    @IBOutlet weak var percentComplete: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var sendImage: UIImageView!
    var image : UIImage!
    var friendUID = ""
    var message = ""
    var imageName = ""
    
    let imageFolder = Storage.storage().reference().child("images")
    var uploadTask : StorageUploadTask?

    override func viewDidLoad() {
        sendImage.image = self.image
        msgLbl.text = self.message
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let name = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email, let userUid = Auth.auth().currentUser?.uid {
            if let image = sendImage.image {
                if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                    uploadTask = imageFolder.child(imageName).putData(imageData, metadata: nil, completion: { (metadata, error) in
                            if let error = error {
                                print(error)
                            }
                            else{
                                if let imageURL = metadata?.downloadURL()?.absoluteString {
                                    let today = Date()
                                    
                                    
                                    DataService.instance.sendSnap(msgType: "snap", msgColor: MsgData.instance.colorStr, friendUID: self.friendUID, message: self.message, email: userEmail, name: name, fromUid: userUid, date: today.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), imageName: self.imageName, imageURL: imageURL)
                                    
                                    
                                }
                                print("upload finished with success")
  
                            }
                    })
                    
                    //MARK: auto dismiss after 2 seconds
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
                        //print("upload observe success")
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    uploadTask?.observe(.progress) { snapshot in
                        // Upload reported progress
                        self.percentComplete.text = String(100 * Int(snapshot.progress!.completedUnitCount)
                            / Int(snapshot.progress!.totalUnitCount))+"%"
                    }
                    uploadTask?.observe(.success) { snapshot in
                        
                        /*
                        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { (timer) in
                            print("upload observe success")
                            self.dismiss(animated: true, completion: nil)
                        })
                        */
                        print("upload observe success")
                        
                    }
                    uploadTask?.observe(.failure) { snapshot in
                        if let error = snapshot.error as NSError? {
                            switch (StorageErrorCode(rawValue: error.code)!) {
                            case .objectNotFound:
                                UNService.shared.timerRequest(with: 0.05, title: "objectNotFound", body: "")
                                self.dismiss(animated: true, completion: nil)
                                break
                            case .unauthorized:
                                // User doesn't have permission to access file
                                UNService.shared.timerRequest(with: 0.05, title: "unauthorized", body: "")
                                self.dismiss(animated: true, completion: nil)
                                break
                            case .cancelled:
                                // User canceled the upload
                                UNService.shared.timerRequest(with: 0.05, title: "upload cancelled", body: "")
                                self.dismiss(animated: true, completion: nil)
                                
                                break

                            case .unknown:
                                // Unknown error occurred, inspect the server response
                                UNService.shared.timerRequest(with: 0.05, title: "unknown error", body: "")
                                self.dismiss(animated: true, completion: nil)
                                
                                break
                            default:
                                // A separate error occurred. This is a good place to retry the upload.
                                break
                            }
                        }
                    }
                    
                    
                    
                }
            }
        }
        



    }

    @IBAction func cancelUpload(_ sender: Any) {
        print(friendUID+" "+message)
        self.uploadTask?.cancel()
        
        self.uploadTask?.removeAllObservers()
        dismiss(animated: true, completion: nil)
    }



}

