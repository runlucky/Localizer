//
//  FileManager.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation


struct File {
    var japanease: URL {
        guard let path = Bundle.main.path(forResource: "ja-JP.lproj/Localizable", ofType: "strings") else {
            print("エラー： ja-JP.lproj/Localizable.strings が見つかりませんでした。")
            fatalError()
        }
        return URL(fileURLWithPath: path)
    }

    var english: URL {
        guard let path = Bundle.main.path(forResource: "en.lproj/Localizable", ofType: "strings") else {
            print("エラー： en.lproj/Localizable.strings が見つかりませんでした。")
            fatalError()
        }
        return URL(fileURLWithPath: path)
    }

    var definition: URL {
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
}
