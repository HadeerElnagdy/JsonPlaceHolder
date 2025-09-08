//
//  NetworkClient.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Moya
import RxSwift
import RxMoya

protocol NetworkClientType {
    func request<T: Decodable>(_ target: PlaceholderAPI,
                               type: T.Type) -> Single<T> 
}

final class NetworkClient: NetworkClientType {
    
    private let provider: MoyaProvider<PlaceholderAPI>
    
    init(provider: MoyaProvider<PlaceholderAPI> = MoyaProvider<PlaceholderAPI>()) {
        self.provider = provider
    }
    
    func request<T: Decodable>(_ target: PlaceholderAPI, type: T.Type) -> Single<T> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.self)
    }
}

