//
//  ContentView.swift
//  TinyChat
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//  Created by Richard Krueger on 4/19/21.
//

import SwiftUI
import RealmSwift

let app: RealmSwift.App? = RealmSwift.App(id: "tinychat-vwhsb")

struct ContentView: View {
    @State private var name = ""
    @State private var showingAlert = false
    @State private var showingChat = false
    @State private var isLoggingIn = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Text("Tiny Chat")
                    .font(.largeTitle)
                    .padding(.vertical)
                
                Spacer()
                TextField("Name", text: $name)
                    .font(.title)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
                
                NavigationLink(destination: ChatView(name: $name), isActive: $showingChat)
                    {  }
                if isLoggingIn {
                    ProgressView()
                }
                Spacer()
                Button(action: {
                    if name == "" {
                        showingAlert = true
                    } else {
                        
                        isLoggingIn = true
                        if let app = app {
                            app.login(credentials: .anonymous) { result in
                                isLoggingIn = false

                                showingChat = true
                            }
                        }

                    }
                    
                }) {
                    Text("Chat")
                        .padding(.horizontal)
                    Image(systemName: "arrow.right.square")
                }
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text("Name cannot be empty"), dismissButton: .default(Text("OK")))
                        }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.green)
                .cornerRadius(8)
                
                Spacer()
            }
        }

    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
