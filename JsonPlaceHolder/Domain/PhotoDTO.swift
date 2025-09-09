//
//  PhotoDTO.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    // Computed properties for Picsum Photos API
    var picsumUrl: String {
        let validId = ((id - 1) % 1000) + 1 // Ensure ID is between 1-1000
        return "https://picsum.photos/id/\(validId)/800/600"
    }
    
    var picsumThumbnailUrl: String {
        let validId = ((id - 1) % 1000) + 1 // Ensure ID is between 1-1000
        return "https://picsum.photos/id/\(validId)/300/300"
    }
}
