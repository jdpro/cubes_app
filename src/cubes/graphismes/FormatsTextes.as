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
 package cubes.graphismes {
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author Joachim
	 */
	public class FormatsTextes {
		[Embed(source="../../../assets/fonts/ARLRDBD.TTF", fontFamily="ArialRounded", embedAsCFF=false)]
		private static var ArialRounded : Class;
		private static var police1 : Font;
		[Embed(source="../../../assets/fonts/KOMON___.TTF", fontFamily="KOMON", embedAsCFF=false)]
		private static var Komon : Class;
		private static var police0 : Font;
		public static const CUBES : String = "BASE";
		public static const QUESTION : String = "QUESTION";
		public static const ALERTE_FINALE : String = "ALERTE_FINALE";
		public static const ALERTE_ERREUR : String = "ALERTE_ERREUR";
		public static const BULLES_DEFINITIONS : String = "BULLES_DEFINITIONS";
		public static const ERREUR : String = "ERREUR";
		public static const LIENS_QUESTION : String = "LIENS_QUESTION";
		public static const ALERTE_INFO : String = "ALERTE_INFO";

		public static function formatTexte(cle : String) : TextFormat {
			if (!police1) police1 = Font(new ArialRounded());
			if (!police0) police0 = Font(new Komon());

			switch(cle) {
				case CUBES:
					return new TextFormat(FormatsTextes.police1.fontName, 18, CharteCouleurs.BLEU, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case QUESTION:
					return new TextFormat(FormatsTextes.police1.fontName, 28, CharteCouleurs.NOIR, null, null, null, null, null, TextFormatAlign.LEFT);
					break;
				case LIENS_QUESTION:
					return new TextFormat(FormatsTextes.police1.fontName, 28, CharteCouleurs.BLEU, null, null, true, "event:lien", null, TextFormatAlign.LEFT);
					break;
				case ERREUR:
					return new TextFormat(FormatsTextes.police0.fontName, 22, CharteCouleurs.BLANC, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case ALERTE_ERREUR:
					return new TextFormat(FormatsTextes.police1.fontName, 28, CharteCouleurs.BLANC, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case ALERTE_FINALE:
					return new TextFormat(FormatsTextes.police1.fontName, 28, CharteCouleurs.BLANC, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case ALERTE_INFO:
					return new TextFormat(FormatsTextes.police1.fontName, 18, CharteCouleurs.NOIR, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case BULLES_DEFINITIONS:
					return new TextFormat(FormatsTextes.police1.fontName, 18, CharteCouleurs.JAUNE, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
			}
			return null;
		}
	}
}
