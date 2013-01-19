/**
 * Copyright (c) 2012 Joachim DORNBUSCH (code and design) Stéphanie Fraisse-D'Olimpio (design)
 * Cubes is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * at your option) any later version.
 * Cubes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Cubes.  If not, see <http://www.gnu.org/licenses/>.
 **/
 package cubes {
	import cubes.graphismes.CharteCouleurs;
	import cubes.graphismes.FormatsTextes;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Back;
	import fl.transitions.easing.Regular;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;



	/**
	 * @author Joachim
	 */
	public class Cube extends Sprite {
		private static const ARRONDI : Number = 30;
		private static const DUREE : uint = 12;
		private static const VITESSE : Number = 20;
		private static const MAX_ROTATIONS : uint = 10;
		private static const DUREE_ROTATION : uint = 4;
		private static const ANGLE_ROTATION : Number = 15;
		private var _id : String;
		private var _libelle : String;
		private var zoneTexte : TextField;
		private static var format : TextFormat;
		private var largeur : Number;
		private var hauteur : Number;
		private var tweenX : Tween;
		private var tweenY : Tween;
		private static var _ombre : DropShadowFilter;
		private var tweenRotation : Tween;
		private var nbRotations : int;
		private var _support : Sprite;
		private var bulleDefinition : BulleDefinition;
		private var boutonDefinition : BoutonDefinition;

		public function Cube(largeur : Number, hauteur : Number) {
			if (!_ombre) _ombre = new DropShadowFilter(8);
			this.hauteur = hauteur;
			this.largeur = largeur;
			if (!format)
				format = FormatsTextes.formatTexte(FormatsTextes.CUBES);
			mettreSupport();
			dessinerFond();
			mettreTexte();
			buttonMode = true;
			creerTweens();
			
			creerBulleDefinition();
			creerBoutonDefinition();
		}

		private function creerBoutonDefinition() : void {
			boutonDefinition = new BoutonDefinition();
			boutonDefinition.x = largeur - boutonDefinition.width;
			boutonDefinition.y = 0;
			addChild(boutonDefinition);
			boutonDefinition.addEventListener(MouseEvent.MOUSE_DOWN, gererMDBoutonDefinition);
		}

		private function gererMDBoutonDefinition(event : MouseEvent) : void {
			root.addEventListener(MouseEvent.MOUSE_UP, gererMUBoutonDefinition);
			boutonDefinition.addEventListener(MouseEvent.MOUSE_OUT, gererMUBoutonDefinition);
			mettreAuPremierPlan();
			var versLaGauche : Boolean = x + width / 2 > Main.LARGEUR / 2;
			if (versLaGauche) bulleDefinition.x = boutonDefinition.getBounds(this).left;
			else bulleDefinition.x = largeur;
			bulleDefinition.gonfler(versLaGauche);
		}

		private function gererMUBoutonDefinition(event : MouseEvent) : void {
			root.removeEventListener(MouseEvent.MOUSE_UP, gererMUBoutonDefinition);
			boutonDefinition.removeEventListener(MouseEvent.MOUSE_OUT, gererMUBoutonDefinition);
			bulleDefinition.degonfler();
		}

		private function creerBulleDefinition() : void {
			bulleDefinition = new BulleDefinition();
			addChild(bulleDefinition);
			bulleDefinition.x = largeur;
		}

		private function mettreSupport() : void {
			_support = new Sprite();
			addChild(_support);
			_support.x = largeur / 2;
			_support.mouseEnabled=false;
		}

		private function creerTweens() : void {
			tweenX = new Tween(this, "x", Back.easeOut, 0, 0, DUREE);
			tweenY = new Tween(this, "y", Back.easeOut, 0, 0, DUREE);
			tweenX.stop();
			tweenY.stop();
		}

		private function centrerTexte() : void {
			zoneTexte.y = (hauteur - zoneTexte.textHeight) / 2;
		}

		private function mettreTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.defaultTextFormat = format;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.width = largeur;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			zoneTexte.mouseEnabled=false;
			_support.addChild(zoneTexte);
			zoneTexte.x -= _support.x;
		}

		private function dessinerFond(erreur:Boolean=false) : void {
			var fillType : String = GradientType.LINEAR;
			var colors : Array;
			if (erreur)
				colors = [CharteCouleurs.ROUGE, CharteCouleurs.GRIS, CharteCouleurs.ROUGE];
			else colors = [CharteCouleurs.GRIS_CLAIR, CharteCouleurs.GRIS, CharteCouleurs.GRIS_CLAIR];
			var alphas : Array = [1, 1, 1];
			var ratios : Array = [0x00, 82, 0xFF];
			var matr : Matrix = new Matrix();
			matr.createGradientBox(largeur, hauteur, Math.PI / 4, -_support.x);
			var spreadMethod : String = SpreadMethod.PAD;
			_support.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			_support.graphics.lineStyle(1, CharteCouleurs.BLEU, 1, true);
			// graphics.beginFill(CharteCouleurs.GRIS);
			_support.graphics.drawRoundRect(-_support.x, 0, largeur, hauteur, ARRONDI);
			_support.graphics.endFill();
		}

		public function assignerPosition(xCube : Number, yCube : Number) : void {
			if (xCube == x && yCube == y) return;
			tweenX.duration = Point.distance(new Point(xCube, yCube), this.getBounds(this).topLeft) / VITESSE;
			tweenX.begin = x;
			tweenY.begin = y;
			tweenX.finish = xCube;
			tweenY.finish = yCube;
			tweenX.start();
			tweenY.start();
		}

		public function get id() : String {
			return _id;
		}

		public function set id(id : String) : void {
			_id = id;
		}

		public function set libelle(libelle : String) : void {
			_libelle = libelle;
			zoneTexte.text = libelle;
			centrerTexte();
		}

		public function ombre(boolean : Boolean) : void {
			filters = boolean ? [_ombre] : [];
		}

		public function debutDrag() : void {
			tweenX.stop();
			tweenY.stop();
			if (tweenRotation) tweenRotation.stop();
			dessinerFond(false);
			_support.rotationY = 0;
			startDrag();
			ombre(true);
			mettreAuPremierPlan();
		}

		private function mettreAuPremierPlan() : void {
			parent.setChildIndex(this, parent.numChildren - 1);
		}

		public function finDrag() : void {
			stopDrag();
			ombre(false);
		}

		public function emphaserFaux() : void {
			dessinerFond(true);
			if (!tweenRotation)
				creerTweenRotation();
			nbRotations = 0;
			tweenRotation.begin = -ANGLE_ROTATION;
			tweenRotation.finish = ANGLE_ROTATION;
			tweenRotation.start();
		}

		private function creerTweenRotation() : void {
			tweenRotation = new Tween(_support, "rotationY", Regular.easeOut, 0, 0, DUREE_ROTATION);
			tweenRotation.addEventListener(TweenEvent.MOTION_FINISH, inverserRotation);
			tweenRotation.stop();
		}

		private function inverserRotation(event : TweenEvent) : void {
			nbRotations++;
			if (nbRotations < MAX_ROTATIONS - 1) tweenRotation.yoyo();
			else if (nbRotations == MAX_ROTATIONS - 1) {
				tweenRotation.continueTo(0, DUREE_ROTATION);
				dessinerFond(false);
			} else if (nbRotations == MAX_ROTATIONS) tweenRotation.stop();
		}

		public function set definition(definition : String) : void {
			bulleDefinition.setTexte(definition);
		}

		public function get support() : Sprite {
			return _support;
		}
	}
}
