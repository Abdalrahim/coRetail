//
//  Logger.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 24/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//


/// struct need to print the data in the cosole, this is for the programmer just
struct Logger {
    
    /// Call for normal mode
    ///
    /// - Parameters:
    ///   - tag: like a key
    ///   - message: show the meessage that you want
    static func normal(tag:String, message:Any){
        print("Log: \(tag) : \(message)")
    }
    
    /// Call for error mode
    ///
    /// - Parameters:
    ///   - tag: like a key
    ///   - message: show the meessage that you want
    static func error(tag:String, message:Any){
        print("Error: \(tag) : \(message)")
    }
}
