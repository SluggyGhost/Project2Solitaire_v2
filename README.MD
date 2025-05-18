
# PROGRAMMING PATTERNS
**Prototype & Subclass Sandbox**
- Used for the different groups of cards (pool.lua)
- They all have similar functionality, so I thought it fit
**State**
- Used for card shadows and suits
- I felt like suits worked well with Enums
**Update**
- Used in a few different places for card interactivity
- Card, Pool, Grabber


# FEEDBACK
**Andy Newton:**
Full Review: https://docs.google.com/document/d/1hWymCvoJDjg6Rmyo4FTewO5hTuINAkrsT2K-9uTWtnk/edit?tab=t.0
- Magic numbers used to position and size rendered objects.
    - Created more consts and put them in a separate file.
- Draw function is too long, consider using loops to simplify.
    - Simplified using loops where possible. Not possible for Tableaus for some reason.

**Tapesh Sankaran:**
Full Review: https://docs.google.com/document/d/1EDKxkA13ar_tlGKMlEYHb7S-V0QxD5xuBKLhjeWQnec/edit?tab=t.0
- Consider putting enums, color settings, and input regions into separate files
    - created a const file
- Create more enums to increase code readability
    - Now using more enums
- There are a few problems with pool.lua
    - Not enough comments; confusing to read
    - Inconsistent spacing
        - FIXED
    - Some lines can be shortened with early if-break statements
        - FIXED (I think)

**Chengkun "Kun" Li:**
Full Review: https://docs.google.com/document/d/1hr5K_HGuGjeQ-tYmRxEwSdQOCYfIIcjCDXLu9xpj10Y/edit?tab=t.0
- Pre-create the cards
    - Too much work to change this
- Add a face-up flag, to allow for face-up/face-down states in cards
    - Good change, added it in
- Make sure the window is large enough
- Add an empty deck pile image
    - Not done, but an easy fix
- Add a rank-comparison helper
    - Should have made this
- Make sure only certain cards can be grabbed
- Add more comments
- Add a win screen
    - Not enough time

# POSTMORTEM
There were a few problems with my first version of this project.
I didn't have proper structure for the different card groups (tableau, suit pile). I also struggled to create snap points and buttons.
All in all, I didn't have a strong enough framework from Project 1. There were too many things to figure out in a short timeframe. 
Had I completed the first part of this to a better standard, I would be in a much better position here. 
I'm not sure what part of this is salvagable, really. I'll probably start from scratch for project 3.

# ASSETS USED
Sprites: https://berbasoft.com/simplegametutorials/love/blackjack/
