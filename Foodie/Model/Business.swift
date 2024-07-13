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
