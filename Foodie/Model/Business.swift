//
//  Business.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/6/23.
//

import Foundation

struct Business: Codable {
    var name: String?
    var id: String?
    var address: String?
    var distance: Double?
    var imageURL: String?
    
    var latitude: Double?
    var longitude: Double?
    var isClosed: Bool?
    var isOpenNow: Bool?
    var rating: Double?
    var phone: String?
    var displayPhone: String?
    var website: String?
    
    struct Coordinates: Codable {
        var latitude: Double?
        var longitude: Double?
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case address
        case distance
        case imageURL = "image_url"
        case latitude
        case longitude
        case isClosed = "is_closed"
        case isOpenNow = "is_open_now"
        case rating
        case phone
        case displayPhone = "display_phone"
        case website = "url"
    }
}


func createStarRatings(rating: Double?, ratingLabelText: String) -> String {
    
    var ratingLabelText = ratingLabelText
    
    switch rating {
    case 1.0:
        ratingLabelText = "⭐️"
    case 1.5:
        ratingLabelText = "⭐️✨"
    case 2.0:
        ratingLabelText = "⭐️⭐️"
    case 2.5:
        ratingLabelText = "⭐️⭐️✨"
    case 3.0:
        ratingLabelText = "⭐️⭐️⭐️"
    case 3.5:
        ratingLabelText = "⭐️⭐️⭐️✨"
    case 4.0:
        ratingLabelText = "⭐️⭐️⭐️⭐️"
    case 4.5:
        ratingLabelText = "⭐️⭐️⭐️⭐️✨"
    case 5.0:
        ratingLabelText = "⭐️⭐️⭐️⭐️⭐️"
    default:
        ratingLabelText = "⭐️⭐️⭐️⭐️⭐️"
    }
    
    return ratingLabelText
}

