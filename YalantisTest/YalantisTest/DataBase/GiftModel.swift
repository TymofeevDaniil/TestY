//
//  GiftModel.swift
//  YalantisTest
//
//  Created by Danil Tymofeev on 01.09.2021.
//

import Foundation
import RealmSwift

class Persistance{
    static let shared = Persistance()
    private let realm = try! Realm()
    
//MARK: - Gift managment
    func download() -> ([String], [Int], [Bool]){
        var itemList = [String]()
        var priceList = [Int]()
        var checkList = [Bool]()
        let savedList = realm.objects(Gift.self)
        guard let _ = savedList.first else {return ([], [], [])}
        for index in 0..<savedList.count{
            itemList.append(savedList[index].item)
            priceList.append(savedList[index].price)
            checkList.append(savedList[index].check)
        }
        print("loaded")
        return (itemList, priceList, checkList)
    }
    func add(item: String, price: Int){
        try! realm.write{
            let newGift = Gift()
            newGift.item = item
            newGift.price = price
            newGift.check = false
            realm.add(newGift)
        }
        print("saved")
    }
    func save(giftList: [String], priceList: [Int], checkList: [Bool]) {
        let objects = realm.objects(Gift.self)
        try! realm.write{
            realm.delete(objects)
        }
        for i in 0..<giftList.count{
            let savedGift = Gift()
            try! realm.write{
                savedGift.item = giftList[i]
                savedGift.price = priceList[i]
                savedGift.check = checkList[i]
                realm.add(savedGift)
            }
        }
    }
    func delete(index: Int){
        let allGifts = realm.objects(Gift.self)
        try! realm.write{
            realm.delete(allGifts[index])
        }
        print("deleted")
    }
//    func download() -> ([String], [Int], [Bool], [Int]){
//        var itemList = [String]()
//        var priceList = [Int]()
//        var checkList = [Bool]()
//        var checkStack = [Int]()
//        let savedList = realm.objects(Gift.self)
//        guard let _ = savedList.first else {return ([], [], [], [])}
//        for index in 0..<savedList.count{
//            itemList.append(savedList[index].item)
//            priceList.append(savedList[index].price)
//            checkList.append(savedList[index].check)
//            checkStack.append(savedList[index].checkStack)
//        }
//        print("loaded")
//        return (itemList, priceList, checkList, checkStack)
//    }
//    func add(item: String, price: Int){
//        try! realm.write{
//            let newGift = Gift()
//            newGift.item = item
//            newGift.price = price
//            newGift.check = false
//            realm.add(newGift)
//        }
//        print("saved")
//    }
//    func save(giftList: [String], priceList: [Int], checkList: [Bool], checkStack: [Int]) {
//        let objects = realm.objects(Gift.self)
//        try! realm.write{
//            realm.delete(objects)
//        }
//        for i in 0..<giftList.count{
//            let savedGift = Gift()
//            try! realm.write{
//                savedGift.item = giftList[i]
//                savedGift.price = priceList[i]
//                savedGift.check = checkList[i]
//                savedGift.checkStack = checkStack[i]
//                realm.add(savedGift)
//            }
//        }
//        print("saved checkstack for iteams")
//    }
//    func delete(index: Int){
//        let allGifts = realm.objects(Gift.self)
//        try! realm.write{
//            realm.delete(allGifts[index])
//        }
//        print("deleted")
//    }
//MARK: - Stack managment
    func downloadStack() -> ([Int]){
        var stack = [Int]()
        let savedList = realm.objects(Stack.self)
        guard let _ = savedList.first else {return ([])}
        for index in 0..<savedList.count{
            stack.append(savedList[index].stack)
        }
        return (stack)
    }
    func saveStack(stack: [Int]) {
        let objects = realm.objects(Stack.self)
        try! realm.write{
            realm.delete(objects)
        }
        for i in 0..<stack.count{
            let savedStack = Stack()
            try! realm.write{
                savedStack.stack = stack[i]
                realm.add(savedStack)
            }
        }
    }
    func deleteStack(index: Int){
        let allGifts = realm.objects(Stack.self)
        try! realm.write{
            for item in allGifts {
                if item.stack == index {
                    realm.delete(item)
                }
            }
        }
        print("deleted")
    }
    
//    func check(newIndex: Int){
//        let objects = realm.objects(Gift.self)
//        try! realm.write{
//            realm.delete(objects)
//        }
//        for i in 0..<giftList.count{
//            let savedGift = Gift()
//            try! realm.write{
//                savedGift.item = giftList[i]
//                savedGift.price = priceList[i]
//                savedGift.check = checkList[i]
//                realm.add(savedGift)
//            }
//        }
//    }
}
