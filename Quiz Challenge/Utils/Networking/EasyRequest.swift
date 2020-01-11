//
//  EasyRequest.swift
//  Quiz Challenge
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

public typealias RequestErrorHandler = (_ error: Error?) -> Void

public struct EasyRequest<Model: Codable> {
    public typealias RequestSuccessHandler = (_ response: Model) -> Void

    static func get(api: APIConfiguration, success successHandler: @escaping RequestSuccessHandler, error errorHandler: @escaping RequestErrorHandler) {
        guard let urlComponent = URLComponents(string: api.url), let usableUrl = urlComponent.url else {
            errorHandler(nil)
            return
        }
        
        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                dataTask = nil
            }
            
            if error != nil {
                errorHandler(error)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                guard let model = self.parsedModel(with: data, at: api.jsonPath) else {
                    errorHandler(nil)
                    return
                }
                
                DispatchQueue.main.async {
                  successHandler(model)
                }
            } else {
                errorHandler(nil)
            }
        })
        
        dataTask?.resume()
    }
    
    static func parsedModel(with data: Data, at path: String?) -> Model? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            if let path = path, let dictAtPath = json?.value(forKeyPath: path) {
                let jsonData = try JSONSerialization.data(withJSONObject: dictAtPath, options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode(Model.self, from: jsonData)
                return model
            } else {
                return try JSONDecoder().decode(Model.self, from: data)
            }
        } catch {
            return nil
        }
    }
}
