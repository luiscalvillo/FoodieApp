//
//  Business.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/6/23.
//

import Foundation

struct Business {
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
    
    var coordinates: [String : Double]?
    var hours: [String : Any]?
}
