//
//  ChatView.swift
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

class ChatEntry: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var name = ""
    @objc dynamic var text = ""
    @objc dynamic var createdAt: Date? = nil

    override static func primaryKey() -> String? {
        return "_id"
    }
    override static func indexedProperties() -> [String] {
        return ["createdAt"]
    }
    
    convenience init(name: String, text: String) {
        self.init()
        self.name = name
        self.text = text
        self.createdAt = Date()
    }
}

struct ChatView: View {
    @Binding var name: String
    
    var body: some View {
        ChatViewContent(name: $name).environment(\.realmConfiguration,
                                                 app!.currentUser!.configuration(partitionValue: "chat"))
    }
}


struct ChatViewContent: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    
    @State private var chatText = ""
    
    @ObservedResults(ChatEntry.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var chatEntries
    
    func addChatMessage() -> Void {
        let chatEntry = ChatEntry(name: self.name, text: self.chatText)
        $chatEntries.append(chatEntry)
        self.chatText = ""
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) -> Void {
        if let last = chatEntries.last {
            proxy.scrollTo(last._id, anchor: .bottom)
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(alignment: .leading, spacing: 5) {
                            ForEach(chatEntries) { chatEntry in
                                VStack(alignment: .leading) {
                                    Text(chatEntry.name)
                                        .foregroundColor(.gray)
                                        .font(Font.caption)
                                        .padding(.bottom)
                                    Text(chatEntry.text).font(Font.title)
                                }
                                .id(chatEntry._id)
                                .padding()
                            }

                        }
                        .onAppear() {
                            scrollToBottom(proxy: proxy)
                        }
                        .onChange(of: chatEntries.count) { _ in
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
                
               // Spacer()
                HStack(spacing: 10) {
                    TextField("Type a message", text: $chatText, onCommit: {
                        self.addChatMessage()
                       
                    })
                   .padding(10)
                   .overlay(
                       // Add the outline
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.blue, lineWidth: 2)
                   )
                    
                    Button(action: {
                        self.addChatMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .font(.largeTitle)
                }
                .padding()
                
            }
            .font(.title)
            .padding(.top, 25)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(self.name), displayMode: .inline)
        .navigationBarItems(
                // Button on the leading side
                leading:
                Button(action: {
                    if let app = app {
                        if let user = app.currentUser {
                            user.logOut(completion: { _ in
                                DispatchQueue.main.async {
                                    self.name = ""
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            })
                        }
                    }

                }) {
                    Text("Logout")
                }.accentColor(.blue)
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

