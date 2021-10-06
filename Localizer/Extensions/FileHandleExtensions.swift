//
//  FileHandleExtensions.swift
//  Localizer
//
//  Created by 福田走 on 2020/01/05.
//  Copyright © 2020 Kakeru. All rights reserved.
//

import Foundation

extension FileHandle: TextOutputStream {
    public func write(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        self.write(data)
    }
}
