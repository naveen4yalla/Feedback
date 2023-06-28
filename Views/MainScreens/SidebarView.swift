//
//  SidebarView.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/11/23.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController:DataController
    let smartFilters:[Filter] = [.all ,.recent]
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags:FetchedResults<Tag>
    var tagsFilters:[Filter] {
        tags.map { tag in
            Filter(id:tag.tagId ,name: tag.tagName, icon:"tag",tag: tag)
        }
    }
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    
    
   
    @State private var showingAwards = false
    
    var body: some View {
        List(selection:$dataController.selectedFilter){
            Section("Smart Filters"){
                ForEach(smartFilters) { filter in
                    NavigationLink(value:filter) {
                        Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
                    }
                }
                
                
            }
            
            Section("Tags"){
                ForEach(tagsFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name,systemImage: filter.icon)
                            .badge(filter.activeIssuesCount)
                        //filter.tag?.tagActiveIssues.count ?? 5)
                            .contextMenu {
                                Button {
                                    rename(filter)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    delete(filter)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel(filter.name)
                        //That uses automatic grammar agreement, which is a feature from Apple’s Foundation framework that will automatically adjust “issue” to be “issues” when there is anything other than 1 issue.

                            .accessibilityHint("\(filter.activeIssuesCount) issues")
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
        .toolbar{
#if DEBUG
            Button{
                dataController.deleteAll()
                dataController.createSampleData()
            }
        label:{
            Label("Add Samples", systemImage: "flame")
        }
#endif
            Button(action: dataController.newTag) {
                Label("Add tag", systemImage: "plus")
            }
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }
        }.alert("Rename tag", isPresented: $renamingTag) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $tagName)
        }
        
    }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
    func delete(_ filter: Filter) {
        guard let tag = filter.tag else { return }
        dataController.delete(tag)
        dataController.save()
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
