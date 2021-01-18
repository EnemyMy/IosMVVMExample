//
//  AlertPublisherHolder.swift
//  MVVMFirst
//
//  Created by Алексей on 08.01.2021.
//

import RxRelay

protocol AlertPublisherHolder {
    var alertPublisher: PublishRelay<AlertData> { get }
}

protocol ActivityIndicatorPublisherHolder {
    var activityIndicatorPusblisher: PublishRelay<ActivityIndicatorData> { get }
}
