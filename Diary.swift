//
//  Diary.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class Diary: NSObject {
    
    public var id: String
    public var title: String
    public var date: String
    public var content: String
    public var red: String
    public var green:String
    public var blue:String
    public var temp:String
    public var pressure:String

    override init() {
        self.id = ""
        self.title = ""
        self.date = ""
        self.content = ""
        self.red = ""
        self.green = ""
        self.blue = ""
        self.temp = ""
        self.pressure = ""
    }

}
