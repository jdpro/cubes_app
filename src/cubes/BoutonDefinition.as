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
	import cubes.icones.IconeDefinition;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 * @author Joachim
	 */
	public class BoutonDefinition extends Sprite {
		private static const RAYON : Number = 10;
		private var icone : IconeDefinition;
		private var couleurIcone : uint;
		private var couleurFond : uint;
		private var coloration : ColorTransform;
		public function BoutonDefinition() {
			ajouterIcone();
			addEventListener(MouseEvent.MOUSE_OVER, gererMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
			gererMouseOut(null);
			mouseChildren=false;
		}

		private function gererMouseOut(event : MouseEvent) : void {
			couleurFond = CharteCouleurs.BLEU;
			couleurIcone = CharteCouleurs.BLANC;
			dessinerFond();
		}

		private function gererMouseOver(event : MouseEvent) : void {
			couleurFond = CharteCouleurs.JAUNE;
			couleurIcone = CharteCouleurs.NOIR;
			dessinerFond();
		}

		private function ajouterIcone() : void {
			icone = new IconeDefinition();
			icone.height=15;
			icone.scaleX = icone.scaleY;
			icone.x = (2 * RAYON - icone.width)/2;
			icone.y = (2 * RAYON - icone.height)/2;
			addChild(icone);
			coloration = new ColorTransform();
		}
		private function dessinerFond() : void {
			graphics.clear();
			graphics.lineStyle(1, CharteCouleurs.BLEU, 1, true);
			graphics.beginFill(couleurFond);
			graphics.drawCircle(RAYON, RAYON, RAYON);
			graphics.endFill();
			coloration.color = couleurIcone;
			icone.transform.colorTransform = coloration;
		}

	}
}
