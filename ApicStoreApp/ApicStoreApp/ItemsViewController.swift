//
//  ItemsViewController.swift
//  StoreDemoApp
//
//  Created by Gang Chen on 6/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
     var http: Http!
    
    var storeItems: [Item] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If triggered segue is show item
        
        if segue.identifier == "ShowItem" {
            //figure which row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get item associated with this row and pass it along
                
                let item = storeItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                
                let appDelegate : AppDelegate = AppDelegate().sharedInstance()
                appDelegate.userDefaults.setObject(item.id, forKey: "currentItemId")

            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",forIndexPath: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item, where n = row this cell
        // will appear in on the tableview
        let item =  storeItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.priceLabel.text = "$\(item.price)"
        
        // Used for Local mockup
        let url = NSURL(string: item.image)
        let data = NSData(contentsOfURL: url!)
        cell.itemImage.image = UIImage(data: data!)

        return cell
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        var itemRestUrl: String = appDelegate.userDefaults.objectForKey("itemRestUrl") as! String
        itemRestUrl += "/api/items"
        print("Item REST endpoint is : \(itemRestUrl)")
        
        
        //Set up REST framework
        self.http = Http()
        self.listInventory(itemRestUrl, parameters: nil)
        
        // Set Response to Table Store
        // Get the height of the status bar
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
    
    }
    
    func listInventory(url: String, parameters: [String: AnyObject]?) {
        print("calling listInventory")
        
        self.http.request(.GET, path: url, parameters: parameters, completionHandler: {(response, error) in
            // handle response
            if (error != nil) {
                print("Error \(error!.localizedDescription)")
            } else {
                
                do {
                    
                    
                    let resArry = response as! NSArray
                    for respItem in resArry {
                        
                        let newItem = Item(name: respItem.objectForKey("name") as! String, desc: respItem.objectForKey("description") as! String, altImage: respItem.objectForKey("img") as? String, price: respItem.objectForKey("price") as! Int, rating: respItem.objectForKey("rating") as! Int, id: respItem.objectForKey("id") as! Int, image: respItem.objectForKey("img") as! String)
                        self.storeItems.append(newItem)
                        self.tableView.reloadData()
                    }
                    
                }
                catch {
                    print(error)
                }
                
            }
        })
    }

    
}
