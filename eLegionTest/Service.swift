//
//  Service.swift
//  eLegionTest
//
//  Created by Albert Garipov on 20.03.2023.
//

import Foundation

class Service {

    static let shared = Service()

    func fetchPeople(completion: @escaping ([Person]) -> Void) {

        var persons = [Person(name: "Медный всадник", avatar: "vsadnik", latitude: 59.936402, longitude: 30.302156), Person(name: "Пушкин", avatar: "pushkin", latitude: 59.937255, longitude: 30.331627), Person(name: "Чижик-Пыжик", avatar: "chiz", latitude: 59.941865, longitude: 30.337754), Person(name: "Ломоносов", avatar: "lomonosov", latitude: 59.940541, longitude: 30.301595)]

        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            for i in 0..<persons.count {
                let latitudeOffset = Double.random(in: -0.01...0.01)
                let longitudeOffset = Double.random(in: -0.01...0.01)
                persons[i].latitude += latitudeOffset
                persons[i].longitude += longitudeOffset
            }

            completion(persons)
        }
    }
}
