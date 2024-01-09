//
//  CharacterData+CoreDataProperties.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//
//

import Foundation
import CoreData


extension CharacterData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterData> {
        return NSFetchRequest<CharacterData>(entityName: "CharacterData")
    }

    @NSManaged public var name: String
    @NSManaged public var image: String

}

extension CharacterData : Identifiable {

}

extension CharacterData: CharacterProtocol {
    
    convenience init(name: String, image: String, context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CharacterData", in: context)!
        self.init(entity: entityDescription, insertInto: context)
        self.image = image
        self.name = name
    }
}

extension CharacterData {
    func toCharacterModel() -> CharacterProtocol {
//        guard let imageString = String(data: image ?? Data(), encoding: .utf8), let name = name else {
//            print("can't convert from coreData to local model")
//        }
        let characterModel = CharacterModel(name: name, image: image)
        return characterModel
    }
}
