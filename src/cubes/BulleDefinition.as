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
	import fl.transitions.easing.Regular;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author Joachim
	 */
	public class BulleDefinition extends Sprite {
		private static const DUREE : uint = 18;
		private static const LONGUEUR_BEC : Number=15;
		private var zoneTexte : TextField;
		private var tweenY : Tween;
		private var tweenX : Tween;
		private var versLaGauche : Boolean;
		public function BulleDefinition() {
			creerZoneTexte();
			scaleX=scaleY=0;
		}
		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = false;
			zoneTexte.defaultTextFormat= FormatsTextes.formatTexte(FormatsTextes.BULLES_DEFINITIONS);
			zoneTexte.multiline = true;
			zoneTexte.mouseEnabled = false;
			zoneTexte.wordWrap = true;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.embedFonts = true;
			zoneTexte.text = "";
			addChild(zoneTexte);
			
		}

		private function creerTween() : void {
			tweenX = new Tween(this, "scaleX", Regular.easeOut, 0, 1, DUREE);
			tweenY = new Tween(this, "scaleY", Regular.easeOut, 0, 1, DUREE);
			tweenX.stop();
			tweenY.stop();
		}

		public function setTexte(definition : String) : void {
			zoneTexte.text = definition;
			if (definition.match(/^\s*$/)) return;
			while (zoneTexte.height < zoneTexte.width)
				zoneTexte.width--;
			while (zoneTexte.height >zoneTexte.width)
				zoneTexte.width++;
			zoneTexte.y = -zoneTexte.textHeight;
			
			zoneTexte.y -= LONGUEUR_BEC;
			
			
		}

		private function dessinerFond() : void {
			scaleX=scaleY=1;
			graphics.clear();
			
			
			var rayon : Number = Point.distance(zoneTexte.getBounds(this).topLeft, zoneTexte.getBounds(this).bottomRight) / 2;
			var centre : Point = Point.interpolate(zoneTexte.getBounds(this).topLeft, zoneTexte.getBounds(this).bottomRight, 0.5);
			
			var origineBec : Point = new Point(0, 0);
			origineBec.offset(versLaGauche ? LONGUEUR_BEC :- LONGUEUR_BEC, LONGUEUR_BEC);
			var debutBec : Point = Point.polar(LONGUEUR_BEC+rayon, versLaGauche ? -Math.PI + Math.PI /6:-Math.PI /6);
			var finBec : Point = Point.polar(LONGUEUR_BEC+rayon,  versLaGauche ? -Math.PI+ 2*Math.PI /6:-2*Math.PI /6);
			debutBec.offset(origineBec.x, origineBec.y);
			finBec.offset(origineBec.x, origineBec.y);
			graphics.lineStyle(1, CharteCouleurs.BLEU, 0, true);
			graphics.beginFill(CharteCouleurs.BLEU);
			graphics.moveTo(debutBec.x, debutBec.y);
			graphics.lineTo(origineBec.x, origineBec.y);
			graphics.lineTo(finBec.x, finBec.y);
			graphics.lineStyle(1, CharteCouleurs.JAUNE, 0, true);
			graphics.lineTo(debutBec.x, debutBec.y);
			graphics.endFill();
			
			graphics.lineStyle(1, CharteCouleurs.BLEU, 0, true);
			graphics.beginFill(CharteCouleurs.BLEU);
			graphics.drawCircle(centre.x, centre.y, rayon);
			graphics.endFill();
			
			scaleX=scaleY=0;
		}

		public function degonfler() : void {
			tweenX.begin=scaleX;
			tweenY.begin = scaleY;
			tweenX.finish=0;
			tweenY.finish = 0;
			tweenX.start();
			tweenY.start();
		}

		public function gonfler(versLaGauche : Boolean) : void {
			this.versLaGauche = versLaGauche;
			if (versLaGauche) {
				zoneTexte.x = -LONGUEUR_BEC - zoneTexte.width;
			} else {
				zoneTexte.x = LONGUEUR_BEC;
			}
			dessinerFond();
			if (!tweenX) creerTween();
			visible=true;
			tweenX.begin = scaleX;
			tweenY.begin = scaleY;
			tweenX.finish=1;
			tweenY.finish = 1;
			tweenX.start();
			tweenY.start();
		}
	}
}
