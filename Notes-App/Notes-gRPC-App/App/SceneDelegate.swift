//
//  SceneDelegate.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 12.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let api = API()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let notesViewModel = NotesViewModel(api: api)
        let notesView = NotesView(model: notesViewModel)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: notesView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
