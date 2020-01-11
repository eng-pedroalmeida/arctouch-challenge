//
//  QuizAPI.swift
//  Quiz Challenge
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

enum QuizAPI: APIConfiguration {
    case get
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .get:
            return "quiz/1"
        }
    }
    
    var jsonPath: String? {
        switch self {
        case .get:
            return nil
        }
    }
    
    var url: String {
        return "\(RepositoryConstants.kBaseUrl)\(self.path)"
    }
}
