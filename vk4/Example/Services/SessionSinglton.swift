//
//  SessionSinglton.swift
//  Example
//
//  Created by Alexandr Evtodiy on 27.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//


import Foundation

class Session {
    private init() {}
    
    static let instance = Session ()
    
    var token: String?
    var userId: String?
    
}
