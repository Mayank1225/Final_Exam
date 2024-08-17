//
//  Mode.swift
//  Final_Exam
//
//  Created by user252704 on 8/16/24.
//

import Foundation

struct Expense {
    var name: String
    var amount: Double
}

struct Trip {
    var tripName: String
    var startLocation: String
    var endLocation: String
    var startDate: String
    var endDate: String
    var todoItems: [String]
    var expenses: [Expense] 
}

struct WeatherData: Codable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?
}

struct WeatherElement: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
