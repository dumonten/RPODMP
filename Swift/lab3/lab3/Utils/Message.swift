//
//  Message.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI

class Message: Identifiable {
    var id = UUID()
    var title: String
    var isError: Bool

    init(title: String, isError: Bool) {
        self.title = title
        self.isError = isError
    }
    
    func asAlert() -> Alert {
        return Alert(title: Text(title), dismissButton: .default(Text("OK")))
    }
}
