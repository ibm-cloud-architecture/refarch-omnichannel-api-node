import Foundation

class CatalogStore {
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()

    func fetchCatalogList(completion: (CatalogListResult) -> Void) {
        if let url = CatalogAPI.catalogListURL() {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                var result: CatalogListResult
                if let jsonData = data {
                    result = CatalogAPI.catalogListFromJSONData(jsonData)
                }
                else if let requestError = error {
                    println("Error fetching recent catalogs: \(requestError)")
                    result = .Failure(error)
                }
                else {
                    println("Unexpected error with the catalogs request")
                    result = .Failure(createError("Unexpected request response"))
                }
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(result)
                }
            }
            task.resume()
        }
        else {
            // Error generating the URL
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(.Failure(createError("Error generating URL")))
            }
        }
    }
    
    func fetchProductList(catalog: Catalog, completion: (ProductListResult) -> Void) {
        if let url = CatalogAPI.productListURL(catalog: catalog) {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                var result: ProductListResult
                if let jsonData = data {
                    result = CatalogAPI.productListFromJSONData(jsonData)
                    switch result {
                    case let .Success(products):
                        // set the back-reference to the catalog.
                        products.map { $0.catalog = catalog }
                        catalog.products = products
                    default:
                        break
                    }
                }
                else if let requestError = error {
                    println("Error fetching recent products: \(requestError)")
                    result = .Failure(error)
                }
                else {
                    println("Unexpected error with the products request")
                    result = .Failure(createError("Unexpected request response"))
                }
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(result)
                }
            }
            task.resume()
        }
        else {
            // Error generating the URL
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(.Failure(createError("Error generating URL")))
            }
        }
    }

    func fetchProductDetail(product: Product, completion: (ProductResult) -> Void) {
        if let url = CatalogAPI.productDetailURL(product: product) {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                var result: ProductResult
                if let jsonData = data {
                    result = CatalogAPI.productDetailFromJSONData(jsonData)
                    switch result {
                    case let .Success(newProduct):
                        product.blurbs = newProduct.blurbs
                        product.specs = newProduct.specs
                        result = .Success(product)  // we mutated the existing product, so send that along
                    default:
                        break
                    }
                }
                else if let requestError = error {
                    println("Error fetching recent product: \(requestError)")
                    result = .Failure(error)
                }
                else {
                    println("Unexpected error with the product request")
                    result = .Failure(createError("Unexpected request response"))
                }
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(result)
                }
            }
            task.resume()
        }
        else {
            // Error generating the URL
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(.Failure(createError("Error generating URL")))
            }
        }
    }

}
