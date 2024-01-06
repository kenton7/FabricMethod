//
//  CoreDataStack.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let shared: CoreDataStack = .init() // singletone
    
    let containter: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Fabric")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("\(error)")
            }
        }
        return container
    }()
}
