//
//  ImageDownloader.swift
//  MVVMFirst
//
//  Created by Алексей on 02.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageDownloader {
    
    let cache = NSCache<NSString, UIImage>()
    
    func getImage(_ urlString: String) -> Observable<Result<UIImage, Error>> {
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ImageDownloadError.imageUrlIsNotValid))
        }
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return Observable.just(.success(cachedImage))
        }
        return URLSession.shared
            .rx
            .data(request: URLRequest(url: url))
            .map { data in
                guard let image = UIImage(data: data) else { return .failure(ImageDownloadError.dataToImageConvertingError) }
                return .success(image)
            }
            .do(onNext: { [weak self] result in
                guard let self = self,
                      let image = try? result.get()
                else { return }
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
            })
    }
}

