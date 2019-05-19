//
//  FactsEngine.swift
//  FunFact
//
//  Created by Vasu Chand on 19/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import Foundation
import PopupDialog

class FactsEngine{
    
    class func taskForGETRequest<ResponseType :Decodable>(url : URL,responseType : ResponseType.Type ,specialCase:Bool = false,completion: @escaping (ResponseType? ,Error? ) -> Void){
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = ["X-Parse-Application-Id":AppCredentials.Parse_Application_ID ,"X-Parse-REST-API-Key":AppCredentials.REST_API_Key ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let responseData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseData, nil)
                }
            }
            catch let error{
                DispatchQueue.main.async {
                    completion(nil, error)
                }

            }
        }
        task.resume()
    }
    
    class func getNumberTrivia(completion:@escaping (NumberTriviaResponse?,Error?)->Void){
        
        let array = ["trivia","math","date","year"]
        if let randomTrivia = array.randomElement(){
            
            if let url = Constants.TriviaType.number(randomTrivia).url{
                FactsEngine.taskForGETRequest(url: url, responseType:NumberTriviaResponse.self) { (response, error) in
                    completion(response,error)
                }
            }
        }
    }
    
    class func getCatFacts(completion:@escaping(CatResponse?,Error?)->Void){
        
        if let url = Constants.TriviaType.cat.url{
            FactsEngine.taskForGETRequest(url: url, responseType: CatResponse.self) { (response, error) in
                completion(response,error)
            }
        }
    }
    
    class func getRandomJokes(completion:@escaping(JokesResponse?,Error?)->Void){
        
        if let url = Constants.TriviaType.fun.url{
            FactsEngine.taskForGETRequest(url: url, responseType: JokesResponse.self) { (response, error) in
                completion(response,error)
            }
        }
    }
    
    class func getMathRandomFacts(completion:@escaping(String?,Error?)->Void){
        
        if let url = Constants.TriviaType.math.url{
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else{
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                    return
                }
                
                let responseStr = String(decoding: data, as: UTF8.self)
                completion(responseStr,nil)
               
            }
            task.resume()
        }
    }
    
}
