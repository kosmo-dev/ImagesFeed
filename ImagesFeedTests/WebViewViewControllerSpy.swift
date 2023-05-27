//
//  WebViewViewControllerSpy.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 27.05.2023.
//

@testable import ImagesFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImagesFeed.WebViewPresenterProtocol?
    var isLoadCalled = false

    func load(request: URLRequest) {
        isLoadCalled = true
    }

    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}
