//
//  ReviewViewController.swift
//  BarBarGo
//
//  Created by Desmond Boey on 8/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class ReviewViewController: UIViewController{
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationHelper.notification.addObserver(self, selector: Selector("updateTextView"), name: NotificationHelper.ntfnBroadcast, object: nil)

        
        self.preferredContentSize = CGSizeMake(self.view.frame.width, (self.view.frame.height)*0.6)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ReviewViewController.dismiss(_:)))
    }
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func updateTextView(notification: NSNotification){
        
        if let review = notification.object as? [String:AnyObject]{
            if let text = review["userReview"] as? String{
                textView.text = text
            }
        }
    }
}