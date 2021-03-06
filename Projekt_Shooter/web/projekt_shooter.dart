import 'dart:html';
import 'dart:async';
import 'shootergame/gameengine.dart';

bool gameRunning = false;
bool mouselocked = false;
GameCore gCore;

/**
 * main
 *
 * Binding gamestart to mouseclick on #startbutton
 */
void main() {
	querySelector("#startbutton").onMouseDown.listen(startGame); // set up the start-Button click event with the startGame-function
}

/**
 * startGame
 *
 * Starts game-initiation on mouseclick if game is not running yet
 */
void startGame(MouseEvent event) {
	final HtmlElement target = event.target; // the HTML-Element that has triggered the event
	if (!gameRunning) { // is the game already running?
		gameRunning = true; // if not then now it is.
		target.classes.add("disabled"); // diable start-Button
		initGame(); // start game-initialization
	}
}

/**
 * initGame
 *
 * Initializes canvas-element and the stage to draw on.
 * Then initializes the GameCore and the clock to time the gameTicks.
 * Sets up the keybindings for the game to respond to.
 */
void initGame() {
	final CanvasElement canvas = querySelector("#game"); // fetch the game-canvas-element
	final TableElement gui = querySelector("#gamegui"); // fetch the game-gui-element
	final TableCellElement healthgui = querySelector("#health");
	final TableCellElement levelgui = querySelector("#level");
	final TableCellElement ammogui = querySelector("#ammo");
	final TableCellElement scoregui = querySelector("#score");
	final ProgressElement loadgui = querySelector("#progress");
	final CanvasRenderingContext2D stage = canvas.getContext("2d"); // retreive the state of the canvas
	querySelector("body").classes.add("dark");
	canvas.classes.remove("hidden");
	gui.classes.remove("hidden");
	final Map<String,HtmlElement> gamegui = new Map<String,HtmlElement>();
	gamegui["health"] = healthgui;
	gamegui["level"] = levelgui;
	gamegui["ammo"] = ammogui;
	gamegui["score"] = scoregui;
	gamegui["progress"] = loadgui;

	gCore = new GameCore(stage, gamegui, "levels.txt"); // initialize the gamecore
	//gCore = new GameCore(stage, gamegui);

	final Timer clock = new Timer.periodic(new Duration(milliseconds:8), gameTick); // set up the gametimer
	window.animationFrame.then(drawFrame); // start drawing the game to th canvas

	// set up the keybindings for the user input
	window.onKeyUp.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.left = false;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.right = false;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.up = false;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.down = false;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = false;
		}
	});

	window.onKeyDown.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.right = false;
			gCore.player.up = false;
			gCore.player.down = false;
			gCore.player.left = true;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.left = false;
			gCore.player.up = false;
			gCore.player.down = false;
			gCore.player.right = true;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.left = false;
			gCore.player.right = false;
			gCore.player.down = false;
			gCore.player.up = true;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.left = false;
			gCore.player.right = false;
			gCore.player.up = false;
			gCore.player.down = true;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = true;
		}
	});
}

/**
 * gameTick
 *
 * Triggers an update every tick.
 */
void gameTick(Timer clock) {
	gCore.update(); // trigger an update in the gamecore
}

/**
 * drawFrame
 *
 * Triggers the drawing of a new frame.
 * On completion calls itself to draw a new frame.
 */
void drawFrame(num d) {
	if (gCore != null) {
		gCore.draw(); // draw a frame
	}
	window.animationFrame.then(drawFrame);
}
