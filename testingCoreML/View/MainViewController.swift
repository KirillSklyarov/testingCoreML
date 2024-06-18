//
//  ViewController.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 17.06.2024.
//

import UIKit

protocol MainVCProtocol: AnyObject {
    func updateWikiText(with wiki: String)
    func updateTitle(with title: String)
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var pictureView = setupImageView()
    private lazy var placeholder = setupPlaceholder()

    private lazy var wikiText: UITextView = {
        let wiki = UITextView()
        wiki.translatesAutoresizingMaskIntoConstraints = false
        wiki.font = .systemFont(ofSize: 25)
        wiki.textAlignment = .center
        wiki.isEditable = false
        wiki.text = "Скоро здесь появится много интересной информации обо всем на свете!"
        return wiki
    }()
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    // MARK: - Other Properties
    private let presenter: MainPresenterProtocol

    // MARK: - Init
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
    }

    // MARK: - IB Action
    @objc private func cameraButtonTapped(sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
    // MARK: - Private methods
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        pictureView.addSubview(placeholder)

        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: pictureView.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor),
            placeholder.widthAnchor.constraint(equalTo: pictureView.widthAnchor, multiplier: 0.9)
        ])

        view.addSubview(wikiText)

        NSLayoutConstraint.activate([
            wikiText.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 20),
            wikiText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wikiText.widthAnchor.constraint(equalTo: pictureView.widthAnchor),
            wikiText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { print("tttt"); return }
        updatePictureView(with: image)
        presenter.getNewTitle(image: image)

        dismiss(animated: true)
    }

    private func updatePictureView(with image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.pictureView.image = image
            self?.placeholder.isHidden = true
        }
    }
}

extension MainViewController: MainVCProtocol {
    
    func updateWikiText(with wiki: String) {
        DispatchQueue.main.async { [weak self] in
            self?.wikiText.text = wiki
        }
    }

    func updateTitle(with title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.title = title.capitalized
        }
    }
}
