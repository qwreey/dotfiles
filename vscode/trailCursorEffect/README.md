https://www.reddit.com/r/vscode/comments/11e66xh/i_made_neovide_alike_cursor_effect_on_vscode/

# How get this Trail Cursor Effect in VS Code

If you want to add a trail effect to your cursor in VS Code, you can follow these steps:

## Step 1: Install DOM Modding API

Because of the extension API limit, you can't modify the VS Code DOM with an extension. Instead, you can use the [Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) extension to modify VS Code with JS and CSS. Follow the instructions in the extension's README to install it.

## Step 2: Copy the Trail Effect Dotfile

Download the `index.js` file from [my GitHub repo](https://github.com/qwreey75/dotfiles/blob/master/vscode/trailCursorEffect/index.js) and copy it to your user folder or any location you prefer. Edit the file to adjust the line height and trail color to your liking.

```js
// Set the color of the cursor trail to match the user's cursor color
const Color = "#A052FF"

// Set the style of the cursor to either a line or block
const CursorStyle = "block" // Options are 'line' or 'block'

// Set the length of the cursor trail. A higher value may cause lag.
const TrailLength = 8 // Recommended value is around 8

// Set the polling rate for handling cursor created and destroyed events, in milliseconds.
const CursorUpdatePollingRate = 500 // Recommended value is around 500
```

## Step 3: Setup Settings

To apply the trail cursor effect, add the following configuration to your VS Code `settings.json` file:
```json
"vscode_custom_css.imports": [
	"file:///path/to/your/"
],
```
Replace `/path/to/your/` with the path to your `index.js` file.

Open quick command window (Ctrl Shift P) and type `>Enable Custom CSS and JS` to apply your settings.

## Step 4: Known Issue

Please note that the trail effect may overlap with the cursor's text, and I'm currently unable to fix this issue. The z-index does not seem to work as expected.

If you find other bug or fixed some bug, Feel free to make PR!
