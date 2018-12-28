//
//  ImagePickerViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/25/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Photos
import Firebase
import NotificationBannerSwift




class ImagePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var lastImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var images:[UIImage] = []
    var allFriend : [AppUser] = []
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    let imageFolder = Storage.storage().reference().child("images")
    var uploadTask : StorageUploadTask?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 20
        tableView.tableFooterView = UIView() // delete seperator for unused rows
        
        
        
        DispatchQueue.main.async {
            self.images.removeAll()
            self.fetchPhotos()
            //get last three photos
            if self.images.isEmpty == false {
                self.lastImage.image = self.images[0].fixedOrientation()
            }

        }

        
        //MARK: send FCM token
        if let curUid = Auth.auth().currentUser?.uid {
            
            
            //MARK: Snapshoting the contact of current users
            DataService.instance.REF_CONTACT.child(curUid).observe(.childAdded) {(snapshot) in
                if let friendDict = snapshot.value as? NSDictionary {
                    if let name = friendDict["name"] as? String, let email = friendDict["email"] as? String, let username = friendDict["username"] as? String {
                        
                        //MARK: friend object
                        let friend = AppUser(uid: snapshot.key, email: email, name: name, username: username)
                        self.allFriend.append(friend)
                        self.allFriend = self.allFriend.sorted { $0.name < $1.name }
                        self.tableView.reloadData()
                        
                        //MARK: add remove listener
                        DataService.instance.REF_CONTACT.child(curUid).observe(.childRemoved, with: { (snapshot) in
                            var index = 0
                            for friend in self.allFriend {
                                if snapshot.key == friend.uid {
                                    self.allFriend.remove(at: index)
                                }
                                index+=1
                            }
                            self.tableView.reloadData()
                        })
                        
                        
                    }
                    else{
                        print("unsuccessful acquire friend name and email")
                    }
                }
                else{
                    print("unsuccessful acquire Friend Dcitionary snap value")
                }
            }
            
        }
        else {
            print("unsuccessful acqurie uid")
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    
    func fetchPhotos () {
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 3
        
        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 3 // <-- The number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.images += [image]
            }
            // If you haven't already reached the first
            // index of the fetch result and if you haven't
            // already stored all of the images you need,
            // perform the fetch request again with an
            // incremented index
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                // Else you have completed creating your array
                print("Completed array: \(self.images)")
            }
        })
    }
    @IBAction func refresh(_ sender: Any) {
        self.images.removeAll()
        self.fetchPhotos()
        //get last three photos
        if self.images.isEmpty == false {
            self.lastImage.image = self.images[0].fixedOrientation()
            let banner = NotificationBanner(title: "Refreshed! ✅", subtitle: "Photo has been refreshed", style: .success)
            banner.show(bannerPosition: .top)
        }
        
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        scrollView.isScrollEnabled = true
        if offset < -100 {
            scrollView.isScrollEnabled = false
            generator.prepare()
            generator.impactOccurred()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "picToPopUp", sender: self)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picToPopUp" {
            if let popUp = segue.destination as? PicPopUpViewController {
                popUp.popTitle = MsgData.instance.msg
                
                
            }
        }
    }
    

    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFriend.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! CustomPhotoCell
        
        let friend = allFriend[indexPath.row]
        if friend.name == Auth.auth().currentUser?.displayName {
            cell.nameLbl.text = friend.name+"(me)"
        }
        else {
            cell.nameLbl.text = friend.name
        }
        cell.nameLbl.backgroundColor = UIColor.clear
        
        
        return cell
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        
    }
    
    //MARK: Select cell
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageName = "\(NSUUID().uuidString).jpeg"
        let friend = allFriend[indexPath.row]
        
        print(friend.uid+" "+friend.name+" "+friend.email)
        
        //impact ge
        generator.prepare()
        generator.impactOccurred()
        
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomPhotoCell
        
        
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.nameLbl.text = ":)"
            currentCell.nameLbl.alpha = 0.9
            currentCell.isUserInteractionEnabled = false
            
        }) { (finished) in
            
            UIView.animate(withDuration: 1.5, animations: {
                currentCell.nameLbl.alpha = 1.0
                currentCell.nameLbl.text = "TAPPED!"
                currentCell.isUserInteractionEnabled = false
                
            }, completion: { (finished) in
                
                //Send message
                if let name = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email, let userUid = Auth.auth().currentUser?.uid{
                    

                    
                    if let image = self.lastImage.image {
                        if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                            self.uploadTask = self.imageFolder.child(imageName).putData(imageData, metadata: nil, completion: { (metadata, error) in
                                if let error = error {
                                    print(error)
                                }
                                else{
                                    if let imageURL = metadata?.downloadURL()?.absoluteString {
                                        let today = Date()
                                        
                                        
                                        DataService.instance.sendSnap(msgType: "pic", msgColor: MsgData.instance.colorStr, friendUID: friend.uid, message: MsgData.instance.msg, email: userEmail, name: name, fromUid: userUid, date: today.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), imageName: imageName, imageURL: imageURL)
                                        
                                        
                                    }
                                    print("upload finished with success")
                                    
                                }
                            })
                            

                            self.uploadTask?.observe(.failure) { snapshot in
                                if let error = snapshot.error as NSError? {
                                    switch (StorageErrorCode(rawValue: error.code)!) {
                                    case .objectNotFound:
                                        UNService.shared.timerRequest(with: 0.05, title: "objectNotFound", body: "")

                                        break
                                    case .unauthorized:
                                        // User doesn't have permission to access file
                                        UNService.shared.timerRequest(with: 0.05, title: "unauthorized", body: "")

                                        break
                                    case .cancelled:
                                        // User canceled the upload
                                        UNService.shared.timerRequest(with: 0.05, title: "upload cancelled", body: "")

                                        
                                        break
                                        
                                    case .unknown:
                                        // Unknown error occurred, inspect the server response
                                        UNService.shared.timerRequest(with: 0.05, title: "unknown error", body: "")

                                        
                                        break
                                    default:
                                        // A separate error occurred. This is a good place to retry the upload.
                                        break
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                    
                    /*
                    DataService.instance.sendSnap(msgType: "msg", friendUID: friend.uid, message: fMessage, email: userEmail, name: name, fromUid: userUid, date:today.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), imageName: "", imageURL: "")
                    */
                    
                }
                //Restore name and color, reenable user interaction
                currentCell.nameLbl.text = friend.name
                currentCell.isUserInteractionEnabled = true
                currentCell.nameLbl.backgroundColor = UIColor.clear
            })
            
            
        }//end animation
        
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    




}
