//
//  PlaceholderAPI.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Foundation
import Moya

enum PlaceholderAPI {
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
}

extension PlaceholderAPI: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            fatalError("Base URL not configured")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getAlbums:
            return "/albums"
        case .getPhotos:
            return "/photos"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUsers, .getAlbums, .getPhotos:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        case .getAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId],
                                      encoding: URLEncoding.queryString)
        case .getPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
