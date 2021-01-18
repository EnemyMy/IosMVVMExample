//
//  Errors.swift
//  MVVMFirst
//
//  Created by Алексей on 02.01.2021.
//

import UIKit

enum JSONDecodeError: Error {
    case jsonDecodeError
}

enum ImageDownloadError: Error {
    case imageUrlIsNotValid
    case dataToImageConvertingError
}
