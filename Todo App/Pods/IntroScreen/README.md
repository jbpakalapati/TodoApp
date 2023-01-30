# IntroScreen

[![Version](https://img.shields.io/cocoapods/v/IntroScreen.svg?style=flat)](https://cocoapods.org/pods/IntroScreen)
[![License](https://img.shields.io/cocoapods/l/IntroScreen.svg?style=flat)](https://cocoapods.org/pods/IntroScreen)
[![Platform](https://img.shields.io/cocoapods/p/IntroScreen.svg?style=flat)](https://cocoapods.org/pods/IntroScreen)

A beautiful intro screen for iOS written in Swift.

![](IntroScreen.gif)

## How to use:

1. Create an `IntroDataSource` like that:

```swift
struct MyIntroDataSource: IntroDataSource {
    
    let numberOfPages = 3
    
    // Set to true, if you want to fade out the last page color into black.
    let fadeOutLastPage: Bool = false
    
    func viewController(at index: Int) -> IntroPageViewController? {
        switch index {
        case 0:
            return DefaultIntroPageViewController(
                index: index,
                hue: 30/360,
                title: "First page",
                subtitle: "This is the first page.",
                image: UIImage(named: "first")!
            )
        case 1:
            return DefaultIntroPageViewController(
                index: index,
                hue: 60/360,
                title: "Second page",
                subtitle: "This is the second page.",
                image: UIImage(named: "second")!
            )
        case 2:
            return DefaultIntroPageViewController(
                index: index,
                hue: 90/360,
                title: "Third page",
                subtitle: "This is the third page.",
                image: UIImage(named: "third")!
            )
        default:
            return nil
        }
    }
}
```
2. Create the `IntroViewController` using the data source:

```swift
let viewController = IntroViewController(dataSource: dataSource)
```

That's it! 😎

### Customization

Of course you can also use a custom view controller for the pages. Just extend `IntroPageViewController` or use a `UIViewController` that implements `IntroPage`. Keep in mind that you have to give it a clear background, so that the colors are visible.

The colors use the HSV color model. So, you just provide the hue in your Intro Pages:

```swift
public protocol IntroPage: AnyObject {
    
    // ...
    
    /// The color hue between 0 & 1 for the HSV color.
    var hue: CGFloat { get }
}
```

You can change the saturation & brightness in the IntroViewController for all pages at the same time:

```swift
let viewController = IntroViewController(
  dataSource: dataSource,
  saturation: 0.85, 
  brightness: 0.9
)
```

If you want to navigate the pages programmatically (for example if you want to add buttons for this), you can use these methods:

```swift
introViewController.nextPage() // navigate forward
introViewController.previousPage() // navigate backwards
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

IntroScreen is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IntroScreen'
```

## Author

P1xelfehler, kontakt@norman-laudien.de

## License

IntroScreen is available under the MIT license. See the LICENSE file for more info.
