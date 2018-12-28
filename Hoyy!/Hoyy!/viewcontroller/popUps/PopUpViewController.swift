//
//  PopUpViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/19/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import NotificationBannerSwift
import ColorSlider


class PopUpViewController: UIViewController, UITextViewDelegate{


    @IBOutlet weak var typeTF: RSKPlaceholderTextView!
    @IBOutlet weak var counter: UILabel!
    
    @IBOutlet weak var typeTFTopConstr: NSLayoutConstraint!
    
    
    @IBOutlet weak var toggleBut: ToggleBut!
    
    

    
    //TODO: COLOR SELECTION METHOD FOR TEXT
    
    
    
    //store message
    var popTitle = ""
    let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSlider.color = MsgData.instance.color
        view.backgroundColor = MsgData.instance.color
        toggleBut.buttonActivated(bool: !MsgData.instance.isBlack)
        if MsgData.instance.isBlack {
            isBlack()
        }
        else {
            isWhite()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        setUpColorSlider()

        typeTF.delegate = self
        typeTFTopConstr.constant = view.frame.height/4

        typeTF.text = popTitle
        counter.text = String(50 - typeTF.text.count)
        colorSlider.alpha = 0
        
        typeTF.keyboardAppearance = .alert
        
        
        
    }
    
    

    @objc func keyboardWillShow(sender: NSNotification) {
        
        self.typeTFTopConstr.constant = 80
        colorSlider.alpha = 1
        
       

    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.typeTFTopConstr.constant = self.view.frame.height/4
        colorSlider.alpha = 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
  
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
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
            counter.text = String(remainChar)
        }
        if remainChar < 0 {
            counter.text = "😵"
        }

        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainChars()
    }
    
    func setUpColorSlider() {
        
        //colorSlider.frame = CGRect(x: 100, y: 100, width: 200, height: 12)
        view.addSubview(colorSlider)
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        colorSlider.widthAnchor.constraint(equalToConstant: 210 ).isActive = true
        colorSlider.heightAnchor.constraint(equalToConstant: 12).isActive = true
        colorSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        colorSlider.topAnchor.constraint(equalTo: typeTF.bottomAnchor, constant: 15).isActive = true
        
        colorSlider.addTarget(self, action: #selector(changedColor(slider:)), for: .valueChanged)
    }
    
    
    @objc func changedColor(slider: ColorSlider) {
        view.backgroundColor = slider.color
        
        print(slider.color)
    }


    
    @IBAction func saveButton(_ sender: Any) {
        let allowedChar = 50
        let charInTxtView = -typeTF.text.count
        let remainChar = allowedChar + charInTxtView
        if typeTF.text != "" {
            if let msg = typeTF.text {
                if remainChar<0 {
                    let banner = NotificationBanner(title: "Ooops 😵", subtitle: "Message too long", style: .warning)
                    banner.show(bannerPosition: .top)
                }
                else {
                    
                    MsgData.instance.changeMsg(msg: msg)
                    MsgData.instance.changeColor(color: colorSlider.color)
                    dismiss(animated: true)
                }
                
            }
        }
        else {//if empty, set to default
            
            MsgData.instance.changeMsg(msg: "😉")
            dismiss(animated: true)
        }
    }
    func isBlack() {
        let txtColor = UIColor.black
        typeTF.textColor = txtColor
        typeTF.tintColor = txtColor
        MsgData.instance.toggleText(isBlk: true)
    }
    func isWhite() {
        let txtColor = UIColor.white
        typeTF.textColor = txtColor
        typeTF.tintColor = txtColor
        MsgData.instance.toggleText(isBlk: false)//change record in instance
        
    }
    @IBAction func toggle(_ sender: Any) {
        if toggleBut.isOn {
            isWhite()
        }
        else {
            isBlack()
        }
    }
    
   
 
    
    
    

    
    
    
    

}
