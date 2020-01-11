//
//  APIConfiguration.swift
//  Quiz Challenge
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

protocol APIConfiguration {
    var method: String { get }
    var path: String { get }
    var jsonPath: String? { get }
    var url: String { get }
}
