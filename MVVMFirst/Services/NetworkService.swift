//
//  NetworkService.swift
//  MVVMFirst
//
//  Created by Алексей on 02.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkService {
    
    func makeRequest() -> Observable<Result<[Movie], Error>>{
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.apiKey)") else {
            print("Invalid url")
            return Observable.empty()
        }
        return URLSession.shared
            .rx
            .json(url: url)
            .map { result -> Result<[Movie], Error> in
                guard let resultDict = result as? [String : Any],
                      let moviesArray = resultDict["results"] as? [[String : Any]] else { return .failure(JSONDecodeError.jsonDecodeError) }
                do {
                    let result = try moviesArray.map { try Movie(data: $0) }
                    return .success(result)
                } catch {
                    return .failure(JSONDecodeError.jsonDecodeError)
                }
            }
            .share()
    }
}

extension NetworkService {
    enum Constants {
        static let apiKey = "2d378ad2057127f5aa526f40cb0416fd"
    }
}
