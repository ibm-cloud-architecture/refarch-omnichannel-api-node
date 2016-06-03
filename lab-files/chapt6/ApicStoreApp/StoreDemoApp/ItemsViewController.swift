//
//  ItemsViewController.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
     var http: Http!
    //var overlayView: UIView?
    
    
    // Mockup data, this data will be returned by api
    /*var storeItems: [Item] = [
        Item(name: "Dayton Meat Chopper", desc: "Punched-card tabulating machines and time clocks were not the only products offered by the young IBM. Seen here in 1930, manufacturing employees of IBM's Dayton Scale Company are assembling Dayton Safety Electric Meat Choppers. These devices, which won the Gold Medal at the 1926 Sesquicentennial International Exposition in Philadelphia, were produced in both counter base and pedestal styles (5000 and 6000 series, respectively). They included one-quarter horsepower models, one-third horsepower machines (Styles 5113, 6113F and 6213F), one-half horsepower types (Styles 5117, 6117F and 6217F) and one horsepower choppers (Styles 5128, 6128F and 6228F). Prices in 1926 varied from $180 to $375. Three years after this photograph was taken, the Dayton Scale Company became an IBM division, and was sold to the Hobart Manufacturing Company in 1934.", altImage: "Dayton Meat Chopper", price: 4599, rating: 0, id: 1, image: "meat-chopper"),
        
        Item(name: "Hollerith Tabulator", desc: "This equipment is representative of the tabulating system invented and built for the U.S. Census Bureau by Herman Hollerith (1860-1929). After observing a train conductor punching railroad tickets to identify passengers, Hollerith conceived and developed the idea of using punched holes to record facts about people. These machines were first used in compiling the 1890 Census. Hollerith's patents were later acquired by the Computing-Tabulating-Recording Co. (which was renamed IBM in 1924) and this work became the basis of the IBM Punched Card System. Hollerith's tabulator used simple clock-like counting devices. When an electrical circuit was closed (through a punched hole in a predetermined position on the card), each counter was actuated by an electromagnet. The unit's pointer (clock hand) moved one step each time the magnet was energized. The circuits to the electromagnets were closed by means of a hand-operated press type card reader. The operator placed each card in the reader, pulled down the lever and removed the card after each punched hole was counted.", altImage: "Hollerith Tabulator", price: 10599, rating: 0, id: 2, image: "hollerith-tabulator"),
        
        Item(name: "Computing Scale", desc: "In 1885 Julius Pitrat of Gallipolis, Ohio, patented the first computing scale. Six years later, Edward Canby and Orange Ozias of Dayton, Ohio, purchased Pitrat's patents and incorporated The Computing Scale Company as the world's first computing scale vendor. And four years after that, The Computing Scale Company introduced the first automatic computing scale, shown here. In 1911, the Computing Scale Company merged with the International Time Recording Company and Tabulating Machine Company to form the Computing-Tabulating-Recording Company, a business that was renamed IBM in 1924.", altImage: "Computing Scale", price: 699, rating: 0, id: 3, image: "computing-scale")
        
    ] */
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
        //let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",forIndexPath: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item =  storeItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.priceLabel.text = "$\(item.price)"
        
        // Used for Local mockup
        //cell.itemImage.image = UIImage(named: item.image)
        let url = NSURL(string: item.image)
        let data = NSData(contentsOfURL: url!)
        cell.itemImage.image = UIImage(data: data!)

        
        //cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.price)"
        return cell
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        //let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let userDefaults = appDelegate.userDefaults as? NSUserDefaults
        
        var itemRestUrl: String = appDelegate.userDefaults.objectForKey("itemRestUrl") as! String
        itemRestUrl += "/api/items"
        print("Item REST endpoint is : \(itemRestUrl)")
        //Set up REST framework
        self.http = Http()
        self.listInventory(itemRestUrl, parameters: nil)
        
        //self.listInventory("https://api.us.apiconnect.ibmcloud.com/gangchenusibmcom-dev/inventory-catalog/api/items/1", parameters: nil)
        
        //Set Response to Table Store
        
        
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
                //print("Successfully invoked! \(response)")
                
                do {
                    
                    
                    let resArry = response as! NSArray
                    //let descrip: String = resArry![0].objectForKey("description") as! String
                    for respItem in resArry {
                        
                        let newItem = Item(name: respItem.objectForKey("name") as! String, desc: respItem.objectForKey("description") as! String, altImage: respItem.objectForKey("img") as? String, price: respItem.objectForKey("price") as! Int, rating: respItem.objectForKey("rating") as! Int, id: respItem.objectForKey("id") as! Int, image: respItem.objectForKey("img") as! String)
                        self.storeItems.append(newItem)
                        //print(newItem)
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
