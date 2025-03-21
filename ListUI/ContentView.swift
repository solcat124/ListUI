//
//  ContentView.swift
//  ListUI
//
//  Created by Phil Kelly on 3/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        
        VStack {
            EditableListView()
        }
        .padding()

        VStack {
            EditableListView2()
        }
        .padding()

        VStack {
            EditableListView3()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
