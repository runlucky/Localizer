//
//  FileManager.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

struct FileManager {
    private let input: LocalizeDictionary
    private let outputURL: URL

    init() throws {
        guard let url = Bundle.main.url(forResource: "LocalizeDictionary", withExtension: "json") else {
            throw LocalizerError("LocalizeDictionary.json が見つかりませんでした。")
        }
        
        let data = try Data(contentsOf: url)
        input = try JSONDecoder().decode(LocalizeDictionary.self, from: data)

        guard let output = Bundle.main.url(forResource: "LocalizeKey", withExtension: "swift") else {
            throw LocalizerError("LocalizeKey.swift が見つかりませんでした。")
        }
        self.outputURL = output
    }
    
    func writeOutput() throws {
        try outputURL.write(try getOutput())
    }
    
    private func getOutput() throws -> String {
        var buffer = """
        // ### 注意 ###
        // このファイルは直接編集しないでください。
        // 文言を追加・修正したい場合はLocalizeDictionary.jsonを編集してから
        // Localizer.appを実行してください。
        
        /// バージョン\(input.version)
        public enum LocalizeKey: String {
        
        """
        
        input.dictionary.forEach { word in
            buffer += "    /// \(word.ja) / \(word.en)\n"
                    + "    case \(word.key)\n"
        }
        
        buffer += "}\n\n"
        
        return buffer
    }

}

internal struct LocalizeDictionary: Codable {
    internal let version: Int
    internal let dictionary: [LocalizeWord]
}

internal struct LocalizeWord: Codable {
    internal let key: String
    internal let en: String
    internal let ja: String
}
