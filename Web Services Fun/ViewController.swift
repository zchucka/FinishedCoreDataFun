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
    var interestingPhotos = [InterestingPhoto]()
    var location = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlickrAPI.fetchInterestingPhotos(completion: { (photosOptional) in
            if let interestingPhotosArray = photosOptional {
                print("we got it boys")
                self.interestingPhotos = interestingPhotosArray
                self.updateUI()
                // this closure is running on a background thread
                // to do: call on main ui thread
                // task: add properties for the [InterestingPhoto] and a current photo index
                // define an updateUI method that updates the labels for title and datetaken
                // call updateUI here and when they press next photo
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonIsPressed(_ sender: UIButton) {
        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = interestingPhotos[location].title
        
        FlickrAPI.fetchImage(fromURLString: interestingPhotos[location].photoURL) { (imageOptional) in
            if let images = imageOptional {
                self.image.image = images
            }
        }
        location += 1
        location %= interestingPhotos.count
    }
}

