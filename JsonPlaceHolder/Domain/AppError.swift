//
//  AppError.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 10.09.25.
//

import Foundation

enum AppError: Error, LocalizedError {
    case networkError(Error)
    case noUsersFound
    case invalidURL
    case imageLoadFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noUsersFound:
            return "No users found"
        case .invalidURL:
            return "Invalid URL"
        case .imageLoadFailed:
            return "Failed to load image"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again"
        case .noUsersFound:
            return "Please try again later"
        case .invalidURL:
            return "Please contact support"
        case .imageLoadFailed:
            return "Please try again"
        case .unknown:
            return "Please try again or contact support"
        }
    }
}
