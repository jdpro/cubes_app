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
 package cubes.alerte {


	import cubes.Main;
	import cubes.graphismes.CharteCouleurs;
	import cubes.graphismes.FormatsTextes;
	import cubes.icones.IconeDefinition;
	import cubes.icones.IconeSourire;
	import cubes.icones.IconeTriste;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author dornbusch
	 */
	public class Alerte extends Sprite {
		private static const LARGEUR : Number = 270;
		private static const PADDING : Number = 15;
		private static const HAUTEUR_MIN : Number = 130;
		private static const RAYON_ANGLE : Number = 80;
		private static const ALPHA_MAX_FOND : Number = 0.9;
		private static const NB_PAS_BALAYAGE : uint = 8;
		private static const MARGE_DROITE : uint = 15;
		private static const MARGE_HAUTE : Number = 50;
		private static const INCREMENT_ALPHA : Number = 0.2;
		
		public static const MESSAGE_INFO : uint =0;
		public static const MESSAGE_ERREUR : uint = 1;
		public static const MESSAGE_FINAL : uint = 2;
		private static const ESPACE_V_ICONE : Number = 70;
		private static const DIMENSION_V_ICONE : Number = 60;
		private static const FOND_FAIBLE : uint = 0x70e9ea;
		private static const ERREUR : uint = 0xee293c;
		private static const JUSTE : uint = 0x36b563;
		private static const FOND_FORT : uint = 0x333333;
		
		private var zoneTexte : TextField;
		private var matrice : Matrix;
		private var hauteur : Number;
		private var colors : Array;
		private var alphas : Array;
		private var ratios : Array;
		private var tx : Number;
		private var ty : Number;
		private var ro : Number;
		private var alphaFond : Number;
		private var couleurFond : uint;
		private var supportFond : Shape;
		private var typeMessage : uint;
		private var formatTexte : TextFormat;
		private var iconeSourire : Sprite;
		private var iconeTriste : Sprite;
		private var iconeEnEcours : Sprite;
		private var couleurIcone : uint;
		private var changementCouleur : ColorTransform;
		private var iconeInfo : Sprite;

		public function Alerte() {
			creerZoneTexte();
			visible = false;
			supportFond = new Shape();
			addChildAt(supportFond, 0);
			supportFond.filters = [new BlurFilter(), new DropShadowFilter(4, 45, FOND_FAIBLE, 0.5, 10, 10)];
			matrice = new Matrix();
			y = MARGE_HAUTE;
			buttonMode = true;
			mouseChildren = false;
			changementCouleur = new ColorTransform();
			creerIcones();
		}

		private function creerIcones() : void {
			iconeSourire = creerIcone(IconeSourire);
			iconeTriste = creerIcone(IconeTriste);
			iconeInfo = creerIcone(IconeDefinition);
		}

		private function creerIcone(ClassIcone : Class) : Sprite {
			var icone : Sprite = new ClassIcone();
			addChild(icone);
			icone.visible = false;
			icone.x = icone.y = PADDING;
			icone.height = DIMENSION_V_ICONE;
			icone.scaleX = icone.scaleY;
			return icone;
		}

		private function masquerIcones() : void {
			iconeSourire.visible = iconeTriste.visible = iconeInfo.visible = false;
		}

		public function afficher(texte : String, typeMessage : uint) : void {
			parent.setChildIndex(this, parent.numChildren-1);
			this.typeMessage = typeMessage;
			determinerCouleurs();
			determineFormatTexte();
			determinerIcone();
			recolorierIcone();
			zoneTexte.text = texte;
			zoneTexte.setTextFormat(formatTexte);
			x = Main.LARGEUR - LARGEUR - PADDING - MARGE_DROITE;
			hauteur = Math.max(zoneTexte.height + ESPACE_V_ICONE, HAUTEUR_MIN + ESPACE_V_ICONE);
			visible = true;
			if (zoneTexte.height < HAUTEUR_MIN - ESPACE_V_ICONE) zoneTexte.y = (HAUTEUR_MIN - ESPACE_V_ICONE - zoneTexte.height) / 2 + PADDING + ESPACE_V_ICONE;
			else zoneTexte.y = PADDING + ESPACE_V_ICONE;
			animation();
		}

		private function determinerIcone() : void {
			masquerIcones();
			switch(typeMessage) {
				case MESSAGE_ERREUR:
					iconeEnEcours = iconeTriste;
					break;
				case MESSAGE_FINAL:
					iconeEnEcours = iconeSourire;
					break;
				case MESSAGE_INFO:
					iconeEnEcours = iconeInfo;
					break;
			}
			iconeEnEcours.visible = true;
		}

		private function recolorierIcone() : void {
			changementCouleur.color = couleurIcone;
			if (iconeEnEcours ) iconeEnEcours.transform.colorTransform = changementCouleur;
		}

		private function determineFormatTexte() : void {
			switch(typeMessage) {
				case MESSAGE_ERREUR:
					formatTexte = FormatsTextes.formatTexte(FormatsTextes.ALERTE_ERREUR);
					break;
				case MESSAGE_FINAL:
					formatTexte = FormatsTextes.formatTexte(FormatsTextes.ALERTE_FINALE);
					break;
				case MESSAGE_INFO:
					formatTexte = FormatsTextes.formatTexte(FormatsTextes.ALERTE_INFO);
					break;
			}
		}

		private function determinerCouleurs() : void {
			switch(typeMessage) {
				case MESSAGE_ERREUR:
					couleurFond = CharteCouleurs.ROUGE;
					couleurIcone = CharteCouleurs.BLANC;
					break;
				case MESSAGE_FINAL:
					couleurFond = CharteCouleurs.BLEU;
					couleurIcone = CharteCouleurs.JAUNE;
					break;
				case MESSAGE_INFO:
					couleurFond = CharteCouleurs.BLANC;
					couleurIcone = CharteCouleurs.NOIR;
					break;
			}
		}

		private function animation() : void {
			colors = [couleurFond, FOND_FORT];
			alphaFond = 0;
			ratios = [0, 0xFF];
			alphas = [INCREMENT_ALPHA, 0];
			ro = Math.PI / 4;
			modifParametres();
			addEventListener(Event.ENTER_FRAME, actualiserFond);
		}

		private function actualiserFond(event : Event) : void {
			tx += LARGEUR / NB_PAS_BALAYAGE;
			ty += hauteur / NB_PAS_BALAYAGE;
			matrice.createGradientBox(LARGEUR, hauteur, ro, tx, ty);
			dessinerFond();
			dessinerEffet();
			iconeEnEcours.alpha = alphaFond;
			zoneTexte.alpha = alphaFond;
			if (tx > LARGEUR / 2 && ty > hauteur / 2) {
				modifParametres();
			}
		}

		private function modifParametres() : void {
			if (alphaFond >= ALPHA_MAX_FOND) arreterEffet();
			alphaFond += INCREMENT_ALPHA;
			tx = -LARGEUR / 2;
			ty = -hauteur / 2;
		}

		private function arreterEffet() : void {
			removeEventListener(Event.ENTER_FRAME, actualiserFond);
			dessinerFond();
		}

		private function dessinerFond() : void {
			supportFond.graphics.clear();
			supportFond.graphics.beginFill(couleurFond, alphaFond);
			dessinerRectangle();
			supportFond.graphics.endFill();
		}

		private function dessinerRectangle() : void {
			supportFond.graphics.drawRoundRect(- PADDING, 0, LARGEUR + 2 * PADDING, hauteur + 2 * PADDING, RAYON_ANGLE);
		}

		private function dessinerEffet() : void {
			supportFond.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrice);
			dessinerRectangle();
			supportFond.graphics.endFill();
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = false;
			zoneTexte.multiline = true;
			zoneTexte.mouseEnabled = true;
			zoneTexte.wordWrap = true;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.width = LARGEUR;
			zoneTexte.embedFonts = true;
			zoneTexte.text = "";
			zoneTexte.x = 0;
			zoneTexte.y = PADDING;
			addChild(zoneTexte);
		}

		public function masquer() : void {
			visible = false;
		}
	}
}
