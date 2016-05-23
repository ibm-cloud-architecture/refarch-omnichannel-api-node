import UIKit

class ProductDetailViewController : UIViewController {
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var blurbTextView: UITextView!
    @IBOutlet weak var specsTextView: UITextView!
    
    var store: CatalogStore!
    var product: Product!


    private func updateUI() {
        materialLabel.text = product?.name
        let price = Double(product?.price ?? 0) / 100.0
        priceLabel.text = "\(price)"

        if let blurbs = product?.blurbs {
            blurbTextView.text = ("\n".join(blurbs.map({ String($0) })))
        } else {
            blurbTextView.text = ""
        }

        if let specs = product?.specs {
            specsTextView.text = ("\n".join(specs.map({ String($0) })))
        } else {
            specsTextView.text = ""
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        store.fetchProductDetail(product) {
            (productResult) -> Void in
            
            switch productResult {
            case let .Success(product):
                self.updateUI()
            case let .Failure(error):
                println("Error fetching products: \(error)")
            }
        }
    }

}