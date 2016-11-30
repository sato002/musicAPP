//
//  SongEntity.swift
//  musicAPP
//
//  Created by Admin on 11/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class Song {
    var artist:String!
    var name:String!
    var image:String
    
    init(ar:String , na:String , im:String) {
        self.artist = ar
        self.name = na
        self.image = im
    }
}
