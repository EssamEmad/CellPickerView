# CellPickerView
Swift UIView that enables the user to select options through a smooth UX.

## Description
CellPickerView is a UIView subclass that enables the user to select one or more options from a list of options encapsulating the selection logic and the animations away. The cells could have text, icons, or both.

## TODO
- [X] Basic functionality
- [X] Animation
- [X] Borders
- [X] Distribute through Cocoapods

## Installation

### Cocoapods

Add the following line in your Podfile

```ruby
pod 'CellPickerView'
```

## Usage

### Initialize Through Storyboard

1. Add a UIView to your view controller
2. In the right sidebar, under the identity inspector, set the class and module of the UIView to CellPickerView 
3. Drag an outlet reference into your view controller

Alternatively you can initialize the view in your view controller by instantiating it using one of the initializers

```Swift
let cellPickerView = CellPickerView()
```

* Make your view controller conform to the CellPickerDataSource protocol
```Swift
extension ViewController: CellPickerDataSource {

  func numberOfCells(inPicker picker: CellPickerView) -> Int {
     return 4
  }
  func cell(forPicker picker: CellPickerView, atIndex index: Int) -> CellAdapter {
     return CellAdapter(image: UIImage(named: "Icon")!, label: index == 0 ? "Foo")
  }
}
```
Note CellAdapter is an adapter that is used to to feed data into the picker view. You initialize ```CellAdapter``` with an icon, text, or both

* Set the dataSource of the pickerview
```Swift
cellPickerView.dataSource = self
```

* Customize the pickerView's UI if neeeded

```Swift
override func viewDidLoad(){
    cellPicker.selectionAnimation = .bubble // Animation Type
    cellPicker.cellCornerRadius = 3 // Corner radius of each cell
    cellPicker.cellBorderColor = UIColor.blue.cgColor
    cellPicker.cellBorderWidth = 2
    cellPicker.canSelectMultiple = true // Set to true if the user can select multiple cells at the same time. If set to false the user's selection will be deselected upon new selection.
    cellPicker.unselectedTextColor = UIColor.blue
    cellPicker.spacing = 8 //Spacing between 
    cellPicker.reloadData()
}
```
**Note: You must call reloadData after you customize the cellPickerView, if you set the dataSource before that, to enforce the new changes to propagate**
