//
//  Song.swift
//  SpotifyClone
//
//  Created by Вадим on 2.09.22.
//

import Foundation


struct Song {
    let name: String
    let image: String
    let artist: String
    let fileName: String
}

extension Song {
    
    static func get() -> [Song] {
        return [
            Song(name: "Knockin on Heavens Door", image: "Bob Dylan - Knockin on Heavens Door", artist: "Bob Dylan", fileName: "Bob Dylan - Knockin on Heavens Door"),
            Song(name: "Big City Life", image: "Mattafix - Big City Life", artist: "Mattafix", fileName: "Mattafix - Big City Life"),
            Song(name: "Under Pressure", image: "Queen, David Bowie - Under Pressure", artist: "Queen, David Bowie", fileName: "Queen, David Bowie - Under Pressure")
        ]
    }
}
