# rijks.el
Admire art in emacs

## Installation

Clone the repository and load the file `rijks.el` in your `init.el`.
For example, `(load ~/.emacs.d/lisp/rijks.el/rijks.el)`.

You must set the variable `rijks-key` with a valid rijksmuseum API key in your `init.el`.

## Dependencies

- request.el
- curl
- ImageMagick

## Usage

`M-x rijks-display-random-image`

## Known Bugs

The first time `rijks-display-random-image` is called during a session the image will not be downloaded and displayed.
Calling the function again will correctly download, resize, and display an image.
