//
//  MainPresenter.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func getNewTitle(image: UIImage)
}

final class MainPresenter {

    // MARK: - View
    weak var view: MainVCProtocol?

    // MARK: - Other properties
    private let network: NetworkService
    private let coreML: CoreMLService

    // MARK: - Init
    init(view: MainVCProtocol? = nil, network: NetworkService = NetworkService.shared, coreML: CoreMLService = CoreMLService.shared) {
        self.view = view
        self.network = network
        self.coreML = coreML
    }

    // MARK: - Private methods
    private func getTextFromWiki(with title: String) {
        Task {
            guard let wikiData = await network.getTitle(with: title) else { print("Some problems here"); return }
            view?.updateWikiText(with: wikiData.title)
            view?.updateWikiImage(with: wikiData.imageURL)
        }
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func getNewTitle(image: UIImage) {
        guard let ciimage = CIImage(image: image) else { return }
        let newTitle = coreML.getTitle(image: ciimage)
        getTextFromWiki(with: newTitle)
        view?.updateTitle(with: newTitle)
    }
}
