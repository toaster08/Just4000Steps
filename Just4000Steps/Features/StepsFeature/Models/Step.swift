//
//  Step.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/13.
//

import Foundation

struct Step: Identifiable, Equatable {
    let id = UUID()
    let count: Int
    let date: Date
}
