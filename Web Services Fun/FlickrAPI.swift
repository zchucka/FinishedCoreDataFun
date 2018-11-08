//
//  FlickrAPI.swift
//  Web Services Fun
//
//  Created by Chucka, Zachary Tyler on 11/8/18.
//  Copyright © 2018 Chucka, Zachary Tyler. All rights reserved.
//

import Foundation

struct FlickrAPI {
    // it is bad practice to put an APIkey in your code
    // typically you would put it in an encypted file, or in keychain services, or even in your Info.plist (add info.plist .gitignore file)
    // i will delete the apiKey before the final push. I have the picture of it
    static let apiKey = 
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
    
    // lets define a function to make a request using the url we
    static func fetchInterestingPhotos() {
        let url = FlickrAPI.flickURL()
        // now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // closure executes when this task gets a response back from the server
            // see if we got data
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            else {
                if let error = error {
                    print("Error getting photos JSON response \(error)")
                }
            }
        }
        // by default, when you create a task, it starts in the suspended state
        // call resume to start it
        task.resume()
    }
    
}
