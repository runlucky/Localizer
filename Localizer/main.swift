//
//  main.swift
//  Localizer
//
//  Created by H5266 on 2019/12/23.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

class aaa {
    var jFile: URL {
        guard let path = Bundle.main.path(forResource: "ja-JP.lproj/Localizable", ofType: "strings") else {
            print("エラー： ja-JP.lproj/Localizable.strings が見つかりませんでした。")
            fatalError()
        }
        return URL(fileURLWithPath: path)
    }

    var eFile: URL {
        guard let path = Bundle.main.path(forResource: "en.lproj/Localizable", ofType: "strings") else {
            print("エラー： en.lproj/Localizable.strings が見つかりませんでした。")
            fatalError()
        }
        return URL(fileURLWithPath: path)
    }

    var sFile: URL {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "swift") else {
            print("エラー： Localizable.swift が見つかりませんでした。")
            fatalError()
        }
        return URL(fileURLWithPath: path)
    }

    var csv: CSVReader {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "csv") else {
            print("エラー： Localizable.csv が見つかりませんでした。")
            fatalError()
        }

        guard let stream = InputStream(fileAtPath: path),
              let reader = try? CSVReader(stream: stream) else {
                print("エラー： Localizable.csv の読み込みに失敗しました。")
                fatalError()
        }
        return reader
    }

    func write(_ text: String, to: URL) {
        do {
            try text.write(to: to, atomically: false, encoding: .utf8)
        }
        catch { /* error handling here */ }
    }

    let caution = "// ### 注意 ###\n"
        + "// このファイルは直接編集しないでください。\n"
        + "// 文言を追加・修正したい場合はLocalizable.csvを編集してから\n"
        + "// Localizer.appを実行してください。\n"
        + "\n"

    func hoge() {

        var jBuffer = caution
        var eBuffer = caution
        var sBuffer = caution + "internal enum Localizable: String {\n"
            + "    internal var localize: String {\n"
            + "        self.rawValue.localize\n"
            + "    }\n"
            + "\n"

        let csvReader = csv
        while let row = csvReader.next() {
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
                        +  "    case \(line.safeKey) = \"\(line.key)\"\n"
            }
        }

        sBuffer += "}\n"

        write(jBuffer, to: jFile)
        write(eBuffer, to: eFile)
        write(sBuffer, to: sFile)

        print("★正常終了")
    }

}

struct Line {
    let key: String
    let jValue: String
    let eValue: String

    init(_ cells: [String]) {
        guard cells.count == 3 else {
            print("★エラー：列数は3にしてください。 \(cells.description)")
            fatalError()
        }
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
