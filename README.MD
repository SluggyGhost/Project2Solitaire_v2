
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
- Draw function is too long, consider using loops to simplify.

**Tapesh Sankaran:**
Full Review: https://docs.google.com/document/d/1EDKxkA13ar_tlGKMlEYHb7S-V0QxD5xuBKLhjeWQnec/edit?tab=t.0
- Consider putting enums, color settings, and input regions into separate files
- Create more enums to increase code readability
- There are a few problems with pool.lua
    - Not enough comments; confusing to read
    - Inconsistent spacing
    - Some lines can be shortened with early if-break statements

**Chengkun "Kun" Li:**
Full Review: https://docs.google.com/document/d/1hr5K_HGuGjeQ-tYmRxEwSdQOCYfIIcjCDXLu9xpj10Y/edit?tab=t.0
- Pre-create the cards
- Add a face-up flag, to allow for face-up/face-down states in cards
- Make sure the window is large enough
- Add an empty deck pile image
- Add a rank-comparison helper
- Make sure only certain cards can be grabbed
- Add more comments
- Add a win screen

# POSTMORTEM
There were a few problems with my first version of this project.
I didn't have proper structure for the different card groups (tableau, suit pile). I also struggled to create snap points and buttons.

# ASSETS USED
Sprites: https://berbasoft.com/simplegametutorials/love/blackjack/
