// 
// Copyright (c) 2015 Big Nerd Ranch
//

import Foundation
import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {

    let photos: [Photo]

    init(photos: [Photo] = [Photo]()) {
        self.photos = photos
        super.init()
    }

    func collectionView(collectionView: UICollectionView,
            numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let identifier = "UICollectionViewCell"
        let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
                forIndexPath: indexPath) as! PhotoCollectionViewCell

        let photo = photos[indexPath.row]
        cell.updateWithImage(photo.image)

        return cell
    }
}
