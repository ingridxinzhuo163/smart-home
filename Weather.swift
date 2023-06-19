//
//  Weather.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class Weather: NSObject {

    public var id: String
    public var temp: String
    public var pressure: String
    
    override init() {
        self.id = ""
        self.temp = ""
        self.pressure = ""
    }
    
}
