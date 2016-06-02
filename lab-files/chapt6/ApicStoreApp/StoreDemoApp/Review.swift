//
//  Review.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class Review:NSObject {
    var itemID: Int
    var itemRating: Int
    var comments: String
    var email: String
    var name: String
    var id: Int
    
    init (itemID: Int, itemRating: Int, comments: String, email: String, name: String, id: Int) {
        self.itemID = itemID
        self.itemRating = itemRating
        self.comments = comments
        self.email = email
        self.name = name
        self.id = id
        
        super.init()
    }
}