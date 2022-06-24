//
//  ContentView.swift
//  KeyriFirebaseDemo
//
//  Created by Aditya Malladi on 6/22/22.
//

import SwiftUI
import keyri_pod

struct ContentView: View {
    
    @State var showView = false
    @State var url: URL? = nil
    @State private var username: String = ""
    @State private var password: String = ""

    
    var body: some View {
        
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Button {
                    let scanner = Scanner()
                    scanner.completion = { str in
                        if let urlUnwrapped = URL(string: str) {
                            url = urlUnwrapped
                        }
                    }
                    scanner.show()
                } label: {
                    Text("Scan QR")
                        .font(.title2)
                        .padding()
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                
                TextField(
                    "User name (email address)",
                    text: $username
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                
                TextField(
                    "Password",
                    text: $password
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                
                Button {
                    print(username)
                    print(password)
                    
                    username = ""
                    password = ""
                    
                    if let url = url {
                        HandleQR.process(url: url, username: username, password: password)
                    }
                } label: {
                    Text("sign in")
                        .font(.title2)
                        .padding()
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .disabled(url == nil)
                
                Button {
                    print(username)
                    print(password)
                    
                    username = ""
                    password = ""
                    
                    if let url = url {
                        HandleQR.register(username: username, password: password)
                    }
                } label: {
                    Text("Register")
                        .font(.title2)
                        .padding()
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .disabled(url == nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class HandleQR {
    static func process(url: URL, username: String, password: String) {
//        let sessionId = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "sessionId" })?.value ?? ""
//        Auth.auth().signIn(withEmail: username, password: password) {  authResult, error in
//
//            let appKey = "SQzJ5JLT4sEE1zWk1EJE1ZGNfwpvnaMP" // Get this value from the Keyri Developer Portal
//            guard let payload = authResult?.user.refreshToken else { return }
//
//            let keyri = Keyri() // Be sure to import the SDK at the top of the file
//            keyri.initializeQrSession(username: username, sessionId: sessionId, appKey: appKey) { res in
//                switch res {
//                case .success(var session):
//                    // You can optionally create a custom screen and pass the session ID there. We recommend this approach for large enterprises
//                    session.payload = payload
//
//                    // In a real world example you’d wait for user confirmation first
//                    do {
//                        try session.confirm() // or session.deny()
//                    } catch {
//                        print(error)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//
//            }
//
//        }
    }
    
    static func register(username: String, password: String) {
        let keyri = Keyri()
        do {
            let key = try keyri.generateAssociationKey(username: username)
            
            let parameters = "{\n    \"nickname\": \"\(key.rawRepresentation.base64EncodedString())\"\n}"
            let postData = parameters.data(using: .utf8)

            var request = URLRequest(url: URL(string: "https://api.pingone.com/v1/environments/0930f393-9d60-4e3a-a4e1-4394197537d2/users/720cf680-ac1c-46b9-9ccd-344d78feab12")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlZmF1bHQifQ.eyJjbGllbnRfaWQiOiI2YjliYTRmMS1lZWNjLTQwNGEtODRlZC1lMDA2Mjg1NWJiNTIiLCJpc3MiOiJodHRwczovL2F1dGgucGluZ29uZS5jb20vMDkzMGYzOTMtOWQ2MC00ZTNhLWE0ZTEtNDM5NDE5NzUzN2QyL2FzIiwiaWF0IjoxNjU1NDc2NDMxLCJleHAiOjE2NTU0ODAwMzEsImF1ZCI6WyJodHRwczovL2FwaS5waW5nb25lLmNvbSJdLCJlbnYiOiIwOTMwZjM5My05ZDYwLTRlM2EtYTRlMS00Mzk0MTk3NTM3ZDIiLCJvcmciOiIwYTAwZGUzOC00Mzk0LTRiYmQtODYxZS04ZTM3MDgyN2VhODgifQ.UbPriqVuZRKFu5cQ1n5YIWss5N8n5b7C_RCY0ALyORIIBsivdxM633Iq46pScYslivTET_B0P8qj-SHmvtUHnxr58dK0Vv3asllHbPPW9bqM-w_BJsg4U9c3QInmkvJ_0O1JfGUyDlMrhyqEi0d7dOVLFr_eJwfFA8R5JWZQ4nprgEl4J_x4dT0N2VFb2dvxH2xGU9lD7sLT2GRJjaO0-Oc4h4HLh8qU0mNgp4HHmAvTpblXHrvFCFlKei7qxJlZ7DiwS9IryAkuaazCHlly9xIG81O8fwwmV63NeaHcPAw2PMLWSucwDm514WyYv8IgbR9EvIQ0Obwtetf1-tPVmA", forHTTPHeaderField: "Authorization")

            request.httpMethod = "PATCH"
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                  print(String(describing: error))
                  return
               }
               print(String(data: data, encoding: .utf8)!)
            }

            task.resume()
        } catch {
            print(error)
        }

    }

}
