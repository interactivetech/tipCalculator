# Pre-work - tipCalculator

tipCalculator is a tip calculator application for iOS.

Submitted by: Andrew Mendez

Time spent: 8 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
* [x] ARKit experience of viewing final bill with tip included

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://media.giphy.com/media/3o6vXSvzaBwL6m8M8M/giphy.gif' title='Calculate Tip' width='' alt='Video Walkthrough' />

<img src='https://media.giphy.com/media/l1J3DgxxW7c9gxCxi/giphy.gif' title='Change Default Tip' width='' alt='Edit Settings' />

<img src='https://thumbs.gfycat.com/BonyFrequentAsiaticlesserfreshwaterclam-size_restricted.gif' title='ARKit Experience' width='' alt='Edit Settings' />

GIF created with GIF Brewery

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:**

From my experiene with iOS dev, it is easy to get started, but it takes time and skill to master, just like any other software development paradigm. What excites me about ios development is how much control you have over the design and the user experience as a developer, and makes me wear different hats and think about my work in an interdisciplinary way.

In the view of web development IBActions are the eventlisteners for your app window. You set up connection you set up with UI element and listen to a specific event you want, like when the value has changed. IBOutlets is like a variable you create so you can use the data and information from UI elements in your code i.e. view controllers.


Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** A Strong reference cycle occurs when setting references to members. If not careful, setting a member of an instance can accidentally increase the reference count of an instance and prevent the ARC from correctly deinitalizing instances. A strong reference cycle can occur for closures due to closures being references. If you set a member of an instance to a closure, and the body of the closure refers to "self", that is another reference to an instance that prevents correct deallocation by ARC.





## License

    Copyright 2017 Andrew Mendez

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
