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
    
    var body: some View {
        List(selection:$dataController.selectedFilter){
            Section("Smart Filters"){
                ForEach(smartFilters) { filter in
                    NavigationLink(value:filter) {
                        Label(filter.name,systemImage: filter.icon)
                    }
                }
                
                
            }
            
            Section("Tags"){
                ForEach(tagsFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name,systemImage: filter.icon)
                            .badge(filter.tag?.tagActiveIssues.count ?? 5)
                                //filter.tag?.tagActiveIssues.count ?? 5)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar{
            Button{
                dataController.deleteAll()
                dataController.createSampleData()
            }
        label:{
            Label("Add Samples", systemImage: "flame")
        }
        }
    }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
