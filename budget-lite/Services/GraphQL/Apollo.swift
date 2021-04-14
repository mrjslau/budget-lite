//
//  Apollo.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-24.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    lazy var apollo = ApolloClient(url: Constants.API.swopURL)
}
