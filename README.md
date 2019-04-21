![Cocoapods Compatible](https://img.shields.io/cocoapods/v/CellPickerView.svg)
![Platform](https://img.shields.io/cocoapods/p/CellPickerView.svg)
![License](https://img.shields.io/cocoapods/l/CellPickerView.svg)

# CellPickerView
Swift UIView that enables the user to select options through a smooth UX.

## Description
CellPickerView is a UIView subclass that enables the user to select one or more options from a list of options encapsulating the selection logic and the animations away. The cells could have text, icons, or both.

## Example Preview
![Preview](https://github.com/EssamEmad/CellPickerView/blob/master/screenshots/preview.gif)
## TODO
- [X] Basic functionality
- [X] Animation
- [X] Borders
- [X] Distribute through Cocoapods
- [ ] Complex Animations
- [ ] Delegate for UI customization per cell

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
**Note: You must call ```reloadData``` after you customize the cellPickerView, if you set the dataSource before that, to enforce the new changes to propagate**

## Properties

| Property                       | Description                                                                                                                                  | Default |
|--------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|---------|
| animationDuration              | Duration of the selection animation. If selectionAnimation is set to .noAnimation this field is discarded                                    | 0.2     |
| canSelectMultiple              | Set to true if the user can select multiple cells at the same time. If set to false, the selected cell will be deselected upon new selection | true    |
| selectedTextColor              | The color of the label in the selected state                                                                                                 | white   |
| unselectedTextColor            | The color of the label in the normal state                                                                                                   | black   |
| selectedBackgroundColor        | Cell's background color in the selected state                                                                                                | blue    |
| unselectedBackgroundStateColor | Cell's background color in the normal state                                                                                                  | white   |
| maxWidth                       | If set, the value is going to be used to calculate the width of the cell. Otherwise, the cell is as big as it can get                        | nil     |
| spacing                        | Spacing between cells. Note that the left-most and the right-most cells will have 0 spacing to the borders regardless of this value.         | 0       |
| cellBorderWidth                | Width of the border of each cell                                                                                                             | 0       |
| cellBorderColor                | Color of the cell's border                                                                                                                   | nil     |
| cellCornerRadius               | Radius of the cell's corners                                                                                                                 | 0       |
| selectionAnimation             | Animation performed on selection                                                                                                             | .bubble |

## Contributions
If you have any issues or want to request new features, please create an issue. If you'd like to contribute, please submit a pull-request.
