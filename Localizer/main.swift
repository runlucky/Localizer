//
//  main.swift
//  Localizer
//
//  Created by H5266 on 2019/12/23.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation
import Darwin

do {
    let file = try File()

    let buffer = Buffer(csv: file.csv)
    try buffer.create()

    try file.japanese.write(buffer.japanese)
    try file.english.write(buffer.english)
    try file.definition.write(buffer.definition)

    print("★正常終了")
    exit(0)
} catch {
    var stdErr = FileHandle.standardError
    print("エラー: " + error.localizedDescription, to: &stdErr)
    exit(1)
}

