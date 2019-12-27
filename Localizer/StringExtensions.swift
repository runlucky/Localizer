//
//  StringExtensions.swift
//  Localizer
//
//  Created by H5266 on 2019/12/26.
//  Copyright © 2019 Kakeru. All rights reserved.
//

import Foundation

extension String {
    func count(_ word: String) -> Int {
        components(separatedBy: word).count - 1
    }
}

