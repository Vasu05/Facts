//
//  FunModel.swift
//  FunFact
//
//  Created by Vasu Chand on 19/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import Foundation

struct DataSource {
    var cellType:Constants.TriviaType
    var desc:String
}
/*
{
    "text": "October 29th is the day in 1955 that the Soviet battleship Novorossiisk strikes a World War II mine in the harbor at Sevastopol.",
    "year": 1955,
    "number": 303,
    "found": true,
    "type": "date"
}
 */
struct NumberTriviaResponse : Codable{
    let text : String?
    let year  : Int?
    let found : Bool?
    let type : String?
}
/*
{
    "fact": "There are up to 60 million feral cats in the United States alone.",
    "length": 65
}
 */
struct CatResponse : Codable{
    let fact : String?
    let length  : Int?
}

/*
{
    "type": "success",
    "value": {
        "id": 547,
        "joke": "Product Owners never ask Chuck Norris for more features. They ask for mercy.",
        "categories": [
        "nerdy"
        ]
    }
}
 */

struct JokesValueResponse : Codable{
    let joke : String?
    let id  : Int?
    let categories : [String?]
}
struct JokesResponse : Codable{
    let type : String?
    let value : JokesValueResponse?
}

