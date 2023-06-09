//
//  IssueRow.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/26/23.
//

import SwiftUI

struct IssueRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    var body: some View {
        NavigationLink(value: issue){
            HStack{
                Image(systemName:"exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(issue.priority == 2 ? 1 : 0)
                VStack(alignment: .leading){
                    Text(issue.issueTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Text(issue.issueTagsList)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                VStack(alignment:. trailing){
                    Text(issue.issueCreationDate.formatted(date:.numeric,time: .omitted))
                        .font(.subheadline)
                    if issue.completed{
                        Text("Closed")
                            .font(.body.smallCaps())
                    }
                }.foregroundStyle(.secondary)
            }
        }
    }
}

struct IssueRow_Previews: PreviewProvider {
    static var previews: some View {
        IssueRow(issue: .example)
    }
}
