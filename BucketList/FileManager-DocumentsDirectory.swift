//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Dmitryi Velko on 24.05.2022.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
