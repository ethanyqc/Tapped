//
//  CameraViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/29/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase



class CameraViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVCapturePhotoCaptureDelegate, UIGestureRecognizerDelegate {

    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var captureSession = AVCaptureSession()
    var backCam: AVCaptureDevice?
    var frontCam: AVCaptureDevice?
    var curCam: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var camPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var allFriend : [AppUser] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var `switch`: UIButton!
    //var image: UIImage?
    var image : UIImage?
    var friendUID = ""
    var selfieMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 20
        
        //re run the seesion when enter backgound
        NotificationCenter.default.addObserver(self, selector:#selector(CameraViewController.startRunningCaptureSessionAgain), name:NSNotification.Name.UIApplicationWillEnterForeground, object:UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector:#selector(CameraViewController.startRunningCaptureSessionAgain), name:NSNotification.Name.UIApplicationDidBecomeActive, object:UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector:#selector(CameraViewController.pauseSession), name:NSNotification.Name.UIApplicationDidEnterBackground, object:UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector:#selector(CameraViewController.pauseSession), name:NSNotification.Name.UIApplicationWillResignActive, object:UIApplication.shared)

        
       //
            self.setupLongPressGesture()
            self.setUpCapSession()
            self.setUpDevice()
            self.setUpInputOutPut()
            self.setUpPreviewLayer()
            self.startRunningCaptureSession()
        
        DispatchQueue.main.async {
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
                print("user is not logged in")
            }
        }
    }
    


    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //MARK: enable touch upon screen appear

        tableView.isUserInteractionEnabled = true
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.6// 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            
            //MARK: save need to do to dismiss view controller
            
        }
        
    }
    

    
    func setUpCapSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setUpDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCam = device
            }
            else if device.position == AVCaptureDevice.Position.front{
                frontCam = device
            }
        }
        curCam = backCam
        
    }

    func setUpInputOutPut() {
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: curCam!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
        
    }
    func setUpPreviewLayer() {
        camPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        camPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        camPreviewLayer?.frame = self.view.frame
        //self.view.layer.addSublayer(camPreviewLayer!)
        self.view.layer.insertSublayer(camPreviewLayer!, at: 0)
    }

    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    @objc func startRunningCaptureSessionAgain() {
        captureSession.startRunning()
        print("rerun session")
    }

    @objc func pauseSession() {
        captureSession.stopRunning()
        print("stop session")
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "photoPreview" {
            if let previewVC = segue.destination as? PreviewViewController {
                let currentCameraInput: AVCaptureInput = captureSession.inputs[0]
                if (currentCameraInput as! AVCaptureDeviceInput).device.position == .front {
                    let flippedImage = UIImage(cgImage: (self.image?.cgImage)!, scale: (self.image?.scale)!, orientation: .leftMirrored)
                    previewVC.image = flippedImage
                }
                else {
                    //pass image
                    previewVC.image = self.image
                }
                
                
                
                //pass send to user info
                previewVC.friendUID = self.friendUID
                
                
                previewVC.message = MsgData.instance.msg
                

                
                previewVC.imageName = "\(NSUUID().uuidString).jpeg"
            }
            
       
        }
        else if segue.identifier == "camToPopUp" {
            if let popUp = segue.destination as? CamPopUpViewController {
                popUp.popTitle = MsgData.instance.msg
            }
            
        }

    }
    
    
    //Mark taking pictures
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            
                image = UIImage(data: imageData)
                //deqgueway to preview
                performSegue(withIdentifier: "photoPreview", sender: nil)
            
        }
    }
    

    //MARK: TableView Configuration
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFriend.count
    }
    
    //MARK: delegate for animation of loading cell
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picCell", for: indexPath) as! CustomPicCell
        let friend = allFriend[indexPath.row]
        
        if friend.name == Auth.auth().currentUser?.displayName {
            cell.picUserLbl.text = friend.name+"(me)"
        }
        else {
           cell.picUserLbl.text = friend.name
        }
        cell.picUserLbl.textColor = UIColor.white
        cell.picUserLbl.backgroundColor = UIColor.clear
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false //disable touch on other cell
        //impact gen
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        let friend = allFriend[indexPath.row]
        self.friendUID = friend.uid
        
        //MARK: when cell tapped, snap!
        let setting = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: setting, delegate: self)
        
        

        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    //MARK: segue to camera pop up view
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
        let offset = scrollView.contentOffset.y
        if offset < -150 {
            scrollView.isScrollEnabled = false
            generator.prepare()
            generator.impactOccurred()
            self.performSegue(withIdentifier: "camToPopUp", sender: nil)
        }
    }
    
    //MARK: switch camera side
    @IBAction func switchCam(_ sender: Any) {
            let currentCameraInput: AVCaptureInput = self.captureSession.inputs[0]
            self.captureSession.removeInput(currentCameraInput)
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                self.curCam = self.frontCam!
            } else {
                self.curCam = self.backCam!
            }
        
            do{
                let newVideoInput = try AVCaptureDeviceInput(device: self.curCam!)
                captureSession.addInput(newVideoInput)
            } catch {
                print(error)
            }
        
        
    }
    
    

}


















