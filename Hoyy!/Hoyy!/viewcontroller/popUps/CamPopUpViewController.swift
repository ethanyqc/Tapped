//
//  CamPopUpViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/9/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import NotificationBannerSwift

class CamPopUpViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var typeTF: RSKPlaceholderTextView!
    @IBOutlet weak var counter: UILabel!

    var popTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeTF.delegate = self
        typeTF.becomeFirstResponder()
        typeTF.placeholderColor = UIColor.lightGray
        typeTF.placeholder = "What's up?"
        typeTF.tintColor = UIColor.red
        typeTF.keyboardAppearance = .alert
        typeTF.text = popTitle
        counter.text = String(50 - typeTF.text.count)
        if 50 - typeTF.text.count<=10 {
            counter.textColor = UIColor.red
        }

        
        // Do any additional setup after loading the view.
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let allowedChar = 50
        let charInTxtView = -typeTF.text.count
        let remainChar = allowedChar + charInTxtView
        
        if(text == "\n") {
            textView.resignFirstResponder()
            if typeTF.text != "" {
                if let msg = typeTF.text {
                    if remainChar<0 {
                        let banner = NotificationBanner(title: "Ooops 😟", subtitle: "Message too long", style: .warning)
                        banner.show(bannerPosition: .top)
                    }
                    else {
                        
                        MsgData.instance.changeMsg(msg: msg)
                        dismiss(animated: true)
                    }
                    
                }
            }
            else {//if empty, set to default
                
                MsgData.instance.changeMsg(msg: "😉")
                dismiss(animated: true)
            }
            
            
            return false
        }
        return true
        
    }


    @IBAction func dismiss(_ sender: Any) {
        //onsave the txetField data
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func checkRemainChars() {
        let allowChar = 50
        let charsInTF = typeTF.text?.count
        let remainChar = allowChar - charsInTF!
        //print(remainChar)
        if remainChar <= allowChar {
            counter.textColor = UIColor.white
        }
        if remainChar <= 10 {
            counter.textColor = UIColor.red
        }
        
        counter.text = String(remainChar)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainChars()
    }

    


}
