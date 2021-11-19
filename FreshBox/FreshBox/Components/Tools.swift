//
//  Tools.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/09.
//

import Foundation

func dateFormatter(of date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.string(from: date)
}

func dateDifference(of lhs: Date, with rhs: Date) -> Int {
    let a = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: lhs))
    let b = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: rhs))
    let res = Calendar.current.dateComponents([.day, .hour], from: a!, to: b!)
    return res.day!
}
