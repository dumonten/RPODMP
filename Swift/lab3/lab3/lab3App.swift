//
//  lab3App.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI
import FirebaseCore

@main
struct lab3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
