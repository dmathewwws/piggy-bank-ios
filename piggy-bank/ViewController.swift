//
//  ViewController.swift
//  piggy-bank
//
//  Created by Daniel Mathews on 2014-12-03.
//  Copyright (c) 2014 com.red-cedar. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var phoneUtil:NBPhoneNumberUtil = NBPhoneNumberUtil.sharedInstance()
    var phoneTypeFormatter:NBAsYouTypeFormatter = NBAsYouTypeFormatter(regionCode: "CA")
    //var userDict = Dictionary<NSObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTF.delegate = self
        phoneNumberTF.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSMSController(sender: AnyObject) {
        
        if(MFMessageComposeViewController.canSendText()){
            verifyLabel.text = ""
            
            let deviceID = UIDevice().identifierForVendor.UUIDString
            let verificationCode = getNewVerificationCode()
            let
            
            let sendSMSController = MFMessageComposeViewController()
            
            sendSMSController.body = "With verification code: \(verificationCode)"
            sendSMSController.recipients = ["1-604-337-1167"]
            sendSMSController.messageComposeDelegate = self
            
            self.presentViewController(sendSMSController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch result.value{
            case MessageComposeResultCancelled.value, MessageComposeResultFailed.value:
                self.dismissViewControllerAnimated(true, completion: {
                    
                    self.verifyLabel.text = "Sorry! The text message could not be sent. Please try again at a later time."
                    
//                    let alertController = UIAlertController(title: "Sorry!", message: "The text message could not be sent. Please try again at a later time.", preferredStyle: .Alert)
//                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            case MessageComposeResultSent.value:
                
                println(result)
                
                self.dismissViewControllerAnimated(true, completion: {
                    let successViewController = UIStoryboard(name: "MainApp", bundle:NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SMSSuccesViewController") as SMSSuccesViewController
                    self.presentViewController(successViewController, animated: true, completion: nil)
                })
            default:
                break
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var error: NSError?
        
        if string != ""{
            if let myNumber:NBPhoneNumber = phoneUtil.parse(textField.text+string, defaultRegion: "CA", error: &error){
               
                if phoneUtil.isValidNumberForRegion(myNumber, regionCode: "CA"){
                    println("\(textField.text)+\(string) is valid")
                    nextButton.enabled=true
                }else{
                    println("\(textField.text)+\(string) is invalid")
                    nextButton.enabled=false
                }
            }
        }else{
            var countTextField = countElements(textField.text)
            if let myNumber:NBPhoneNumber = phoneUtil.parse(textField.text[0..<(countTextField-1)], defaultRegion: "CA", error: &error){
                
                if phoneUtil.isValidNumberForRegion(myNumber, regionCode: "CA"){
                    println("\(myNumber.nationalNumber) is valid")
                    nextButton.enabled=true
                }else{
                    println("\(myNumber.nationalNumber) is valid")
                    nextButton.enabled=false
                }
            
            }else{
                nextButton.enabled = false
            }
        }
        
        /*if (error == nil){
            println("\(textField.text) is \(phoneUtil.isValidNumber(myNumber))")
        }*/
        
        
//        var phoneStr = textField.text as NSString
//        
//        if (string != ""){
//            phoneStr = phoneStr.stringByReplacingCharactersInRange(range, withString: "")
//            textField.text = phoneTypeFormatter.inputDigit(string)
//
//        }else{
//            textField.text = phoneTypeFormatter.removeLastDigit()
//        }
//        

        
        
        
//        var phoneStr = textField.text as NSString
//        phoneStr = phoneStr.stringByReplacingCharactersInRange(range, withString: "")
//        println("Text in  shouldChangeCharactersInRange is \(phoneStr)")
        
        return true
    }

}

func getNewVerificationCode() -> String{
    
    return NSUUID().UUIDString
}


extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
}

