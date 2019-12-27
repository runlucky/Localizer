//
//  main.swift
//  Localizer
//
//  Created by H5266 on 2019/12/23.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

let file = File()

let buffer = Buffer(csv: file.csv)
buffer.create()

file.japanese.write(buffer.japanese)
file.english.write(buffer.english)
file.definition.write(buffer.definition)

print("★正常終了")
