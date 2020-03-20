//
//  Constants.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 17/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct URLS {
        static let base  = "http://gist.githubusercontent.com"
        
        static let RoomAvailability = "/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6/room-availability.json"
    }
    struct Font {
        static let cellFont = UIFont(name: "HelveticaNeue-Italic", size: 12.0)
    }
    struct Color {
        static let greenColor = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
}
