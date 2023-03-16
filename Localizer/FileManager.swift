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
        guard let url = Bundle.main.url(forResource: "LocalizeSource", withExtension: "json") else {
            throw LocalizerError("LocalizeSource.json が見つかりませんでした。")
        }
        
        let data = try Data(contentsOf: url)
        input = try JSONDecoder().decode(LocalizeDictionary.self, from: data)

        guard let output = Bundle.main.url(forResource: "LocalizeSource", withExtension: "swift") else {
            throw LocalizerError("LocalizeSource.swift が見つかりませんでした。")
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
        // 文言を追加・修正したい場合はLocalizeSource.jsonを編集してから
        // Localizer.appを実行してください。
        
        /// バージョン\(input.version)
        public enum LocalizeSource {
        
        """
        
        try input.dictionary.forEach { word in
            buffer += "    /// \(word.ja) / \(word.en)\n"
            buffer += try word.getDefinition()
        }
        
        buffer += """
            /// ローカライズ済み、またはローカライズ不要な文言
            case localized(String)
        
            public var localize: String {
                switch self {
        
        """
        
        try input.dictionary.forEach { word in
            buffer += try word.getLine()
        }
        
        buffer += """
                case .localized(let value): return value
                }
            }
        }
        
        extension String {
            fileprivate var localize: String {
                Localizer.shared.localize(key: self)
            }
        
            fileprivate func localize(arguments: [String]) -> String {
                Localizer.shared.localize(key: self, arguments: arguments)
            }
        }
        
        """
        
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
    
    internal func getDefinition() throws -> String {
        switch try getArguments() {
        case 0: return "    case \(key)\n"
        case 1: return "    case \(key)(String)\n"
        case 2: return "    case \(key)(String, String)\n"
        case 3: return "    case \(key)(String, String, String)\n"
        case 4: return "    case \(key)(String, String, String, String)\n"
        case 5: return "    case \(key)(String, String, String, String, String)\n"
        default: throw LocalizerError("この%@の数には対応していません。 key: \(key), japanese: \(ja), english: \(en)")
        }
    }
    internal func getLine() throws -> String {
        switch try getArguments() {
        case 0: return "        case .\(key): return \"\(key)\".localize\n"
        case 1: return "        case .\(key)(let x1): return \"\(key)\".localize(arguments: [x1])\n"
        case 2: return "        case .\(key)(let x1, let x2): return \"\(key)\".localize(arguments: [x1, x2])\n"
        case 3: return "        case .\(key)(let x1, let x2, x3): return \"\(key)\".localize(arguments: [x1, x2, x3])\n"
        case 4: return "        case .\(key)(let x1, let x2, x3, x4): return \"\(key)\".localize(arguments: [x1, x2, x3, x4])\n"
        case 5: return "        case .\(key)(let x1, let x2, x3, x4, x5): return \"\(key)\".localize(arguments: [x1, x2, x3, x4, x5])\n"
        default: throw LocalizerError("この%@の数には対応していません。 key: \(key), japanese: \(ja), english: \(en)")
        }
    }
    
    internal func getArguments() throws -> Int {
        let jaArguments = ja.count("%@")
        let enArguments = en.count("%@")
        
        if jaArguments != enArguments {
            throw LocalizerError("%@の数が日本語と英語で違います。 key: \(key), japanese: \(ja), english: \(en)")
        }
        
        return jaArguments
    }
}

extension String {
    fileprivate func count(_ word: String) -> Int {
        components(separatedBy: word).count - 1
    }
}
