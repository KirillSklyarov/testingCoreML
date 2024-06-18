//
//  Constants.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import Foundation


struct Constants {

    struct Api {
        static let url = "https://en.wikipedia.org/w/api.php"

        static let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize": "500"]
    }
}
