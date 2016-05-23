// 
// Copyright (c) 2015 Big Nerd Ranch
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([Photo])
    case Failure(NSError)
}

private let baseURLString = "https://api.flickr.com/services/rest"
private let APIKey = "a6d819499131071f158fd740860a5a88"

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
    }()

func createError(localizedDescription: String) -> NSError {
    return NSError(domain: "com.bignerdranch.photorama",
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: localizedDescription])
}

class FlickrAPI {
    class func recentPhotosURL() -> NSURL? {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }

    class func photosFromJSONData(data: NSData) -> PhotosResult {

        var jsonParsingError: NSError?
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data,
                options: nil,
                error: &jsonParsingError) {

            if let photos = jsonObject["photos"] as? [String : AnyObject] {
                if let photosArray = photos["photo"] as? [[String : AnyObject]] {

                    var finalPhotos = [Photo]()
                    for photoJSON in photosArray {
                        println("Photo: \(photoJSON)")
                        if let photo = photoFromJSONObject(photoJSON) {
                            finalPhotos.append(photo)
                        }
                    }

                    if finalPhotos.count == 0 && photosArray.count > 0 {
                        // We weren't able to parse any of the photos.
                        // Maybe the JSON format for photos has changed.
                        return .Failure(createError("Unexpected photo JSON contents"))
                    }
                    return .Success(finalPhotos)
                }
            }

            // Data isn't nil, and we were able to parse the json, but we weren't
            // able to find the array of photos. Maybe the JSON format has changed.
            return .Failure(createError("Unexpected JSON contents"))
        }
        else {
            println("Error parsing JSON: \(jsonParsingError!)")
            return .Failure(jsonParsingError!)
        }
    }

    private class func photoFromJSONObject(json: [String : AnyObject]) -> Photo? {
        var photoID = json["id"] as? String
        var title = json["title"] as? String
        var url: NSURL?

        if let photoURLString = json["url_h"] as? String {
            url = NSURL(string: photoURLString)
        }

        var dateTaken: NSDate?
        if let dateString = json["datetaken"] as? String {
            dateTaken = dateFormatter.dateFromString(dateString)
        }

        // If any of the required attributes weren't found, return nil
        if title == nil || photoID == nil || url == nil || dateTaken == nil {
            return nil
        }

        return Photo(title: title!, photoID: photoID!, URL: url!, dateTaken: dateTaken!)
    }

    private class func flickrURL(#method: Method, parameters: [String:String]?) -> NSURL? {
        if let components = NSURLComponents(string: baseURLString) {

            var queryItems = [NSURLQueryItem]()

            var baseParams = [
                "method": method.rawValue,
                "format": "json",
                "nojsoncallback": "1",
                "api_key": APIKey,
            ]

            for (key, value) in baseParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }

            if let additionalParams = parameters {
                for (key, value) in additionalParams {
                    let item = NSURLQueryItem(name: key, value: value)
                    queryItems.append(item)
                }
            }
            components.queryItems = queryItems

            return components.URL
        }

        return nil
    }
}
