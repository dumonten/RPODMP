//
//  RegisterPage.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct RegisterView: View {
    @StateObject var authHandler = FirebaseAuthHandler()
   
    @Binding var isAuthenticated: Bool
    @State private var isRegistering = false
    @State private var email = ""
    @State private var password = ""
    @State private var currentMessage: Message?

    var body: some View {
        NavigationView {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .foregroundColor(.text)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.edit)
                    .foregroundColor(.editText)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.edit)
                    .foregroundColor(.editText)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    _register()
                }) {
                    HStack {
                        if isRegistering {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Register")
                                .foregroundColor(Color.buttonText)
                        }
                    }
                    .padding(.horizontal, 50)
                    .frame(height: 25)
                    .background(Color.button)
                    .cornerRadius(10)
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .accentColor(Color.myaccent)
            .alert(item: $currentMessage) { message in
                message.asAlert()
            }
        }
        .onAppear {
            isRegistering = false
            isAuthenticated = false
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            UserMainView()
        }
    }
    
    func _register() {
        isRegistering = true
        
        authHandler.register(email: email, password: password) { authResult, error in
            if let error = error {
                currentMessage = Message(title: "Register Error: \(error.localizedDescription)", isError: true)
            } else if (authResult?.user) != nil {
                    isAuthenticated = true
            }
        }
        isRegistering = false 
    }
}
