//
//  ViewController.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import UIKit
import CoreData

final class ViewController: UIViewController {
    
    private let container = CoreDataStack.shared.containter
    private let factory = ModelFactory.shared
    
    private let requestToCoreData = CharacterData.fetchRequest()
    
    private var randomCharacterID = Int.random(in: 1...826)
    private let mainViews = Views()

    override func loadView() {
        super.loadView()
        view = mainViews
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let characterInCoreData = try container.viewContext.fetch(requestToCoreData)
            if characterInCoreData.isEmpty {
                print(characterInCoreData.isEmpty)
                createSomeModel(dataSource: .network)
            } else {
                createSomeModel(dataSource: .coreData)
            }
        }
        catch {
            print("can't read context in core data")
        }
        
        mainViews.nextRandomCharacterButton.addTarget(self, action: #selector(nextRandomCharacter), for: .touchUpInside)
    }
    
    func createSomeModel(dataSource: DataSource) {
        ModelFactory.shared.makeModel(dataSource: dataSource) { result in
            switch result {
            case .success(let model):
                if let url = URL(string: model.image) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        print("url \(url)")
                        guard let data = data, let image = UIImage(data: data) else { return }
                        DispatchQueue.main.async {
                            self.mainViews.characterName.text = model.name
                            self.mainViews.characterImageView.image = image
                        }
                    }.resume()
                }
            case .failure(let error):
                print("ERROR! \(error)")
            }
        }
    }

    @objc private func nextRandomCharacter() {
        let request = CharacterData.fetchRequest()
        do {
            guard let lastCharacterInCoreData = try container.viewContext.fetch(request).last else { return }
            container.viewContext.delete(lastCharacterInCoreData)
            try container.viewContext.save()
        }
        catch {
            print("error")
        }
        createSomeModel(dataSource: .network)
    }
}

