//
//  ModelFactory.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation

class ModelFactory {
    private let networkService: NetworkService = .shared
    private let coreDataStack = CoreDataStack.shared.containter
    
    class func makeModelNew(characterModel: CharacterProtocol) -> CharacterModel {
        return CharacterModel(name: characterModel.name, image: characterModel.image)
    }
}
