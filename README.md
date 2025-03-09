# About

Example SwiftUI code to manage a list on macOS. 

Supported user actions:
- Selection. Arrow keys and mouse clicks can be used to change which item in the list is selected. (The selected list is highlighted.)
- Add an item. An *add* button appears in the list, which when clicked adds a row to the list.
- Rename an item. Clicking on the name of a list item allows the name to be edited.
- Rearrange the order. Dragging and moving lines reorders the list.
- Delete an item. Using the backspace or delete key will remove a selected item. Using control-right-click deletes the item where the click takes place, which may differ from the selected item.

# Implmentations
For demonstration purposes the list can be defined within the view code. This has the advantage of focusing on how the user actions are supported, 
but does not include details on how the list could be maintained in a "real" application. (A "real" application might deal with programmatically loading and storing a list,
or using the list in other parts of the application.) 
If the list is defined and maintained outside of the view, then some means of keeping the view and model synchronized is needed.

## Version 1
One approach is to have separate lists, a model list and a view list. 
The view list is initialized from the model list, and any changes to the view list are repeated on the model list.

## Version 2
A second approach is to have the view reference the model list. This implementation (version 2) isn't working, as the model list is updated but the view list is not.

## Version 3
A third approach is very similar to the first approach, except that the model list is defined within a class that is made observable. 
In this case the model functions that update the model list to reflect changes to the view list could be implemented as class methods.
