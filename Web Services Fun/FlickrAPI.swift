//
//  FlickrAPI.swift
//  Web Services Fun
//
//  Created by Chucka, Zachary Tyler on 11/8/18.
//  Copyright © 2018 Chucka, Zachary Tyler. All rights reserved.
//

import Foundation
import UIKit

struct FlickrAPI {
    // it is bad practice to put an APIkey in your code
    // typically you would put it in an encypted file, or in keychain services, or even in your Info.plist (add info.plist .gitignore file)
    // i will delete the apiKey before the final push. I have the picture of it
    static let apiKey = "1e62fea963ae2caf0854ae1be8fee7fd"
    static let baseURL = "https://api.flickr.com/services/rest"
    
    // the first thing we wanna do is construct our flickr.interestingness.getlist url request for data
    static func flickURL() -> URL {
        // first lets define our query parameters
        let params = [
            "method": "flickr.interestingness.getList",
            "api_key": FlickrAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1", // ask for raw json
            "extras": "data_taken,url_h" // url_h is for a 1600px image url for the photo
        ]
        // now we need to get these params into a url with the base url
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: FlickrAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
    }
    
    // lets define a function to make a request using the url we just constructed
    // @esaping lets the compiler know the closure paramter will execute after this method returns
    static func fetchInterestingPhotos(completion: @escaping ([InterestingPhoto]?) -> Void) {
        let url = FlickrAPI.flickURL()
        // now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // closure executes when this task gets a response back from the server
            // see if we got data
            if let data = data, let dataString = String(data: data, encoding: .utf8), let interestingPhotos = interestingPhotos(fromData: data) {
                print(dataString)
                print("successfully got an [InterstingPhotos] array")
                // MARK: - Threads
                // so far our code in ViewController for example runs on the main UI thread
                // the main UI thread listens for user interaction, calls callbacks in view controllers and in delegates
                // long running tasks/code should not run on the main UI thread, why?
                // we don't want the UI thread to wait for long running code because it will become unresponsive
                // by default, URLSession dataTasks run on a background thread
                // this code right here is not running on the main UI thread
                // this closure runs asynchronously
                // viewDidLoad() doesn't wait for this closure to return a value
                // we can't return the [InterestingPhotos] array from fetchInterestingPhotos() because it will have already returned
                // we need a completion closure to execute later when we have a result
                DispatchQueue.main.async {
                    completion(interestingPhotos)
                }
                // should also call completion on failure
            } else {
                if let error = error {
                    print("Error getting photos JSON response \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        // by default, when you create a task, it starts in the suspended state
        // call resume to start it
        task.resume()
        
    }
    
    static func interestingPhotos(fromData: Data) -> [InterestingPhoto]? {
        // returns nil if we fail to parse the json in data
        // MARK: - JSON: javascript object notation
        // JSON is commonly used to pass around data on the web
        // JSON is really just a dictionary
        // keys are strings
        // values are strings, nested JSON objects, arrays, numerics, bools, etc
        // our goal is to convert the Data object into a [String: Any]
        // swiftyJSON makes this process much simplier
        var interestingArray = [InterestingPhoto]()
        
        do {
            let JSONObject = try JSONSerialization.jsonObject(with: fromData, options: [])
            // using json response to get the data we want
            guard let jsonDictionary = JSONObject as? [String: Any], let photoObject = jsonDictionary["photos"] as? [String: Any], let photoArray = photoObject["photo"] as? [[String: Any]] else {
                print("error json stuff")
                return nil
            }
            // we have photoArray
            // we can iterate through it
            for photoJSON in photoArray {
                // goal is to try and get an interesting photo for each photo JSON
                // call interesting photo from json and if it is not nil, put it in an array of photos
                if let coolPhoto = interestingPhoto(fromJson: photoJSON)
                {
                    interestingArray.append(coolPhoto)
                }
            }
            if !interestingArray.isEmpty {
                return interestingArray
            }
        } catch {
            print("error getting a JSON object \(error)")
        }
        return nil
    }
    
    static func interestingPhoto(fromJson json: [String: Any]) -> InterestingPhoto? {
        // return nil if parsing fails
        guard let id = json["id"] as? String else {
            print("error parsing method")
            return nil
        }
        guard let title = json["title"] as? String else {
            print("error parsing method")
            return nil
        }
        //guard let dateTaken = json["dateTaken"] as? String else {
           // print("error parsing method")
            //return nil
        //}
        guard let url = json["url_h"] as? String else {
            print("error")
            return nil
        }
        
        let photo = InterestingPhoto(id: id, title: title, dateTaken: "", photoURL: url)
        return photo
    }
    
    static func fetchImage(fromURLString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: fromURLString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                print("successfully got a UIImage")
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                if let error = error {
                    print("Error getting an image \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
