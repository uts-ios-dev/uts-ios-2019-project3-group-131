//
//  Network.swift
//  Ios-Assignment3-131
//
//  Created by MorningStar on 2019/6/2.
//

import Foundation

struct Networking {

    enum Path: String {
        case ohlcvHistorical = "v1/cryptocurrency/ohlcv/historical"
    }

    static let baseURL: String = "https://pro-api.coinmarketcap.com/"

    static func request(path: Path, parameters: [String: String], success: @escaping (Data) -> Void, failed: @escaping (Error) -> Void) {

        guard let url = URL(string: baseURL + path.rawValue) else { return }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        // GET 请求拼接参数后的URL
        components?.queryItems = parameters.map { key, element in
            URLQueryItem(name: key, value: element)
        }
        
        guard let componentsURL = components?.url else {
            fatalError("wrong url")
        }

        printLog(componentsURL)

        var request = URLRequest(url: componentsURL)
        request.httpMethod = "GET"

        // Headers
        request.addValue("15e40f74-f54b-4773-8dc0-e5748671f5d3", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failed(error)
            }
            else if let response = response as? HTTPURLResponse,
                200..<400 ~= response.statusCode,
                let data = data {
                success(data)
            }
        }

        task.resume()
    }
}

extension Optional {
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }

    var isSome: Bool {
        return !isNone
    }
}
