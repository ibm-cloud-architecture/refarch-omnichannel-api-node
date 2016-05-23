import UIKit

class CatalogViewController : UIViewController, UITableViewDataSource {

    var store: CatalogStore!
     var catalog: Catalog? {
        didSet(oldValue) {
            title = catalog?.name ?? "Catalog"
        }
    }
    @IBOutlet weak var tableView: UITableView!

    var products: [Product]?
    
    private func fetchProducts() {
        store.fetchProductList(catalog!) {
            (productResult) -> Void in
            
            switch productResult {
            case let .Success(products):
                println("Successfully found \(products.count) products")
                self.products = products
            case let .Failure(error):
                println("Error fetching products: \(error)")
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if catalog != nil && products == nil {
            fetchProducts()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProductDetail" {
            let indexPath = tableView.indexPathForSelectedRow()
            if indexPath == nil {
                println("unexpected lack of selected row index path")
                return
            }
            
            let detailVC = segue.destinationViewController as! ProductDetailViewController
            detailVC.store = store
            detailVC.product = products?[indexPath!.row]
        }
    }



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let product = catalog?.products?[indexPath.row]
        cell.textLabel?.text = product?.name

        return cell
    }

}