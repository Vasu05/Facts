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
        case number
        case cat
        case fun
        case math
        
        var url : URL?{
            switch self {
            case .number:
                 return URL(string: "")
            case .cat:
                return URL(string: "")
            case .fun:
                return URL(string: "")
            case .math:
                return URL(string: "")
            }
        }
    }
    
}
