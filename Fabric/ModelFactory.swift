//
//  ModelFactory.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation

enum DataSource {
    case coreData, network
}

class ModelFactory {
    private let networkService: NetworkService = .shared
    private let coreDataStack = CoreDataStack.shared.containter
    
    static let shared = ModelFactory()
    
    private init() {}
    
    func makeModel(dataSource type: DataSource, completion: @escaping (Result<CharacterProtocol, Error>) -> Void) {
        
        switch type {
        case .coreData:
            let requestToCoreData = CharacterData.fetchRequest()
            print("Create model from Core Data")
            do {
                let characters = try coreDataStack.viewContext.fetch(requestToCoreData)
                //объект по модели кор даты
                let characterFromCoreData = CharacterData(name: characters.last!.name, image: characters.last!.image, context: coreDataStack.viewContext)
                completion(.success(characterFromCoreData))
            }
            catch let error {
                print("error while getting info from core data: \(error)")
            }
        case .network:
            print("Create model from Network")
            let randomID = Int.random(in: 1...826)
            networkService.getCharacters(id: randomID) { result in
                switch result {
                case .success(let model):
                    //объект с типом Charcter Model
                    let character = CharacterModel(name: model.name, image: model.image)
                    do {
                        //сразу сохраняем в кор дату по модели кор даты
                        _ = CharacterData(name: character.name, image: character.image, context: self.coreDataStack.viewContext)
                        print("saved to core data")
                        try self.coreDataStack.viewContext.save()
                    } catch let error {
                        print("error: \(error.localizedDescription)")
                    }
                    completion(.success(character))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
}
