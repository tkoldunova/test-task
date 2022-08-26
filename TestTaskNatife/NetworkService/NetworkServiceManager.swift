//
//  NrtworkServiceManager.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import Foundation

protocol NetworkServiceManager {
    func jsonGetRequest<T:Decodable>(url: String,  returningType: T.Type, completion: @escaping (T?, Error?)->Void)
    func dataGetRequest(url: String, completion: @escaping (Data?, Error?)->Void)
}

extension NetworkServiceManager {
    
    internal func jsonGetRequest<T:Decodable>(url: String,  returningType: T.Type, completion: @escaping (T?, Error?)->Void)  {
        dataGetRequest(url: url) { data, error in
            guard let data = data else  {completion(nil, error); return}
            do {
                let jsonData = try JSONDecoder().decode(returningType.self, from: data)
                completion(jsonData, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
  
    internal func dataGetRequest(url: String, completion: @escaping (Data?, Error?)->Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval=15
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { completion(nil, nil); return }
            completion(data, nil)
        }
        task.resume()
        
    }
    
}
