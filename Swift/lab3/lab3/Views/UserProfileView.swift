import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserProfileView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var dateOfBirth = ""
    @State private var email = ""
    @State private var address = ""
    @State private var male = ""
    @State private var phoneNumber = ""
    @State private var favCity = ""
    @State private var favCountry = ""
    @State private var age = 0
    
    @State private var isSaving = false
    @State private var currentMessage: Message?
    @State private var isLoading = true
    @StateObject var authHandler = FirebaseAuthHandler()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Text("Loading user info, wait.")
                } else {
                    Form {
                        VStack(alignment: .leading) {
                            Label("Email", systemImage: "envelope")
                            TextField("Email", text: $email)
                                .disabled(true)
                                .background(Color.gray)
                                .foregroundColor(.black)
                        }
                        VStack(alignment: .leading) {
                            Label("Name", systemImage: "person")
                            TextField("Name", text: $name)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Surname", systemImage: "person")
                            TextField("Surname", text: $surname)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Date of Birth", systemImage: "calendar")
                            TextField("Date of Birth", text: $dateOfBirth)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Address", systemImage: "house")
                            TextField("Address", text: $address)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Male", systemImage: "person.fill")
                            TextField("Male", text: $male)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Phone number", systemImage: "phone")
                            TextField("Phone Number", text: $phoneNumber)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Favorite City", systemImage: "globe")
                            TextField("Favorite City", text: $favCity)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                        VStack(alignment: .leading) {
                            Label("Favorite Country", systemImage: "globe")
                            TextField("Favorite Country", text: $favCountry)
                                .background(Color.edit)
                                .foregroundColor(.editText)
                        }
                    }
                }
                
                Button(action: {
                    _saveInfo()
                }) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Save chages")
                                .foregroundColor(Color.buttonText)
                        }
                    }
                    .padding(.horizontal, 50)
                    .frame(height: 25)
                    .background(Color.button)
                    .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    _quit()
                }) {
                    Text("Quit")
                        .foregroundColor(Color.buttonText)
                }
                .padding(.horizontal, 50)
                .frame(height: 25)
                .background(Color.button)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
            .accentColor(Color.myaccent)
            .onAppear(perform: _loadInfo)
        }
        .alert(item: $currentMessage) { message in
            message.asAlert()
        }
    }

    private func _loadInfo() {
        FirebaseAppDataHandler.getUserInfo { userEntity, error in
            if let error = error {
                self.currentMessage = Message(title: "Loading Data Error: \(error)", isError: true)
                self.isLoading = false
            } else if let userEntity = userEntity {
                self.name = userEntity.name
                self.email = userEntity.email
                self.surname = userEntity.surname
                self.dateOfBirth = userEntity.dateOfBirthday
                self.address = userEntity.address
                self.male = userEntity.male
                self.phoneNumber = userEntity.phoneNumber
                self.favCity = userEntity.favCity
                self.favCountry = userEntity.favCountry
                self.age = userEntity.age
                
                self.isLoading = false
            } else {
                self.currentMessage = Message(title: "No user info found: \(String(describing: error))", isError: true)
                self.isLoading = false
            }
        }
    }

    private func _saveInfo() {
        isSaving = true
        
        FirebaseAppDataHandler.updateUserInfo(
            name: self.name,
            surname: self.surname,
            age: self.age,
            dateOfBirth: self.dateOfBirth,
            address: self.address,
            male: self.male,
            phoneNumber: self.phoneNumber,
            favCity: self.favCity,
            favCountry: self.favCountry,
            favorites: nil
         ) { error in
             if let error = error {
                self.currentMessage = Message(title: "Failed to update user info: \(String(describing: error))", isError: true)
             }
         }
        
        isSaving = false
    }

    private func _quit() {
        authHandler.quit()
        navigationManager.navigateToLogin = true
    }
}
