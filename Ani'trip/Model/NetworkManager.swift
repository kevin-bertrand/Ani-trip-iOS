//
//  NetworkManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 07/07/2022.
//

import Alamofire
import Foundation

final class NetworkManager: NetworkProtocol {
    /// Perform Alamofire request
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        
        guard let formattedUrl = URL(string: "\(url)/\(urlParams.joined(separator: "/"))") else {
            completionHandler((nil, nil, nil))
            return
        }
        
        do {
            let headers: HTTPHeaders = [
                authorization,
                .contentType("application/json; charset=utf-8")
            ]
            var request = try URLRequest(url: formattedUrl, method: method)
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
           }
            request.headers = headers

            let alamofireRequest = AF.request(request).validate()
            alamofireRequest.response { data in
                completionHandler((data.data, data.response, data.error))
            }
        } catch let error {
            print(error)
            completionHandler((nil, nil, nil))
        }
    }
    
    private let url = "http://192.168.1.164:80"
}

protocol NetworkProtocol {
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader, body: Encodable?, completionHandler: @escaping((Data?, HTTPURLResponse?, Error?))->Void)
}
