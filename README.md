# EasyUIKit
_Library with improved UIKit components_

Pros:
* Simple and convenient API
* No boilerplate code
* SwiftUI style

## Components  
### GalleryCollectionView  
_Horizontal 1-line collection view_
```swift
let gallery = GalleryCollectionView(height: 120, images: [UIImage(named: "a"), ...])
```
### TableView  
_Simple table view_
```swift
class SimpleViewModel { let title = "Test" }

class SimpleCell: UITableViewCell {
    let label = UILabel()
    private func setup() {
        self.addSubview(self.label)
        self.label.edgesToSuperview(excluding: .trailing, insets: .uniform(8), usingSafeArea: true)
    }
}

// ViewController:
let tv = TableView<SimpleCell, SimpleViewModel>(
    cellType: SimpleCell.self,
    viewModels: [
        SimpleViewModel(title: "Foo"),
        SimpleViewModel(title: "Bar"),
    ],
    configurationAction: { cell, vm in
        cell.label.text = vm.title
    },
    selectAction: { vm in
        print(vm.title)
    }
)
```

## Future components
* Button
```swift
// enum ButtonType { case accent, outline, ghost }

let simpleButton = Button("Test") { print("test") }

let fullySettedUpButton = Button("Run", type: .outline, color: .red, foregroundColor: .white) {
    action()
}
```
* Vertical scroll view (UIScrollView + UIStackView)
_Use for create simple menu or setting style screen inside vertical scroll view_
```swift
let verticalScroll = VerticalScrollView(arrangedViews: arrayOfViews)
```
