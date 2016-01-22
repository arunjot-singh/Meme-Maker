//
//  ViewController.swift
//  Meme Maker
//
//  Created by Arunjot Singh on 1/11/16.
//  Copyright © 2016 Arunjot Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var ShareButton: UIBarButtonItem!
   
    
    var keyboardHeight: CGFloat = 0
    let memeTextAttributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(),
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
    NSStrokeWidthAttributeName: -4
    ]

  
   
    override func viewWillAppear(animated: Bool) {
        CameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        NotificationsOn()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NotificationsOff()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextfield.text = "Tap to make your Meme"
        bottomTextfield.text = "Tap to make your Meme"
        
        memeTextFieldLayout(topTextfield)
        memeTextFieldLayout(bottomTextfield)
        self.topTextfield.hidden = true
        self.bottomTextfield.hidden = true
        self.topTextfield.delegate = self
        self.bottomTextfield.delegate = self
        self.topToolbar.hidden = true
        self.ShareButton.enabled = false
        
    }
    
    func memeTextFieldLayout(textField: UITextField) {
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.Center
        textField.defaultTextAttributes = memeTextAttributes
    }


    @IBAction func PickImageFromAlbum(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
       
    }
    
    @IBAction func PickImageFromCamera(sender: UIBarButtonItem){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
     
    }
    
    @IBAction func Share(sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [MemeImage()], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if( activity == UIActivityTypeSaveToCameraRoll && success) {
                
                let alertController = UIAlertController(title: "Success", message: "Meme Saved", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })

                
              }
        }
    }
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = false
        self.topTextfield.hidden = true
        self.bottomTextfield.hidden = true
        self.topTextfield.text = ""
        self.bottomTextfield.text = ""
        self.ImagePickerView.image = nil
        self.Label.hidden = false
       
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.image = image
            self.Label.hidden = true
            self.topTextfield.hidden = false
            self.bottomTextfield.hidden = false
            self.topToolbar.hidden = false
            self.bottomToolbar.hidden = true
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Tap to make your Meme" || textField.text == "Tap to make your Meme" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.ShareButton.enabled = true
    }
    
    
    
    func MemeImage() -> UIImage {
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let meme : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
    
        return meme
    }
    
    
        func keyboardOn(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() {
            let kbSize: CGFloat = getKeyboardHeight(notification)
            let deltaHeight: CGFloat = kbSize - keyboardHeight
            view.frame.origin.y -= deltaHeight
            keyboardHeight = kbSize
        }
    }
    
    func keyboardOff(notification: NSNotification) {
        keyboardHeight = 0
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue 
        return keyboardSize.CGRectValue().height
    }
    
    
    func NotificationsOn() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardOn:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardOff:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func NotificationsOff() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
}

