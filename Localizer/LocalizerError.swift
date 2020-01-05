//
//  LocalizerError.swift
//  Localizer
//
//  Created by 福田走 on 2020/01/05.
//  Copyright © 2020 Kakeru. All rights reserved.
//

import Foundation

struct LocalizerError: LocalizedError {
    init(_ description: String) {
        errorDescription = description
    }
    let errorDescription: String?
}
