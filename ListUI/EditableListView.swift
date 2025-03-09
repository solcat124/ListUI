//
//  SiteView.swift
//  ListUI
//
//  Created by Phil Kelly on 3/6/25.
//

// Version 1 works. It uses 2 lists, a global list and a view list. Changes to the view list are made to the global list.

/*
 A model defines a list. A user can modify the list through a view. Any changes in the view are applied to the model list.
 Supported user actions:
    Delete item (backspace, delete, or control-right-click)
    Add item (add button appearing in the list)
    Move items (drag and move)
    Change selection (report change in selection)
 
 Note: control-right-click delete deletes the row where the control-right-click takes place, which may not be the selected (highlighted) row. Backspace and delete keys remove the selected (highlighted) row.
 */

// https://www.swiftyplace.com/blog/swiftui-foreach-more-than-just-loops-in-swift

// MARK: - View Code

import SwiftUI

var heading1FontSize: CGFloat = 18
var heading2FontSize: CGFloat = 16
var headingColor: Color = .blue

/**
 Display a given item in the list.
 */
struct FruitView: View {
    @State var fruit: Fruit
    
    var body: some View {
        HStack {
            TextField("", text: $fruit.name, onCommit: {
                print(fruit.name)
                renameFruit(fruit)
            })
            Text(fruit.icon)
        }
    }
}

/**
 Display and provide user interations for the list.
 */
struct EditableListView: View {
    @State var fruits: [Fruit] = gFruits                    // the list defined in the model
    @State var selectedItem = gFruits[3]                    // selection needs to correspond to a list item
    
    var body: some View {
        VStack(alignment:.leading) {
            
            VStack(alignment: .leading) {
                Text("Available fruits")
                    .foregroundColor(headingColor)
                    .font(.system(size: heading1FontSize))
                    .padding(.top)
                Spacer()
                
                Text("Select a fruit:")
                HStack {
                    // The .onMove modifier is available on ForEach but not List: use ForEach instead.
                    List(selection: $selectedItem) {
                        ForEach(fruits, id: \.self) { fruit in                  // \.self is needed to highlight selection
                            FruitView(fruit: fruit)
                                .contextMenu {
                                    Button(action: {
                                        print("select item: \(selectedItem), item to delete item: \(fruit)")
                                        let idx = fruits.firstIndex(where: { $0 == fruit } )
                                        if idx != nil {
                                            fruits.remove(at: idx!)
                                            removeFruit(at: idx!)
                                        }
                                    }) {
                                        Text("Delete")
                                    }
                                }
                        }
                        .onMove{indices, offset in
                            withAnimation {
                                fruits.move(fromOffsets: indices, toOffset: offset)
                                reorderFruits(fruits)
                            }
                        }
                        
                        Button(action: {
                            let newItem = Fruit(name: "New Item \(fruits.count)", icon: "")
                            fruits.append(newItem)
                            addFruit(newItem)
                        }, label: {
                            Label("Add", systemImage: "plus")
                        })
                    }
                    .onDeleteCommand {
                        print("select item: \(selectedItem)")
                        let idx = fruits.firstIndex(where: { $0 == selectedItem } )
                        if idx != nil {
                            fruits.remove(at: idx!)
                            removeFruit(at: idx!)
                        }
                    }
                    .onChange(of: selectedItem) { oldSelection, newSelection in
                        selectFruit(old: oldSelection, new: newSelection)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    EditableListView()
}

//    func deleteItems(at offsets: IndexSet) {
//        fruits.remove(atOffsets: offsets)
//    }


// MARK: - Model Code

import Foundation

/**
 Report a change in the item selected.
 */
func selectFruit(old: Fruit, new: Fruit) {
    print("selected \(old.name) to \(new.name)")
}

/**
 Definition of a list item.
 */
struct Fruit: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
}

/**
 The list used in the model.
 */
var gFruits = [
    Fruit(name: "Apple", icon: "🍎"),
    Fruit(name: "Banana", icon: "🍌"),
    Fruit(name: "Orange", icon: "🍊"),
    Fruit(name: "Strawberry", icon: "🍓"),
    Fruit(name: "Blueberry", icon: "🫐" ),
]

/**
 Update the name of a given item in a model's list.
 */
func renameFruit(_ fruit: Fruit) {
    if let index = gFruits.firstIndex(where: { $0.id == fruit.id } ) {
        print("rename \(gFruits[index].name) to \(fruit.name)")
        gFruits[index].name = fruit.name
    }
    print(gFruits)
}

/**
 Remove the item in a model's list at a given index.
 */
func removeFruit(at index: Int) {
//    if let index = gFruits.firstIndex(of: fruit) {
//        gFruits.remove(at: index)
//    }
    gFruits.remove(at: index)
    print(gFruits)
}

/**
 Append an item to the model's list
 */
func addFruit(_ fruit: Fruit) {
    gFruits.append(fruit)
    print(gFruits)
}

/**
 Update the order of items in a model's list.
 */
func reorderFruits(_ fruits: [Fruit]) {
    gFruits = fruits
    print(gFruits)
}
