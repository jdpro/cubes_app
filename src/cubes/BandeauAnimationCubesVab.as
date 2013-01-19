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
	import decors.Bandeau;

	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Joachim
	 */
	public class BandeauAnimationCubesVab extends Bandeau {
		private static const X_ZONE_TITRE : Number=150;
		private static const Y_ZONE_TITRE : Number = 25;
		private static const X_ZONE__SOUS_TITRE : Number=20;
		private static const Y_ZONE_SOUS_TITRE : Number=70;
		[Embed(source="../../assets/fonts/AlteHaasGroteskRegular.ttf", fontFamily="AlteHaasGroteskRegular", embedAsCFF=false)]
		private var AlteHaasGroteskRegular : Class;
		private static var police : Font;
		private var zoneTitre : TextField;
		private var zoneSousTitre : TextField;

		public function BandeauAnimationCubesVab() {
			police = new AlteHaasGroteskRegular();
			//creerZoneTitre();
			//creerZoneSousTitre();
		}
		private function creerZoneTitre() : void {
			zoneTitre = new TextField();
			zoneTitre.selectable = false;
			zoneTitre.embedFonts = true;
			zoneTitre.multiline = false;
			zoneTitre.wordWrap = false;
			zoneTitre.autoSize = TextFieldAutoSize.LEFT;
			zoneTitre.defaultTextFormat = new TextFormat(police.fontName, 32, 0xFFFFFF, true);
			addChild(zoneTitre);
			zoneTitre.y = Y_ZONE_TITRE;
			zoneTitre.x = X_ZONE_TITRE;
			zoneTitre.text="Du chiffre d'affaires au bénéfice";
		}
		private function creerZoneSousTitre() : void {
			zoneSousTitre = new TextField();
			zoneSousTitre.selectable = false;
			zoneSousTitre.embedFonts = true;
			zoneSousTitre.multiline = false;
			zoneSousTitre.wordWrap = false;
			zoneSousTitre.autoSize = TextFieldAutoSize.LEFT;
			zoneSousTitre.defaultTextFormat = new TextFormat(police.fontName, 18, 0x0000, true);
			addChild(zoneSousTitre);
			zoneSousTitre.y = Y_ZONE_SOUS_TITRE;
			zoneSousTitre.x = X_ZONE__SOUS_TITRE;
			zoneSousTitre.text="Sciences économiques et sociales - première ES";
		}
	}
}
