//
//  File1.swift
//  IMDB Search
//
//  Created by Ajay Saradhi Reddy on 3/24/20.
//  Copyright © 2020 Ajay Saradhi Reddy. All rights reserved.
//

import Foundation

struct IMDbInfo: Decodable {
    let Title: String!
    let Year: String!
    let Plot: String!
    let Poster: String!
    let imdbRating: String!
    let Error: String!
    let Released: String!
    let imdbID: String!
}
