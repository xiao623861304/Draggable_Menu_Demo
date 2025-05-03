//
//  ContentView.swift
//  Draggable_Menu_Demo
//
//  Created by yan feng on 5/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            DraggableSnappingMenuBar()
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
