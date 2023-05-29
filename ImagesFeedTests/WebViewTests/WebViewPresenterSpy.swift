//
//  WebViewPresenterSpy.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 26.05.2023.
//

@testable import ImagesFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}
    func code(from url: URL) -> String? { return nil }
}
