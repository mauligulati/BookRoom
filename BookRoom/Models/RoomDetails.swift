//
//  RoomDetails.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 17/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import Foundation

struct RoomDetails : Encodable, Decodable{
    var name : String
    var capacity : String
    var level : String
    var availability : [String: String]
}
