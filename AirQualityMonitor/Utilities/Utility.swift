//
//  Utilitiy.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import Foundation

struct Console{
    static func log(_ statement:String){
#if DEBUG
        print(statement)
#endif
    }
}

class Utility{
    
    class func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
        return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
    }
    
}
