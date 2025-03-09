//
//  SiteView.swift
//  ListUI
//
//  Created by Phil Kelly on 3/6/25.
//

// Version 2 does not work properly. It references a globally-defined list; the view code references the global list.
// The global list is updated, but the view list is not.

/*
 A model defines a list. A user can modify the list through a view. Any changes in the view are applied to the model list.
 Supported user actions:
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
struct OceanView: View {
    @State var ocean: Ocean
    
    var body: some View {
        HStack {
            TextField("", text: $ocean.name, onCommit: {
                print(ocean.name)
                renameOcean(ocean)
            })
            Text(ocean.icon)
        }
    }
}

/**
 Display and provide user interations for the list.
 */
struct EditableListView2: View {
//    @State var oceans: [Ocean] = gOceans                    // the list defined in the model
    @State var selectedItem = gOceans[3]                    // selection needs to correspond to a list item
    
    var body: some View {
        VStack(alignment:.leading) {
            
            VStack(alignment: .leading) {
                Text("Available oceans")
                    .foregroundColor(headingColor)
                    .font(.system(size: heading1FontSize))
                    .padding(.top)
                Spacer()
                
                Text("Select a ocean:")
                HStack {
                    // The .onMove modifier is available on ForEach but not List: use ForEach instead.
                    List(selection: $selectedItem) {
                        ForEach(gOceans, id: \.self) { ocean in                  // \.self is needed to highlight selection
                            OceanView(ocean: ocean)
                                .contextMenu {
                                    Button(action: {
                                        print("select item: \(selectedItem), item to delete item: \(ocean)")
                                        let idx = gOceans.firstIndex(where: { $0 == ocean } )
                                        if idx != nil {
                                            gOceans.remove(at: idx!)
                                            removeOcean(at: idx!)
                                        }
                                    }) {
                                        Text("Delete")
                                    }
                                }
                        }
                        .onMove{indices, offset in
                            withAnimation {
                                gOceans.move(fromOffsets: indices, toOffset: offset)
                                reorderOceans()
                            }
                        }
                        
                        Button(action: {
                            let newItem = Ocean(name: "New Item \(gOceans.count)", icon: "")
                            gOceans.append(newItem)
                            addOcean(newItem)
                        }, label: {
                            Label("Add", systemImage: "plus")
                        })
                    }
                    .onDeleteCommand {
                        print("select item: \(selectedItem)")
                        let idx = gOceans.firstIndex(where: { $0 == selectedItem } )
                        if idx != nil {
                            gOceans.remove(at: idx!)
                            removeOcean(at: idx!)
                        }
                    }
                    .onChange(of: selectedItem) { oldSelection, newSelection in
                        selectedOcean(old: oldSelection, new: newSelection)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    EditableListView2()
}

//    func deleteItems(at offsets: IndexSet) {
//        oceans.remove(atOffsets: offsets)
//    }


// MARK: - Model Code

import Foundation

/**
 Definition of a list item.
 */
struct Ocean: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
}

/**
 The list used in the model.
 */
var gOceans = [
    Ocean(name: "Pacific", icon: "🍎"),
    Ocean(name: "Atlantic", icon: "🍌"),
    Ocean(name: "Indian", icon: "🍊"),
    Ocean(name: "Southern", icon: "🍓"),
    Ocean(name: "Artic", icon: "🫐" ),
]

/**
 Report a change in the item selected.
 */
func selectedOcean(old: Ocean, new: Ocean) {
    print("selected \(old.name) to \(new.name)")
}

/**
 Update the name of a given item in a model's list.
 */
func renameOcean(_ ocean: Ocean) {
//    if let index = gOceans.firstIndex(where: { $0.id == ocean.id } ) {
//        print("rename \(gOceans[index].name) to \(ocean.name)")
//        gOceans[index].name = ocean.name
//    }
    print(gOceans)
}

/**
 Remove the item in a model's list at a given index.
 */
func removeOcean(at index: Int) {
//    if let index = gOceans.firstIndex(of: ocean) {
//        gOceans.remove(at: index)
//    }
//    gOceans.remove(at: index)
    print(gOceans)
}

/**
 Append an item to the model's list
 */
func addOcean(_ ocean: Ocean) {
//    gOceans.append(ocean)
    print(gOceans)
}

/**
 Update the order of items in a model's list.
 */
func reorderOceans() {
    print(gOceans)
}
