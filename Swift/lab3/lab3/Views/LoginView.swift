//
//  LoginPage.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    
    @StateObject var authHandler = FirebaseAuthHandler()
    @EnvironmentObject var navigationManager: NavigationManager
      
    @State private var isLoggingIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var currentMessage: Message?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Login")
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
                    _login()
                }) {
                    HStack {
                        if isLoggingIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .foregroundColor(Color.buttonText)
                        }
                    }
                    .padding(.horizontal, 50)
                    .frame(height: 25)
                    .background(Color.button)
                    .cornerRadius(10)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.text)
                    NavigationLink(destination: RegisterView(isAuthenticated: $isAuthenticated)) {
                        Text("Register!")
                            .foregroundColor(.buttonText)
                    }
                }
                
                Spacer()
            }
            .accentColor(Color.myaccent)
            .alert(item: $currentMessage) { message in
                message.asAlert()
            }
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            UserMainView()
        }
        .onAppear {
            isLoggingIn = false
            isAuthenticated = false
            navigationManager.navigateToLogin = false
        }
    }
    
    func _login() {
        isLoggingIn = true
        isAuthenticated = false
        
        authHandler.login(email: email, password: password) { authResult, error in
            if let error = error {
                currentMessage = Message(title: "Login Error: \(error.localizedDescription)", isError: true)
            } else if (authResult?.user) != nil {
                isAuthenticated = true
            }
        }
        
        isLoggingIn = false
    }
}
