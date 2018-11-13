//
//  InterestingPhoto.swift
//  Web Services Fun
//
//  Created by Chucka, Zachary Tyler on 11/8/18.
//  Copyright © 2018 Chucka, Zachary Tyler. All rights reserved.
//

import Foundation

struct InterestingPhoto {
    // a struct to store photo information received from Flickr
    var id: String
    var title: String
    // var dateTaken: String
    var photoURL: String
    
    init(id: String, title: String, dateTaken: String, photoURL: String) {
        self.id = id
        self.title = title
        // self.dateTaken = dateTaken
        self.photoURL = photoURL
    }
}
