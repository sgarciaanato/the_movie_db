//
//  Utils.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import Foundation

final class Utils {
    static let shared = Utils()
    
    private init() {}
    
    func modelFrom<T: Decodable>(_ fileName: String) -> T {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }

        print("The JSON string is: \(jsonString)")

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to Data")
        }
        
        do {
            let authorDetail = try JSONDecoder().decode(T.self, from: jsonData)
            return authorDetail
        } catch {
            debugPrint(error)
            fatalError("Unabel to decode")
        }
    }
}
