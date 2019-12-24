//
//  main.swift
//  Localizer
//
//  Created by H5266 on 2019/12/23.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

class aaa {
    var ja: URL? {
        guard let path = Bundle.main.path(forResource: "ja-JP.lproj/Localizable", ofType: "strings") else { return nil }
        return URL(fileURLWithPath: path)
    }

    var en: URL? {
        guard let path = Bundle.main.path(forResource: "en.lproj/Localizable", ofType: "strings") else { return nil }
        return URL(fileURLWithPath: path)
    }

    var swift: URL? {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "swift") else { return nil }
        return URL(fileURLWithPath: path)
    }

    var csv: String? {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "csv") else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func write(_ text: String, to: URL) {
        do {
            try text.write(to: to, atomically: false, encoding: .utf8)
        }
        catch { /* error handling here */ }
    }

    func hoge() {
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "Localizable", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)

        var jBuffer = ""
        var eBuffer = ""
        var sBuffer = "internal enum Localizable: String {\n"
            + "    internal var localize: String {\n"
            + "        self.rawValue.localize\n"
            + "    }\n"
            + "\n"


        while let row = csv.next() {
            let line = Line(row)

            switch line.kind {
            case .header:
                continue
            case .blank:
                jBuffer += "\n"
                eBuffer += "\n"
                sBuffer += "\n"
            case .comment:
                jBuffer += line.key + "\n"
                eBuffer += line.key + "\n"
                sBuffer += line.key + "\n"
            case .normal:
                jBuffer += "\"\(line.key)\" = \"\(line.jValue)\";\n"
                eBuffer += "\"\(line.key)\" = \"\(line.eValue)\";\n"
                sBuffer += "    /// \(line.jValue) / \(line.eValue) \n"
                         + "    case \(line.safeKey) = \"\(line.key)\"\n"
            }
        }

        sBuffer += "}\n"

        write(jBuffer, to: ja!)
        write(eBuffer, to: en!)
        write(sBuffer, to: swift!)
    }

}

struct Line {
    let key: String
    let jValue: String
    let eValue: String

    init(_ cells: [String]) {
        key = cells[0]
        jValue = cells[1]
        eValue = cells[2]
    }

    var safeKey: String {
        key.replacingOccurrences(
            of: #" +(.)"#,
            with: #"_$1"#,
            options: .regularExpression
        ).replacingOccurrences(
            of: #"-"#,
            with: #"_"#,
            options: .regularExpression
        )
    }

    var kind: Kind {
        if key == "Key" && jValue == "Japanease" { return .header }
        if key.isEmpty && jValue.isEmpty && eValue.isEmpty { return .blank }
        if !key.isEmpty && jValue.isEmpty && eValue.isEmpty { return .comment }
        return .normal
    }

    enum Kind {
        case normal
        case comment
        case blank
        case header
    }
}


aaa().hoge()


