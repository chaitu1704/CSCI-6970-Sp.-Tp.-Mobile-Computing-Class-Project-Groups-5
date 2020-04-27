//
//  apiRequest.swift
//  IMDB Search
//
//  Created by Ajay Saradhi Reddy on 3/24/20.
//  Copyright © 2020 Ajay Saradhi Reddy. All rights reserved.
//

import Foundation

struct apiRequest {
    var url:URL
    
    init(url:URL) {
        self.url = url
    }
    
    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: self.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(Result.failure(APPError.networkError(error!)))
                return
            }

            guard let data = data else {
                completion(Result.failure(APPError.dataNotFound))
                return
            }

            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
            }
        })

        task.resume()
    }
}
