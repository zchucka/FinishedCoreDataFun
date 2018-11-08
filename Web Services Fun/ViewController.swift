//
//  ViewController.swift
//  Web Services Fun
//
//  Created by Chucka, Zachary Tyler on 11/8/18.
//  Copyright © 2018 Chucka, Zachary Tyler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /*
     we are building an app that will fetch interesting photos from the Flickr interesting rest API
     we will construct a URL according to the Flickr API docs
     we will use URLSessionDataTask to send the request for data and get a Data object back
     our goal is to parse JSON data that is in the Data object to create an array of interesting photos
     we will define the interesting photo type
     id, title, dateTaken, photoURL
     we will define two types
     FlickrAPI which will have a bunch of static properties and methods for our API to work with the FlickrAPI
     */
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlickrAPI.fetchInterestingPhotos()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

