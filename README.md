### Research

I spent a while testing what happens when using the calculator in different ways.

Below are a few tests : *[button] display*

- [3] 3 [+] 3 [5] 5 [=] 8 [=] 13 [=] 18
- [4] 4 [%] 0.04
- [3] 3 [-] 3 [1] 1 [+] 2 [4] 4 [x] 4 [3] 3 [=] 14
- [4] 4 [.] 4. [5] 4.5 [+] 4.5 [3] 3 [=] 7.5

### Functionality

I spent a good chunk of time trying to get it as close to working like the original app. 

Here is what I was able to get working :

- math operations [+], [-], [x], [/]
- percent ... [4] 4 [%] 0.04
- signing ... [4] 4 [+/-] -4
- clear / all clear ... [4] 4 [c] 0 and [ac] clears last operation
- decimal ... [4] 4 [.] 4. [6] 4.6
- equals after operation ... [4] 4 [+] 4 [4] 4 [=] 8 [=] 12
- operation after operation ... [4] 4 [+] 4 [3] 3 [-] 7 [2] 2 [=] 5

I always get annoyed when I accidentally hit the wrong number while in the middle of a multiple step formula. So I choose to add a "delete" button that removes numbers if they have just been input. It does not delete if the display is a result.

- delete ... [4] 4 [5] 45 [del] 4 [del] 0

### Design & Experience

Specifications I wanted to follow :

- works for both 3.5 & 4 inch displays
- simple iOS 7 look with better touch and selected animations
- resizable font size for display (like the original app)
- design that will be dynamic for future ability to customize
- discover and use original font

My biggest design challenge was the font*(s)*. Yes, that is plural. Apple uses the Helvetica Neue family for most of there thin [fonts in iOS 7](http://iosfonts.com/). But the funny thing is the decimal point in [Helvetica Neue](http://www.myfonts.com/fonts/linotype/neue-helvetica/) is a line, not a circle. So I went about finding a good decimal and I ended up using [Avenir](http://www.myfonts.com/fonts/linotype/avenir/). The button was easy, the display was a little trickier. I setup a simple [NSMutableAttributedString](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSMutableAttributedString_Class/Reference/Reference.html) to solve the display issue.

I wanted to have a nerdy throwback. So I based the icon on [1337](http://en.wikipedia.org/wiki/Leet). When you put 1337 in a calculator and turn it upside down it spells LEET *(aka Elite)*. 

![App Icon](https://copy.com/YWvlI1fvhtiljvia)

Here are the screenshots of the calculator app that I built.

![Launch Screen](https://copy.com/9FfZjM4ukOLslBxs) ![Screen Shot](https://copy.com/EhLCPAs8VaQiPFjb) ![Screen Shot](https://copy.com/4pJ0LgoB8KE91TRY)