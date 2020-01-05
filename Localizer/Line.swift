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

    init?(_ cells: [String]?) throws {
        guard let cells = cells else { return nil }
        guard cells.count == 3 else {
            throw LocalizerError("列数は3にしてください。 \(cells.description)")
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
        if key == "Key" && jValue == "Japanese" { return .header }
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

    func percent() throws -> Int {
        do {
            let atmark = try count("%@")
            if atmark != 0 { return atmark }

            let decimal = try count("%d")
            if decimal != 0 { return decimal + 100 }

            return 0
        } catch {
            throw error
        }
    }

    private func count(_ word: String) throws -> Int {
        let jCount = jValue.count(word)
        let eCount = eValue.count(word)
        guard jCount == eCount else {
            throw LocalizerError("\(word)の数が日本語と英語で違います。 key: \(key), japanese: \(jValue), english: \(eValue)")
        }
        return jCount
    }
}
