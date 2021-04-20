# TinyChat

This is possibly the smallest cloud hosted chat written in the world. It provides one common chat thread for everyone. The user logs into the chat using anonymous login with a nickname, and then can add entries to the chat thread. This program is written for MongoDB Realm using the latest SwiftUI extensions for the iOS Combine framework.

On the MongoDB Atlas side

* Create a Free Atlas Cluster. Under 'Additional Settings' select version 'MongoDB 4.4'
* Name new Atlas Cluster TinyChat
* Hit Create Cluster

Once the cluster has been created, select the Realm tab 

* Select Create a New App
* Select Mobile, iOS, No I'm starting from Scratch as your options
* Hit 'Start a new Realm App'
* Name the new Realm App 'TinyChat'
* Link it to the TinyChat cluster created above (default choice)
* Hit Create Realm Application

Set up Sync in Dev Mode

* Select Cluster to Sync 'TinyChat'
* Define a Database called 'TinyChatDB'
* Create a partition key called '_partition' as a string
* Hit 'Turn Dev Mode On'
* Deploy the Realm application

XCode Project

* Download the source code from Github
* Open generated project file
* Copy the Realm id from the top left button in the Realm panel in the web UI
* Set the Realm id in ContentView.swift

Run the app

