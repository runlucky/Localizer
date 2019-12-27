//
//  Line.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

struct Line {
    let key: String
    let jValue: String
    let eValue: String

    init?(_ cells: [String]?) {
        guard let cells = cells else { return nil }
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
        if key.starts(with: "//") { return .comment }
        return .normal
    }

    enum Kind {
        case normal
        case comment
        case blank
        case header
    }

    var percent: Int {
        let atmark = count("%@")
        if atmark != 0 { return atmark }

        let decimal = count("%d")
        if decimal != 0 { return decimal + 100 }

        return 0
    }

    private func count(_ word: String) -> Int {
        let jCount = jValue.count(word)
        let eCount = eValue.count(word)
        guard jCount == eCount else {
            print("★エラー：\(word)の数が日本語と英語で違います。 key: \(key), japanease: \(jValue), english: \(eValue)")
            fatalError()
        }
        return jCount
    }
}
