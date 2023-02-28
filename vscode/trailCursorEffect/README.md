# How get this Trail Cursor Effect in VS Code

If you want to add a trail effect to your cursor in VS Code, you can follow these steps:

## Step 1: Install DOM Modding API

Because of the extension API limit, you can't modify the VS Code DOM with an extension. Instead, you can use the [Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) extension to modify VS Code with JS and CSS. Follow the instructions in the extension's README to install it.

## Step 2: Copy the Trail Effect Dotfile

Download the `index.js` file from [my GitHub repo](https://github.com/qwreey75/dotfiles/blob/master/vscode/trailCursorEffect) and copy it to your user folder or any location you prefer. Edit the file to adjust the line height and trail color to your liking.

```js
// Line y size. (proportional to x)
const lineHeight = 2.2

// trail color (pls match it to user cursor color)
const color = "#A052FF"
```

## Step 3: Setup Settings

To apply the trail cursor effect, add the following configuration to your VS Code `settings.json` file:
```json
"vscode_custom_css.imports": [
	"file:///path/to/your/"
],
```

Replace `/path/to/your/` with the path to your `index.js` file. For best effect, use the block-style cursor instead of the stick-style cursor.
```json
"editor.cursorStyle": "block",
"editor.cursorBlinking": "phase",
"editor.cursorSmoothCaretAnimation": "on",
```

Open quick command window (Ctrl Shift P) and type `>Enable Custom CSS and JS` to apply your settings.

## Step 4: Known Issue

Please note that the trail effect may overlap with the cursor's text, and I'm currently unable to fix this issue. The z-index does not seem to work as expected.

If you find other bug or fixed some bug, Feel free to make PR!
