//
//  ViewController.swift
//  piggy-bank
//
//  Created by Daniel Mathews on 2014-12-03.
//  Copyright (c) 2014 com.red-cedar. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var verifyLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSMS(sender: AnyObject) {
        
        if(MFMessageComposeViewController.canSendText()){
            
            verifyLabel.text = ""
            
            let sendSMSController = MFMessageComposeViewController()
            
            sendSMSController.body = "With verification code: XXXX-YYYY-ZZZZ"
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


}

