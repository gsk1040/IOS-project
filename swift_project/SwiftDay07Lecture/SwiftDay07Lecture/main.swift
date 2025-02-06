//
//  main.swift
//  SwiftDay07Lecture
//
//  Created by 원대한 on 2/6/25.
//


import Foundation



let sonata = Car(color: "검은색", speed: 110)
let grandeur = Car(color: "하얀색", speed: 120)

//리스트를 넣을 수 있나?

let carList: [Car] = [sonata,grandeur]
let carList2: [Car] = [Car(color: "보라색", speed: 90), Car(color: "파란색", speed: 130)]

//sonata.drive()
//grandeur.drive()
for car in carList {
    car.drive()
}

for (i, car) in carList2.enumerated() {
    print(i, terminator: ": ")
    car.drive()
}
