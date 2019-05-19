//
//  Constants.swift
//  FunFact
//
//  Created by Vasu Chand on 19/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import Foundation

class Constants{
    
    enum TriviaType{
        case number(String)
        case cat
        case fun
        case math
        
        var url : URL?{
            switch self {
            case .number(let type):
                 let numberStr = "http://numbersapi.com/random/" + type + "?json"
                 return URL(string: numberStr)
            case .cat:
                return URL(string: "https://catfact.ninja/fact")
            case .fun:
                return URL(string: "http://api.icndb.com/jokes/random")
            case .math:
                return URL(string: "https://apiphany.azure-api.net/numbers/random/math")
            }
        }
        var imageName:String{
            switch self {
            case .number:
                return "number"
            case .cat:
                return "cat"
            case .fun:
                return "list"
            case .math:
                return "math"
            }
            
        }
    }
    
}
