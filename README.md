# EasyUIKit
_Library with improved UIKit components_

Pros:
* Simple and convenient API
* No boilerplate code
* SwiftUI style

## Components  
### TableView  
_Simple button_
```swift
private let simpleAccentButton = Button("Simple accent") { print("1") }
private let outline = Button("Outline", style: .outline, color: .blue, foregroundColor: .white, cornerRadius: 8, action: { print("3") })
private let ghost = Button("ghost", style: .ghost, color: .green, action: { print("4") })
```

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
* Vertical scroll view (UIScrollView + UIStackView)
_Use for create simple menu or setting style screen inside vertical scroll view_
```swift
let verticalScroll = VerticalScrollView(arrangedViews: arrayOfViews)
```
