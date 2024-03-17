//
//  FirebaseAuthHandler.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import Firebase
import Combine

class FirebaseAuthHandler: ObservableObject {
    var didChange = PassthroughSubject<FirebaseAuthHandler, Never>()

    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func register(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("User created successfully: \(user.uid)")
                let ref = Database.database().reference()
                let userData = ["email": email]
                ref.child("users").child(user.uid).setValue(userData) { (error, ref) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                    }
                }
                
                FirebaseAppDataHandler.updateUserInfo(name: "", surname: "",
                                                      age: 0, dateOfBirth: "",
                                                      address: "", male: "",
                                                      phoneNumber: "", favCity: "",
                                                      favCountry: "", favorites: ["null"])
                                                      { _ in
                                                      }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }

    func quit() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
}
