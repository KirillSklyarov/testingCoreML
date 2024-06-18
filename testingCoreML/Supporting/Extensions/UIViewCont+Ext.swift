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
        imageView.contentMode = .scaleAspectFill

        return imageView
    }
    func setupPlaceholder(text: String = "Нажми на кнопку, сфоткай что-нить и я тебе все про это расскажу") -> UILabel {
        let holder = UILabel()
        holder.text = text
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.textAlignment = .center
        holder.numberOfLines = 0
        holder.font = .systemFont(ofSize: 15)

        return holder
    }
}
