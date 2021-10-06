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
    let manager = try FileManager()
    try manager.writeOutput()
    
    print("★正常終了")
    exit(0)
} catch {
    var stdErr = FileHandle.standardError
    print("エラー: " + error.localizedDescription, to: &stdErr)
    exit(1)
}

