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

	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	/**
	 * @author Joachim
	 */
	public class ZoneDepot extends Sprite {
		private static const ARRONDI : Number=40;
		private var largeur : Number;
		private var hauteur : Number;
		private var filtre : GlowFilter;

		public function ZoneDepot(largeur : Number, hauteur : Number) {
			this.hauteur = hauteur;
			this.largeur = largeur;
			filtre= new GlowFilter();
			dessinerFond();
		}
		private function dessinerFond() : void {
			graphics.lineStyle(2, CharteCouleurs.BLEU, 1, true);
			graphics.beginFill(CharteCouleurs.JAUNE);
			graphics.drawRoundRect(0, 0, largeur, hauteur, ARRONDI);
			graphics.endFill();
		}

		public function emphaser(bool : Boolean) : void {
			filters=bool?[filtre]:[];
		}

	}
}
