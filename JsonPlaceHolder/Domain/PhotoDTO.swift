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
    
    //Workaround
    // Computed properties for Picsum Photos API as the actual API pics urls are not valid
    var picsumUrl: String {
        let validId = ((id - 1) % 1000) + 1
        return "\(Constants.API.picsumBaseURL)/id/\(validId)/\(Int(Constants.ImageViewer.imageSize.width))/\(Int(Constants.ImageViewer.imageSize.height))"
    }
    
    var picsumThumbnailUrl: String {
        let validId = ((id - 1) % 1000) + 1
        return "\(Constants.API.picsumBaseURL)/id/\(validId)/\(Int(Constants.ImageViewer.thumbnailSize.width))/\(Int(Constants.ImageViewer.thumbnailSize.height))"
    }
}
