//
//  CoreMLService.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import UIKit
import CoreML
import Vision


final class CoreMLService {

    static let shared = CoreMLService(); private init() { }

    func getTitle(image: CIImage) -> String {
        guard let results = detect(image: image) else { print("Ooops"); return ""}

        guard let title = results.first?.identifier else {
            print("Can't get the title from model"); return ""}
        let firstTitle = getFirstNameOnly(from: title)
        return firstTitle
    }

    private func detect(image: CIImage) -> [VNClassificationObservation]? {
        var classificationResults: [VNClassificationObservation]?

        let config = MLModelConfiguration()

        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model) else {
            fatalError("App failed to create a VNCoreMLModel instance")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Model failed to process image"); return }
            classificationResults = results
        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        return classificationResults
    }

    private func getFirstNameOnly(from title: String) -> String {
        let splitTitle = title.split(separator: ",")
        guard let firstWord = splitTitle.compactMap({ String($0) }).first else { print("Can't get the first word of title"); return ""}
        return firstWord
    }

}
