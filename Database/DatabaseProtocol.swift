//
//  DatabaseProtocol.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case diary
    case rgb
    case weather
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onDiaryListChange(change: DatabaseChange, diaries: [Diary])
    func onRgbChange(change: DatabaseChange, rgb:Rgb)
    func onWeatherChange(change: DatabaseChange, weather:Weather)
    
}

protocol DatabaseProtocol: AnyObject {
    
    func addDiary(title: String,content: String,date :String, red :String,green :String,blue :String, temp :String, pressure : String) -> Diary
    func deleteDiary(diary: Diary)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func getWeather() -> Weather
    func getRgb() -> Rgb
}
