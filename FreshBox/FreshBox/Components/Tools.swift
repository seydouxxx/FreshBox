//
//  Tools.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/09.
//

import Foundation

func dateFormatter(of date: Date) -> String {
    let dateArray = date.formatted(date: .numeric, time: .omitted).split{$0=="/"}
    return String(dateArray[0] + "년 " + dateArray[1] + "월 " + dateArray[2] + " 일")
}

func dateDifference(of lhs: Date, with rhs: Date) -> Int {
    let a = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: lhs))
    let b = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: rhs))
    let res = Calendar.current.dateComponents([.day, .hour], from: a!, to: b!)
    return res.day!
}
