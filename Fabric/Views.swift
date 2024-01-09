//
//  Views.swift
//  Fabric
//
//  Created by Илья Кузнецов on 06.01.2024.
//

import Foundation
import UIKit

final class Views: UIView {
    
    lazy var characterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var characterName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var nextRandomCharacterButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 10, width: 200, height: 50)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Следующий случайный персонаж", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemGreen
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.style = .large
        activityView.isHidden = true
        activityView.color = .white
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        
        addSubview(characterName)
        addSubview(characterImageView)
        addSubview(nextRandomCharacterButton)
        addSubview(activityIndicator)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([

            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 300),
            characterImageView.heightAnchor.constraint(equalToConstant: 400),
            
            characterName.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 10),
            characterName.centerXAnchor.constraint(equalTo: characterImageView.centerXAnchor),
            
            nextRandomCharacterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nextRandomCharacterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nextRandomCharacterButton.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: characterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor)
        ])
    }
    
}
