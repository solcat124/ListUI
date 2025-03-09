//
//  SiteView.swift
//  ListUI
//
//  Created by Phil Kelly on 3/6/25.
//

// Version 3 works. It uses a class containing a list; the view code references the class.

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
struct DessertView: View {
    @State var dessert: Dessert
    @StateObject var dessertClass = gDesserts
    
    var body: some View {
        HStack {
            TextField("", text: $dessert.name, onCommit: {
                print(dessert.name)
                renameDessert(dessert)
            })
            Text(dessert.icon)
        }
    }
}

/**
 Display and provide user interations for the list.
 */
struct EditableListView3: View {
    @StateObject var dessertsClass =  gDesserts
//    @State var desserts = gDesserts.desserts                    // the list defined in the model
    @State var selectedItem = gDesserts.desserts[3]                    // selection needs to correspond to a list item
    
    var body: some View {
        VStack(alignment:.leading) {
            
            VStack(alignment: .leading) {
                Text("Available desserts")
                    .foregroundColor(headingColor)
                    .font(.system(size: heading1FontSize))
                    .padding(.top)
                Spacer()
                
                Text("Select a dessert:")
                HStack {
                    // The .onMove modifier is available on ForEach but not List: use ForEach instead.
                    List(selection: $selectedItem) {
                        ForEach(dessertsClass.desserts, id: \.self) { dessert in                  // \.self is needed to highlight selection
                            DessertView(dessert: dessert)
                                .contextMenu {
                                    Button(action: {
                                        print("select item: \(selectedItem), item to delete item: \(dessert)")
                                        let idx = dessertsClass.desserts.firstIndex(where: { $0 == dessert } )
                                        if idx != nil {
                                            dessertsClass.desserts.remove(at: idx!)
                                            removeDessert(at: idx!)
                                        }
                                    }) {
                                        Text("Delete")
                                    }
                                }
                        }
                        .onMove{indices, offset in
                            withAnimation {
                                dessertsClass.desserts.move(fromOffsets: indices, toOffset: offset)
                                reorderDesserts()
                            }
                        }
                        
                        Button(action: {
                            let newItem = Dessert(name: "New Item \(dessertsClass.desserts.count)", icon: "")
                            dessertsClass.desserts.append(newItem)
                            addDessert(newItem)
                        }, label: {
                            Label("Add", systemImage: "plus")
                        })
                    }
                    .onDeleteCommand {
                        print("select item: \(selectedItem)")
                        let idx = dessertsClass.desserts.firstIndex(where: { $0 == selectedItem } )
                        if idx != nil {
                            dessertsClass.desserts.remove(at: idx!)
                            removeDessert(at: idx!)
                        }
                    }
                    .onChange(of: selectedItem) { oldSelection, newSelection in
                        selectedDessert(old: oldSelection, new: newSelection)
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
//        desserts.remove(atOffsets: offsets)
//    }


// MARK: - Model Code

import Foundation

/**
 Definition of a list item.
 */
struct Dessert: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
}

/**
 The list used in the model.
 */
class Desserts: ObservableObject {
    @Published var desserts: [Dessert] = [
        Dessert(name: "Strudel", icon: "🍎"),
        Dessert(name: "Pie", icon: "🍌"),
        Dessert(name: "Cake", icon: "🍊"),
        Dessert(name: "Jello", icon: "🍓"),
        Dessert(name: "Crumble", icon: "🫐" ),
    ]
}

var gDesserts = Desserts()

//var gDesserts = [
//    Dessert(name: "Strudel", icon: "🍎"),
//    Dessert(name: "Pie", icon: "🍌"),
//    Dessert(name: "Cake", icon: "🍊"),
//    Dessert(name: "Jello", icon: "🍓"),
//    Dessert(name: "Crumble", icon: "🫐" ),
//]

/**
 Report a change in the item selected.
 */
func selectedDessert(old: Dessert, new: Dessert) {
    print("selected \(old.name) to \(new.name)")
}


/**
 Update the name of a given item in a model's list.
 */
func renameDessert(_ dessert: Dessert) {
    if let index = gDesserts.desserts.firstIndex(where: { $0.id == dessert.id } ) {
        print("rename \(gDesserts.desserts[index].name) to \(dessert.name)")
        gDesserts.desserts[index].name = dessert.name
    }
    dump(gDesserts.desserts)
}

/**
 Remove the item in a model's list at a given index.
 */
func removeDessert(at index: Int) {
//    if let index = gDesserts.firstIndex(of: dessert) {
//        gDesserts.remove(at: index)
//    }
//    gDesserts.remove(at: index)
    dump(gDesserts.desserts)
}

/**
 Append an item to the model's list
 */
func addDessert(_ dessert: Dessert) {
//    gDesserts.append(dessert)
    dump(gDesserts.desserts)
}

/**
 Update the order of items in a model's list.
 */
func reorderDesserts() {
    dump(gDesserts.desserts)
}
