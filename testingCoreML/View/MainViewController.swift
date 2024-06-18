//
//  ViewController.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 17.06.2024.
//

import UIKit
import CoreML
import Vision

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
        wiki.font = .systemFont(ofSize: 25)
        return wiki
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    let network = NetworkService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        getTextFromWiki()
    }

    @objc private func cameraButtonTapped(sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }

    private func getTextFromWiki() {
        Task {
            let wikiText = await network.getTitle()
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

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { print("tttt"); return }
        pictureView.image = image

        guard let ciimage = CIImage(image: image) else { return }
        detect(image: ciimage)

        dismiss(animated: true)
    }

    func detect(image: CIImage) {
        let config = MLModelConfiguration()

        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model) else {
            fatalError("App failed to create a VNCoreMLModel instance")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Model failed to process image"); return }
            print(results)
        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
