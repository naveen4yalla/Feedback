//
//  SpringAppApp.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/11/23.
//

import SwiftUI

@main
struct SpringAppApp: App {
@StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            NavigationSplitView(sidebar: {SidebarView()}, content: {ContentView()}, detail: {DetailView()})
       
                .environment(\.managedObjectContext,dataController.container.viewContext)
                .environmentObject(dataController)
            
        }
    }
}
