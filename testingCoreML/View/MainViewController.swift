//
//  ViewController.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 17.06.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
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
        wiki.font = .systemFont(ofSize: 25)
        wiki.textAlignment = .justified
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
    private let network: NetworkService
    private let coreML: CoreMLService

    // MARK: - Init
    init(network: NetworkService = NetworkService.shared, coreML: CoreMLService = CoreMLService.shared) {
        self.network = network
        self.coreML = coreML
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
    private func getTextFromWiki(with title: String) {
        Task {
            let wikiText = await network.getTitle(with: title)
            updateUI(with: wikiText)
        }
    }

    private func updateUI(with wiki: String) {
        DispatchQueue.main.async { [weak self] in
            self?.wikiText.text = wiki
        }
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

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { print("tttt"); return }
        pictureView.image = image

        guard let ciimage = CIImage(image: image) else { return }
        getNewTitle(image: ciimage)

        dismiss(animated: true)
    }

    private func getNewTitle(image: CIImage) {
        let newTitle = coreML.getTitle(image: image)
        getTextFromWiki(with: newTitle)
        updateTitle(with: newTitle)
    }

    private func updateTitle(with title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.title = title.capitalized
        }
    }

}
