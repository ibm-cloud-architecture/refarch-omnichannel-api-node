//
//  AddReviewController.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class AddReviewController: UIViewController, UITextViewDelegate {
    
    var review:Review = Review()
    var itemId:Int = 0
    
    var http: Http!
    
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var reviewerName: UITextField!
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
    
    @IBAction func addReview(sender: AnyObject) {
        
        print("Ready to submit review comment")
        self.review.comments = comment.text
        self.review.itemRating = Int(rating.rating)
        self.review.itemID = itemId
        self.review.name = reviewerName!.text!
        
        print("review object \(self.review.itemRating) with name: \(self.review.name) with comment: \(self.review.comments)")
     
        //Prepare REST call to APIC
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        //let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let userDefaults = appDelegate.userDefaults as? NSUserDefaults
        
        var reviewRestUrl: String = appDelegate.userDefaults.objectForKey("reviewRestUrl") as! String
        reviewRestUrl += "/api/reviews"
        print("Review REST endpoint is : \(reviewRestUrl)")
        
        //Define Parameters
        let reviewParams = ["comment":self.review.comments,  "itemId":self.review.itemID, "rating":self.review.itemRating, "review_date":"06/06/2016", "reviewer_email":"gchen@ibm.com", "reviewer_name":self.review.name]
        
        self.postReviews(reviewRestUrl, parameters: reviewParams as? [String : AnyObject])
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.userInteractionEnabled = true
        comment.layer.borderColor = UIColor.lightGrayColor().CGColor
        comment.layer.borderWidth = 1.0
        comment.layer.cornerRadius = 5.0
        comment.delegate = self
        
        
        //Set up REST framework
        self.http = Http()
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
       textView.text = ""
    }
    
    func postReviews(url: String, parameters: [String: AnyObject]?) {
        print("calling listReviews")
        self.http.request(.POST, path: url, parameters: parameters, completionHandler: {(response, error) in
            // handle response
            if (error != nil) {
                print("Error \(error!.localizedDescription)")
            } else {
                print("Successfully invoked! \(response)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
}
