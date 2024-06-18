//
//  NetworkService.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case decodingIssue
    case noWikiData
}

final class NetworkService {

    static let shared = NetworkService(); private init() { }

    func getTitle(with title: String) async -> (title: String, imageURL: URL)? {
        guard let data = try? await self.fetchData(for: title),
              let title = data.query.pages.first?.value.extract,
              let imageURL = data.query.pages.first?.value.thumbnail?.source,
              let url = URL(string: imageURL)
        else { print(NetworkErrors.noWikiData); return nil }
        print(title, imageURL)
        return (title, url)
    }

    private func createURL(for keyWord: String, baseURL: String = Constants.Api.url, params: [String: String] = Constants.Api.parameters) -> URL? {
        var updatedParams = params
        updatedParams["titles"] = keyWord

        guard var urlComponents = URLComponents(string: baseURL) else { return nil }

        urlComponents.queryItems = updatedParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        return urlComponents.url
    }

    private func fetchData(for keyWord: String = "Flower") async throws -> ApiModel? {
        guard let url = createURL(for: keyWord) else { print(NetworkErrors.invalidURL); return nil }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print(NetworkErrors.invalidResponse); return nil}

        let decoder = JSONDecoder()
        guard let model = try? decoder.decode(ApiModel.self, from: data) else {
            print(NetworkErrors.decodingIssue); return nil}

        return model
    }
}
