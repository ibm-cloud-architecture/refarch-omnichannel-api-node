// 
// Copyright (c) 2015 Big Nerd Ranch
//

import UIKit

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoID == rhs.photoID
}

class Photo {

    let title: String
    let URL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?

    init(title: String, photoID: String, URL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.URL = URL
        self.dateTaken = dateTaken
    }
}
