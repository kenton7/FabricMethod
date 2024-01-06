//
//  NetworkService.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func getCharacters(id: Int, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(id)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("error \(String(describing: error))")
                completion(.failure(error!))
                return
            }
            
            if let data = data {
                let model = try! JSONDecoder().decode(CharacterModel.self, from: data)
                completion(.success(model))
            }
        }.resume()
    }
    
}
