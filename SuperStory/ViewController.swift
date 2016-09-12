//
//  ViewController.swift
//  SuperStory
//
//  Created by Faraz Fazli on 9/8/16.
//  Copyright © 2016 Faraz Fazli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    enum TextError: ErrorType {
        case NoName
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    var originalHeight: CGFloat = 0
    var height: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        self.nameTextField.delegate = self
        self.originalHeight = textFieldBottomConstraint.constant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw TextError.NoName
                    }
                if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.story(name)
                    }
                }
            } catch TextError.NoName {
                let alertController = UIAlertController(title: "Name not provided", message: "Provide a name to start your story!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                presentViewController(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDictionary = notification.userInfo, keyboardValue = userInfoDictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
                self.height = keyboardFrame.height / 1.2
                self.textFieldBottomConstraint.constant = self.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.8) {
        self.textFieldBottomConstraint.constant = self.originalHeight
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
        return false
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
}