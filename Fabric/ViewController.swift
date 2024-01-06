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
    
    private var randomCharacterID = Int.random(in: 1...826)
    private let mainViews = Views()

    override func loadView() {
        super.loadView()
        view = mainViews
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        factory.makeModel { result in
            switch result {
            case .success(let model):
                guard let url = URL(string: model.image) else { return }
                let privateQueue = DispatchQueue(label: "networkQueue", qos: .utility)
                privateQueue.async {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.mainViews.characterImageView.image = image
                                self.mainViews.characterName.text = model.name
                            }
                        }
                    }.resume()
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
        
        mainViews.saveToDataBaseButton.addTarget(self, action: #selector(saveToCoreData), for: .touchUpInside)
        mainViews.nextRandomCharacterButton.addTarget(self, action: #selector(nextRandomCharacter), for: .touchUpInside)
    }
    
    @objc private func saveToCoreData() {
        let character = CharacterData(context: container.viewContext)
        do {
            try self.container.viewContext.save()
        }
        catch let error {
            print(error)
        }
    }
    
    @objc private func nextRandomCharacter() {
        let randomID = Int.random(in: 1...826)
        NetworkService.shared.getCharacters(id: randomID) { result in
            switch result {
            case .success(let model):
                //guard let image = model.image, let imageURL = URL(string: image) else { return }
                guard let url = URL(string: model.image) else { return }
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let imageData = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.mainViews.characterImageView.image = imageData
                            self.mainViews.characterName.text = model.name
                        }
                        let newCharacter = CharacterData(context: self.container.viewContext)
                        newCharacter.image = model.image
                        newCharacter.name = model.name
                        do {
                            try self.container.viewContext.save()
                        }
                        catch let error {
                            print("error when saving to core data \(error)")
                        }
                    }
                }.resume()
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
}

