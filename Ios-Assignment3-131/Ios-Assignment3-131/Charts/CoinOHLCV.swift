//
//  CoinOHLCV.swift
//  Ios-Assignment3-131
//
//  Created by Ran Mo on 2019/6/2.
//

import Foundation

struct CoinOHLCV: Codable {
    struct Data: Codable {
        let id: Int
        let name: String
        let symbol: String

        struct Quote: Codable {
            let timeOpen: Date
            let timeClose: Date
            struct Quote: Codable {
                struct USD: Codable {
                    let open: Double
                    let high: Double
                    let low: Double
                    let close: Double
                    let volume: Double
                    let marketCap: Double
                    let timestamp: Date
                }
                let USD: USD
            }

            let quote: Quote
        }
        let quotes: [Quote]
    }
    let data: Data
    struct Status: Codable {
        let timestamp: Date
        let errorCode: Int
        let errorMessage: String?
        let elapsed: Int
        let creditCount: Int
    }
    let status: Status
}
