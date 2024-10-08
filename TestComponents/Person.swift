//
//  Person.swift
//  playground
//
//  Created by Joakim Järvinen on 19.10.2024.
//
import SwiftUI

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let emailAddress: String
    let id = UUID()


    var fullName: String { givenName + " " + familyName }
}



struct PeopleTable: View {
@State private var people = [
    Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
    Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
    Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
    Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com")
]
    @State private var sortOrder = [KeyPathComparator(\Person.familyName)]
    @State private var selection: Person.ID?

    var body: some View {
        Table(people, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Given Name", value: \.givenName)
                .width(100)
            TableColumn("Family Name", value: \.familyName)
                .width(100)
            TableColumn("E-Mail Address", value: \.emailAddress)
                .width(100)
        }
    }
}

struct PeopleTableView: View {
    var body: some View {
        PeopleTable()
    }
}

struct PeopleTableView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleTableView()
    }
}
