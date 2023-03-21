//
//  Person.swift
//  eLegionTest
//
//  Created by Albert Garipov on 16.03.2023.
//
import Foundation

public struct Person {
    let id = UUID().uuidString
    var name: String
    var avatar: String?
    var latitude: Double
    var longitude: Double
}
