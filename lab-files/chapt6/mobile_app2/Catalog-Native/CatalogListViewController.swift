
import UIKit

class CatalogListViewController: UIViewController, UITableViewDataSource {
    var store: CatalogStore!

    @IBOutlet weak var tableView: UITableView!
    var catalogs: [Catalog]?
    
    private func fetchCatalogs() {
        store.fetchCatalogList() {
            (catalogListResult) -> Void in
            
            switch catalogListResult {
            case let .Success(catalogs):
                println("Successfully found \(catalogs.count) catalogs")
                self.catalogs = catalogs
            case let .Failure(error):
                println("Error fetching catalogs: \(error)")
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if catalogs == nil {
            fetchCatalogs()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCatalog" {
            let indexPath = tableView.indexPathForSelectedRow()
            if indexPath == nil {
                println("unexpected lack of selected row index path")
                return
            }
            
            let catalogVC = segue.destinationViewController as! CatalogViewController
            catalogVC.store = store
            catalogVC.catalog = catalogs?[indexPath!.row]
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogs?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "Catalog number \(indexPath.row)"
        let catalog = catalogs![indexPath.row]
        cell.textLabel?.text = catalog.name

        return cell
    }
    
}
