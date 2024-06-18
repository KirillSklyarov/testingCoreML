//
//  UIViewCont+Ext.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import UIKit

extension UIViewController {
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        return imageView
    }
    func setupPlaceholder() -> UILabel {
        let holder = UILabel()
        holder.text = "Нажми на кнопку, сфоткай что-нить и я тебе все про это расскажу"
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.textAlignment = .center
        holder.numberOfLines = 0
        holder.font = .systemFont(ofSize: 25)

        return holder
    }
}
