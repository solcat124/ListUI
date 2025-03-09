//
//  SiteView.swift
//  ListUI
//
//  Created by Phil Kelly on 3/6/25.
//

// Version 3 works. It uses a class containing a list; the view code references the class.

/*
 A model defines a list. A user can modify the list through a view. Any changes in the view are applied to the model list.
 Supported odifications:
    Delete items (backspace, delete, or control-right-click)
    Add item (button appearing in the list)
    Move items (drag and move)
 
 Note: control-right-click delete deletes the row where the control-right-click takes place, which may not be the selected (highlighted) row. Backspace and delete keys remove the selected (highlighted) row.
 */

// https://www.swiftyplace.com/blog/swiftui-foreach-more-than-just-loops-in-swift

// MARK: - View Code

import SwiftUI

//var heading1FontSize: CGFloat = 18
//var heading2FontSize: CGFloat = 16
//var headingColor: Color = .blue

/**
 Display a given item in the list.
 */
struct DesertView: View {
    @State var desert: Desert
    @StateObject var desertClass = gDeserts
    
    var body: some View {
        HStack {
            TextField("", text: $desert.name, onCommit: {
                print(desert.name)
                renameDesert(desert)
            })
            Text(desert.icon)
        }
    }
}

/**
 Display and provide user interations for the list.
 */
struct EditableListView3: View {
    @StateObject var desertsClass =  gDeserts
//    @State var deserts = gDeserts.deserts                    // the list defined in the model
    @State var selectedItem = gDeserts.deserts[3]                    // selection needs to correspond to a list item
    
    var body: some View {
        VStack(alignment:.leading) {
            
            VStack(alignment: .leading) {
                Text("Available deserts")
                    .foregroundColor(headingColor)
                    .font(.system(size: heading1FontSize))
                    .padding(.top)
                Spacer()
                
                Text("Select a desert:")
                HStack {
                    // The .onMove modifier is available on ForEach but not List: use ForEach instead.
                    List(selection: $selectedItem) {
                        ForEach(desertsClass.deserts, id: \.self) { desert in                  // \.self is needed to highlight selection
                            DesertView(desert: desert)
                                .contextMenu {
                                    Button(action: {
                                        print("select item: \(selectedItem), item to delete item: \(desert)")
                                        let idx = desertsClass.deserts.firstIndex(where: { $0 == desert } )
                                        if idx != nil {
                                            desertsClass.deserts.remove(at: idx!)
                                            removeDesert(at: idx!)
                                        }
                                    }) {
                                        Text("Delete")
                                    }
                                }
                        }
                        .onMove{indices, offset in
                            withAnimation {
                                desertsClass.deserts.move(fromOffsets: indices, toOffset: offset)
                                reorderDeserts()
                            }
                        }
                        
                        Button(action: {
                            let newItem = Desert(name: "New Item \(desertsClass.deserts.count)", icon: "")
                            desertsClass.deserts.append(newItem)
                            addDesert(newItem)
                        }, label: {
                            Label("Add", systemImage: "plus")
                        })
                    }
                    .onDeleteCommand {
                        print("select item: \(selectedItem)")
                        let idx = desertsClass.deserts.firstIndex(where: { $0 == selectedItem } )
                        if idx != nil {
                            desertsClass.deserts.remove(at: idx!)
                            removeDesert(at: idx!)
                        }
                    }
                    .onChange(of: selectedItem) { oldSelection, newSelection in
                        selectedDesert(old: oldSelection, new: newSelection)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    EditableListView3()
}

//    func deleteItems(at offsets: IndexSet) {
//        deserts.remove(atOffsets: offsets)
//    }


// MARK: - Model Code

import Foundation

/**
 Definition of a list item.
 */
struct Desert: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
}

/**
 The list used in the model.
 */
class Deserts: ObservableObject {
    @Published var deserts: [Desert] = [
        Desert(name: "Strudel", icon: "🍎"),
        Desert(name: "Pie", icon: "🍌"),
        Desert(name: "Cake", icon: "🍊"),
        Desert(name: "Jello", icon: "🍓"),
        Desert(name: "Crumble", icon: "🫐" ),
    ]
}

var gDeserts = Deserts()

//var gDeserts = [
//    Desert(name: "Strudel", icon: "🍎"),
//    Desert(name: "Pie", icon: "🍌"),
//    Desert(name: "Cake", icon: "🍊"),
//    Desert(name: "Jello", icon: "🍓"),
//    Desert(name: "Crumble", icon: "🫐" ),
//]

/**
 Report a change in the item selected.
 */
func selectedDesert(old: Desert, new: Desert) {
    print("selected \(old.name) to \(new.name)")
}


/**
 Update the name of a given item in a model's list.
 */
func renameDesert(_ desert: Desert) {
    if let index = gDeserts.deserts.firstIndex(where: { $0.id == desert.id } ) {
        print("rename \(gDeserts.deserts[index].name) to \(desert.name)")
        gDeserts.deserts[index].name = desert.name
    }
    dump(gDeserts.deserts)
}

/**
 Remove the item in a model's list at a given index.
 */
func removeDesert(at index: Int) {
//    if let index = gDeserts.firstIndex(of: desert) {
//        gDeserts.remove(at: index)
//    }
//    gDeserts.remove(at: index)
    dump(gDeserts.deserts)
}

/**
 Append an item to the model's list
 */
func addDesert(_ desert: Desert) {
//    gDeserts.append(desert)
    dump(gDeserts.deserts)
}

/**
 Update the order of items in a model's list.
 */
func reorderDeserts() {
    dump(gDeserts.deserts)
}
