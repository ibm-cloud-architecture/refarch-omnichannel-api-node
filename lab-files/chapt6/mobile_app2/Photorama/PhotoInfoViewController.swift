// 
// Copyright (c) 2015 Big Nerd Ranch
//

import Foundation
import UIKit

class PhotoInfoViewController: UIViewController {

    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImageForPhoto(photo, completion: { (result) -> Void in
            switch result {
            case let .Success(image):
                self.imageView.image = image
            case let .Failure(error):
                println("Error fetching image for photo: \(error)")
            }
        })
    }
}
