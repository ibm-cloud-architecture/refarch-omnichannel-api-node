import Foundation

class Catalog {
    let name: String
    let catalogID: String
    var products: [Product]?

    init(name: String, catalogID: String) {
        self.name = name
        self.catalogID = catalogID
    }
}
