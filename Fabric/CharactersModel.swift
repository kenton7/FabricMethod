//
//  Model.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation

protocol CharacterProtocol {
    var name: String { get }
    var image: String { get }
}

struct CharacterModel: Codable, CharacterProtocol {
    var name: String
    var image: String
}

extension CharacterModel {
    func toCoreDataModel() {
        print("to core name: \(name)")
    }
}
