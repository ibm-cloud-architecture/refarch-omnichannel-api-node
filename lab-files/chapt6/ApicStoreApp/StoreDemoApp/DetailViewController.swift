//
//  DetailViewController.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var itemImageDetail: UIImageView!
    @IBOutlet var itemName: UILabel!
    
    @IBOutlet var itemPrice: UILabel!
    
    @IBOutlet var itemDescription: UITextView!
    
    @IBAction func addReviews(sender: AnyObject) {
    }
    
    @IBOutlet var reviewTable: UITableView!
    
    var item: Item!
   // var item: Item = Item(name: "Dayton Meat Chopper", desc: "Punched-card tabulating machines and time clocks were not the only products offered by the young IBM. Seen here in 1930, manufacturing employees of IBM's Dayton Scale Company are assembling Dayton Safety Electric Meat Choppers. These devices, which won the Gold Medal at the 1926 Sesquicentennial International Exposition in Philadelphia, were produced in both counter base and pedestal styles (5000 and 6000 series, respectively). They included one-quarter horsepower models, one-third horsepower machines (Styles 5113, 6113F and 6213F), one-half horsepower types (Styles 5117, 6117F and 6217F) and one horsepower choppers (Styles 5128, 6128F and 6228F). Prices in 1926 varied from $180 to $375. Three years after this photograph was taken, the Dayton Scale Company became an IBM division, and was sold to the Hobart Manufacturing Company in 1934.", altImage: "Dayton Meat Chopper", price: 4599, rating: 0, id: 1, image: "meat-chopper")
    
    var reviewList: [Review] = [
        Review(itemID: 12401, itemRating: 4, comments: "Nice Product Easy to Use, Bad Packing", email: "cptchouk@us.ibm.com", name: "Chris Tchoukaleff", id: 1),
        Review(itemID: 12401, itemRating: 3, comments: "Product decent but not great", email: "gangchen@us.ibm.com", name: "Gang Chen", id: 2)
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        itemName.text = self.item.name
        itemPrice.text = "$\(self.item.price)"
        itemDescription.text = self.item.desc
        itemImageDetail.image = UIImage(named: self.item.image)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTable.delegate = self
        reviewTable.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If triggered segue is show item
        
        if segue.identifier == "ShowReview" {
            //figure which row was tapped

                let addReviewController = segue.destinationViewController as! AddReviewController
                addReviewController.review.itemID = item.id
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell",forIndexPath: indexPath) as! ReviewCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let review =  reviewList[indexPath.row]
        
        // Configure the cell with the Item
       cell.name.text = review.name
        //cell.rating.text = "\(review.itemRating)"
        
        cell.rating.rating = Double(review.itemRating) 
        cell.comments.text = review.comments
       // cell.priceLabel.text = "$\(item.price)"
       // cell.itemImage.image = UIImage(named: item.image)
        
        
        //cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.price)"
        return cell
        
    }
    
    
}
