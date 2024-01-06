//
//  ModelFactory.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation

class ModelFactory {
    private let networkService: NetworkService = .shared
    private let coreDataStack: CoreDataStack = .shared
    
    static let shared = ModelFactory()
    
    private init() {}
    
    func makeModel(completion: @escaping (Result<CharacterProtocol, Error>) -> Void) {
        let requestToCoreData = CharacterData.fetchRequest()
        
        let coreModel = try? coreDataStack.containter.viewContext.fetch(requestToCoreData)
        if coreModel!.isEmpty || coreModel == nil {
            let randomID = Int.random(in: 1...826)
            networkService.getCharacters(id: randomID) { result in
                print("loading from API")
                switch result {
                case .success(let model):
                    let character = CharacterData(context: self.coreDataStack.containter.viewContext)
                    character.name = model.name
                    character.image = model.image
                    do {
                        try self.coreDataStack.containter.viewContext.save()
                    } catch let error {
                        print("error: \(error.localizedDescription)")
                    }
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            print("get from core data")
            do {
                let characters = try coreDataStack.containter.viewContext.fetch(requestToCoreData)
                completion(.success(CharacterModel(name: characters.last!.name, image: characters.last!.image)))
            }
            catch let error {
                print("error while getting info from core data: \(error)")
            }
        }
    }
}
