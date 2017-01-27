//
//  UserDefaultsHelper.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 29-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import Foundation


class UserDefaultsHelper {
    
    private static let searchHistoryKey = "SEARCHHISTORY"
    
    static var searchHistory: [String] {
        get {
            if let returnValue = getObject(key: searchHistoryKey) as? [String] {
                return returnValue
            } else {
                return []
            }
        }
        set{
            
            if newValue.count > 100 {
                var stringArray = newValue
                stringArray.removeLast()
                storeObject(object: stringArray, key: searchHistoryKey)

            } else{
                storeObject(object: newValue, key: searchHistoryKey)
            }
        }
    }
    
    static func addSearchToSearchHistory(search: String){
        searchHistory.append(search)
        
        print(searchHistory)
    }
    
    private static func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private static func storeObject(object: Any, key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
