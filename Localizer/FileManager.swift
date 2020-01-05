//
//  FileManager.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

struct File {
    let japanese: URL
    let english: URL
    let definition: URL
    let csv: CSVReader

    init() throws {
        guard let jPath = Bundle.main.path(forResource: "ja-JP.lproj/Localizable", ofType: "strings") else {
            throw LocalizerError("ja-JP.lproj/Localizable.strings が見つかりませんでした。")
        }
        japanese = URL(fileURLWithPath: jPath)

        guard let ePath = Bundle.main.path(forResource: "en.lproj/Localizable", ofType: "strings") else {
            throw LocalizerError("en.lproj/Localizable.strings が見つかりませんでした。")
        }
        english = URL(fileURLWithPath: ePath)

        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "swift") else {
            throw LocalizerError("Localizable.swift が見つかりませんでした。")
        }
        definition = URL(fileURLWithPath: path)

        guard let lPath = Bundle.main.path(forResource: "Localizable", ofType: "csv") else {
            throw LocalizerError("Localizable.csv が見つかりませんでした。")
        }
        guard let stream = InputStream(fileAtPath: lPath),
              let reader = try? CSVReader(stream: stream) else {
            throw LocalizerError("Localizable.csv の読み込みに失敗しました。")
        }
        csv = reader
    }
}
