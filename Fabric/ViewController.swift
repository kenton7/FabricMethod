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
    private let requestToCoreData = CharacterData.fetchRequest()
    private let mainViews = Views()

    override func loadView() {
        super.loadView()
        view = mainViews
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViews.activityIndicator.isHidden = false
        mainViews.activityIndicator.startAnimating()
        NetworkService.shared.getCharacters(id: Int.random(in: 1...826)) { result in
            switch result {
            case .success(let model):
                let factory = ModelFactory.makeModelNew(characterModel: model)
                guard let url = URL(string: factory.image) else { return }
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.mainViews.characterImageView.image = image
                            self.mainViews.characterName.text = factory.name
                            self.mainViews.activityIndicator.isHidden = true
                            self.mainViews.activityIndicator.stopAnimating()
                        }
                    }
                }.resume()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        mainViews.nextRandomCharacterButton.addTarget(self, action: #selector(nextRandomCharacter), for: .touchUpInside)
    }

    @objc private func nextRandomCharacter() {
        let randomID = Int.random(in: 1...826)

        mainViews.activityIndicator.isHidden = false
        mainViews.activityIndicator.startAnimating()
        
        NetworkService.shared.getCharacters(id: randomID) { result in
            switch result {
            case .success(let model):
                let newCharacterModel = ModelFactory.makeModelNew(characterModel: model)
                guard let url = URL(string: newCharacterModel.image) else { return }
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.mainViews.characterImageView.image = image
                            self.mainViews.characterName.text = newCharacterModel.name
                            self.mainViews.activityIndicator.isHidden = true
                            self.mainViews.activityIndicator.stopAnimating()
                        }
                    }
                }.resume()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

