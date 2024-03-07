

## future

**new features**
* [ ] quiz, match words
* [ ] compress image files
* learning statistics
  * [ ] db: log learning sessions
* [ ] just in time download of tesseract tesserdata
* [ ] check database update state on startup
  * [ ] auto next-cloud sync on startup and after session

**bug-fixes**

## 0.00.006 ...

**new features**
* add support for timed notification on android

## 0.00.005

**new features**
* [x] add reverse questioning mode (answer is given, find the question)
* [x] only store doodle to database if it is not empty
* [x] tweak repetition algorithm
* [x] add button to word list, to force word into learning pool
* [x] always trim word-strings before processing them
* [x] rework start workout dialog

## 0.00.004

**new features**
* [x] open with expanded window on windows
* [x] use subfolder on nextcloud
* [x] add reset button to words list to reset correct-counter
* [x] add option to only use text if it exists (not the doodle), this would save a lot of database space
* [x] rework question table page to be more performant with huge database
* [x] rework theme integration

**bug-fixes**
* [x] clear text fields after saving new question
* [x] fix start workout dialog on android phone screen
* [x] fix overflow on workout screen for phone
* [x] fix scroll bar on new word page

## 0.00.003

**new features**
* [x] force landscape mode on android
* [x] search field in word-list-view
* [x] workout overview after finished
* [x] select different workouts
  * [x] size: 5, 10, 15, all
  * [x] legacy mode: also ask mastered words

## 0.00.002

**new features**
* [x] new workout mode, ask until correct
  * [x] also add skip button, that drops the word from queue
* [x] edit questions dialog
  * [x] also add delete function
* [x] use tesseract (on android) for ink to text

**bug-fixes**

## 0.00.001

**new features**
* [x] enter new words
* [x] workout: vocabulary test
* [x] word list
* [x] automated release script for windows + android
* [x] add created date to word and last learnedData fields to words table
* [x] basic statistics on main screen
* [x] next-cloud sync.
