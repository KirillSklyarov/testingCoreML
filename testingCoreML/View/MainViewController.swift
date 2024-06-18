//
//  ViewController.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 17.06.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var pictureView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .blue
        return view
    }()

    private lazy var wikiText: UITextView = {
        let wiki = UITextView()
        wiki.translatesAutoresizingMaskIntoConstraints = false
        wiki.backgroundColor = .cyan
        return wiki
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
    }

    @objc private func cameraButtonTapped(sender: UIBarButtonItem) {

    }

    private func setupNavigation() {
        title = "123"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(pictureView)
        view.addSubview(wikiText)

        NSLayoutConstraint.activate([
            pictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pictureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pictureView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor),

            wikiText.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 20),
            wikiText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wikiText.widthAnchor.constraint(equalTo: pictureView.widthAnchor),
            wikiText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

}