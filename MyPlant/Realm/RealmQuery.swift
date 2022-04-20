//
//  RealmQuery.swift
//  MyPlant
//
//  Created by mac on 2021/11/19.
//
import UIKit
import RealmSwift

extension UIViewController {
    
    func searchQuearyFromUserPlant(text:String) -> Results<plant> {
        let localRealm = try! Realm()
        let search = localRealm.objects(plant.self).filter("diratTitle CONTAINS[c] '\(text)' OR CONTAINS[c] '\(text)'")
        
        return search
    }
    func getAllDiaryCountFormUserPlant() -> Int{
        let localRealm = try! Realm()
        
        return localRealm.objects(plant.self).count
    }
}
