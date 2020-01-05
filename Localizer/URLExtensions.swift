//
//  URLExtensions.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

extension URL {

    func write(_ text: String) throws {
        do {
            try text.write(to: self, atomically: false, encoding: .utf8)
        } catch {
            throw LocalizerError("\(self.path)への書き込みに失敗しました。 (\(error.localizedDescription))")
        }
    }
}
