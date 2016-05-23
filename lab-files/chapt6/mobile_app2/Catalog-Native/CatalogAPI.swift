import Foundation

enum APIMethod : String {
    case BaseURL = "/"
    case CatalogList = "/api/catalogs"
    case ProductList = "/api/catalog/{catalogID}"
    case ProductDetail = "/api/catalog/{catalogID}/product/{productID}"
}

enum CatalogListResult {
    case Success([Catalog])
    case Failure(NSError)
}

enum ProductListResult {
    case Success([Product])
    case Failure(NSError)
}

enum ProductResult {
    case Success(Product)
    case Failure(NSError)
}



func createError(localizedDescription: String) -> NSError {
    return NSError(domain: "com.bignerdranch.Catalog", code: 0,
        userInfo: [NSLocalizedDescriptionKey: localizedDescription])
}

private let baseURLString = "http://localhost:5000"


class CatalogAPI {
    
    private class func catalogURL(#method: APIMethod, parameters: [String:String]?) -> NSURL? {
        var path = method.rawValue
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                path = path.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
            }
        }
        
        var urlString = baseURLString + path

        return NSURL(string: urlString)
    }
    
    class func catalogListURL() -> NSURL? {
        return catalogURL(method: .CatalogList, parameters: nil)
    }
    
    class func productListURL(#catalog: Catalog) -> NSURL? {
        let parameters = [ "catalogID" : catalog.catalogID ];
        return catalogURL(method: .ProductList, parameters: parameters)
    }
    
    class func productDetailURL(#product: Product) -> NSURL? {
        precondition(product.catalog != nil)
        let parameters = [ "catalogID" : product.catalog!.catalogID, "productID" : product.productID ];
        return catalogURL(method: .ProductDetail, parameters: parameters)
    }

    
    private class func catalogFromJSONObject(json: [String : AnyObject]) -> Catalog? {
        let name = json["name"] as? String
        let catalogID = json["id"] as? String
        
        if name == nil || catalogID == nil {
            return nil
        }
        return Catalog (name: name!, catalogID: catalogID!)
    }
    
    private class func productFromJSONObject(json: [String : AnyObject]) -> Product? {
        let name = json["name"] as? String
        let productID = json["id"] as? String
        let price = json["price"] as? Int
        
        if name == nil || productID == nil || price == nil {
            return nil
        }
        
        let product = Product(catalog: nil, name: name!, productID: productID!, price: price!)
        
        product.blurbs = json["blurbs"] as? [String]
        product.specs = json["specs"] as? [String]

        return product
    }
    
    class func catalogListFromJSONData(data: NSData) -> CatalogListResult {
        var jsonParsingError: NSError?
        
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonParsingError) {
            
            if let catalogsArray = jsonObject["response"] as? [[String : AnyObject]] {
                var finalCatalogs = [Catalog]()
                for catalogJSON in catalogsArray {
                    if let catalog = catalogFromJSONObject(catalogJSON) {
                        finalCatalogs.append(catalog)
                    }
                }
                
                if finalCatalogs.count == 0 && catalogsArray.count > 0 {
                    // Couldn't parse any of the catalogs.  Maybe the JSON payload has changed
                    return .Failure(createError("Could not find catalogs in JSON contents"))
                }
                else {
                    return .Success(finalCatalogs)
                }
            }
            
            // Data isn't nil, and we were able to parase the json, but couldn't find the
            // array of catalogs. Maybe the JSON payload has changed.
            return .Failure(createError("Could not find response in JSON contents"))
        }
        else {
            println("Error parsing JSON: \(jsonParsingError!)")
            return .Failure(jsonParsingError!)
        }
    }
    
    class func productListFromJSONData(data: NSData) -> ProductListResult {
        var jsonParsingError: NSError?
        
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonParsingError) {
            
            if let productsArray = jsonObject["response"] as? [[String : AnyObject]] {
                var finalProducts = [Product]()
                for productJSON in productsArray {
                    if let product = productFromJSONObject(productJSON) {
                        finalProducts.append(product)
                    }
                }
                
                if finalProducts.count == 0 && productsArray.count > 0 {
                    // Couldn't parse any of the products.  Maybe the JSON payload has changed
                    return .Failure(createError("Could not find products in JSON contents"))
                }
                else {
                    return .Success(finalProducts)
                }
            }
            
            // Data isn't nil, and we were able to parase the json, but couldn't find the
            // array of products. Maybe the JSON payload has changed.
            return .Failure(createError("Could not find response in product JSON contents"))
        }
        else {
            println("Error parsing JSON: \(jsonParsingError!)")
            return .Failure(jsonParsingError!)
        }
    }
    
    class func productDetailFromJSONData(data: NSData) -> ProductResult {
        var jsonParsingError: NSError?
        
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonParsingError) {
            
            if let productJSON = jsonObject["response"] as? [String : AnyObject] {
                let product = productFromJSONObject(productJSON)
                
                if product == nil {
                    // Couldn't parse the product.  Maybe the JSON payload has changed
                    return .Failure(createError("Could not find products in JSON contents"))
                }
                else {
                    return .Success(product!)
                }
            }
            
            // Data isn't nil, and we were able to parase the json, but couldn't find the
            // array of products. Maybe the JSON payload has changed.
            return .Failure(createError("Could not find response in product JSON contents"))
        }
        else {
            println("Error parsing JSON: \(jsonParsingError!)")
            return .Failure(jsonParsingError!)
        }
    }

    
}
