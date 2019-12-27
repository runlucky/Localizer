//
//  Buffer.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

class Buffer {
    private let csv: CSVReader
    private let caution = "// ### 注意 ###\n"
                        + "// このファイルは直接編集しないでください。\n"
                        + "// 文言を追加・修正したい場合はLocalizable.csvを編集してから\n"
                        + "// Localizer.appを実行してください。\n"
                        + "\n"

    private(set) var japanese: String
    private(set) var english: String
    private(set) var definition: String

    init(csv: CSVReader) {
        self.csv = csv
        self.japanese = caution
        self.english = caution
        self.definition = caution +  "internal enum Localizable {\n"
    }

    func create() {
        var lBuffer = "    internal var localize: String {\n"
                    + "        switch self {\n"

        while let line = Line(csv.next()) {
            switch line.kind {
            case .header:
                continue
            case .blank:
                japanese += "\n"
                english += "\n"
                definition += "\n"
            case .comment:
                japanese += line.key + "\n"
                english += line.key + "\n"
                definition += line.key + "\n"
            case .normal:
                japanese += "\"\(line.key)\" = \"\(line.jValue)\";\n"
                english += "\"\(line.key)\" = \"\(line.eValue)\";\n"
                definition += "    /// \(line.jValue) / \(line.eValue) \n"

                switch line.percent {
                case 0:
                    lBuffer += "        case .\(line.safeKey): return \"\(line.key)\".localize\n"
                    definition += "    case \(line.safeKey)\n"
                case 1:
                    lBuffer += "        case .\(line.safeKey)(let x1): return \"\(line.key)\".localize(arguments: [x1])\n"
                    definition += "    case \(line.safeKey)(String)\n"
                case 2:
                    lBuffer += "        case .\(line.safeKey)(let x1, let x2): return \"\(line.key)\".localize(arguments: [x1, x2])\n"
                    definition += "    case \(line.safeKey)(String, String)\n"
                case 3:
                    lBuffer += "        case .\(line.safeKey)(let x1, let x2, let x3): return \"\(line.key)\".localize(arguments: [x1, x2, x3])\n"
                    definition += "    case \(line.safeKey)(String, String, String)\n"
                case 4:
                    lBuffer += "        case .\(line.safeKey)(let x1, let x2, let x3, let x4): return \"\(line.key)\".localize(arguments: [x1, x2, x3, x4])\n"
                    definition += "    case \(line.safeKey)(String, String, String, String)\n"
                case 5:
                    lBuffer += "        case .\(line.safeKey)(let x1, let x2, let x3, let x4, let x5): return \"\(line.key)\".localize(arguments: [x1, x2, x3, x4, x5])\n"
                    definition += "    case \(line.safeKey)(String, String, String, String, String)\n"
                case 101:
                    lBuffer += "        case .\(line.safeKey)(let x1): return \"\(line.key)\".localize(arguments: [x1])\n"
                    definition += "    case \(line.safeKey)(Int)\n"
                case 102:
                    lBuffer += "        case .\(line.safeKey)(let x1, let x2): return \"\(line.key)\".localize(arguments: [x1, x2])\n"
                    definition += "    case \(line.safeKey)(Int, Int)\n"
                default:
                    print("★エラー：この%の数には対応していません。 key: \(line.key), japanese: \(line.jValue), english: \(line.eValue)")
                    fatalError()
                }
            }
        }

        lBuffer += "        case .error(let x1): return x1.localizedDescription\n"
                +  "        case .any(let x1): return x1.localize\n"
                +  "        case .localized(let x1): return x1\n"
                +  "        }\n"
                +  "    }\n"

        definition += "    /// エラー\n"
                   +  "    case error(Error)\n"
                   +  "    /// 非推奨：ローカライズ可能な文言\n"
                   +  "    case any(String)\n"
                   +  "    /// ローカライズ済み、またはローカライズ不要の文言\n"
                   +  "    case localized(String)\n"
                   +  "\n"
                   +  lBuffer
                   +  "}\n"
    }
}
