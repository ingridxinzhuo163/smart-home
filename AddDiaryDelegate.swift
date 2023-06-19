//
//  AddDiaryDelegate.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import Foundation
protocol AddDiaryDelegate: AnyObject {
    func addDiary(diary: Diary) -> Bool
}
