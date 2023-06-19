//
//  IssueView.swift
//  SpringApp
//
//  Created by Naveen Yalla on 6/8/23.
//

import SwiftUI

struct IssueView: View {
    @ObservedObject var issue: Issue
    @EnvironmentObject var dataController: DataController
    
    // If the user makes a change to an issue then very quickly brings up multitasking and exits the app, we need to make sure their data is definitely safe rather than waiting a few seconds for the sleep to finish.
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                    
                }
                
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
                
                Menu {
                    // show selected tags first
                    ForEach(issue.issueTags) { tag in
                        Button {
                            issue.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }
                    
                    // now show unselected tags
                    let otherTags = dataController.missingTags(from: issue)
                    
                    if otherTags.isEmpty == false {
                        Divider()
                        
                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    issue.addToTags(tag)
                                }
                            }
                        }
                    }
                } label: {
                    Text(issue.issueTagsList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: issue.issueTagsList)
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $issue.issueContent, prompt: Text("Enter the issue description here"), axis: .vertical)
                }
            }
        }.disabled(issue.isDeleted)
        //However, that won’t actually fire at all – yes, the values inside the issue might change, but the actual issue object is staying the same and so onChange() won’t do anything.
        
        //Instead of that, we need to use onReceive() to watch for the issue announcing changes using @Published. If you remember, @Published internally calls the objectWillChange publisher that comes built into any class that conforms to ObservableObject. So, we can use onReceive() to watch that for announcements, and call queueSave() whenever a change notification comes in.
            .onReceive(issue.objectWillChange) { _ in
                dataController.queueSave()
            }
            .toolbar {
                Menu {
                    Button {
                        UIPasteboard.general.string = issue.title
                    } label: {
                        Label("Copy Issue Title", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        issue.completed.toggle()
                        dataController.save()
                    } label: {
                        Label(issue.completed ? "Re-open Issue" : "Close Issue", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                    }
                } label: {
                    Label("Actions", systemImage: "ellipsis.circle")
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
                
            }
            .onSubmit(dataController.save)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: .example)
    }
}
