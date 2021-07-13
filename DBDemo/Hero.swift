//
//  Hero.swift
//  DBDemo
//
//  Created by Henry Doan on 7/12/21.
//

import Foundation

class Hero {

    var id: Int
    var name: String?
    var powerRanking: Int
 
    init(id: Int, name: String?, powerRanking: Int){
        self.id = id
        self.name = name
        self.powerRanking = powerRanking
    }
}
