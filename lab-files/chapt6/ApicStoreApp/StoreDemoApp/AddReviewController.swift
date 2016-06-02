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
        //self.navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.userInteractionEnabled = true
        comment.layer.borderColor = UIColor.lightGrayColor().CGColor
        comment.layer.borderWidth = 1.0
        comment.layer.cornerRadius = 5.0
        comment.delegate = self
        print(itemId)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
       textView.text = ""
    }
}
