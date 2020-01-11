//
//  QuizRepository.swift
//  Quiz Challenge
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

struct QuizRepository {
    func get(success successHandler: @escaping ((_ response: Quiz) -> Void), error errorHandler: @escaping RequestErrorHandler) {
        EasyRequest<Quiz>.get(api: QuizAPI.get, success: successHandler, error: errorHandler)
    }
}
