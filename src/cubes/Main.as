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
	import cubes.alerte.Alerte;
	import cubes.graphismes.CharteCouleurs;
	import cubes.graphismes.FormatsTextes;
	import cubes.modele.Modele;

	import decors.Bandeau;

	import widgets.boutons.Back;
	import widgets.boutons.Loop;
	import widgets.boutons.Play;
	import widgets.boutons.Valid;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;






	/**
	 * @author Joachim
	 */
	public class Main extends Sprite {
		private static const MARGE_SUP_QUESTION : Number = 20;
		private static const MARGE_LATERALE : Number = 10;
		private static const MARGE_ENTRE_CUBES : Number = 10;
		private static const LARGEUR_CUBES : Number = 200;
		private static const HAUTEUR_CUBES : Number = 70;
		private static const HAUTEUR_ZONE_DEPOT : Number = 180;
		private static const MARGE_SUP_ZONE_DEPOT : Number = 20;
		private static const LONGUEURS_SERIES_DANS_ZONE : uint = 4;
		private static const LONGUEURS_SERIES_HORS_ZONE : uint = 4;
		private static const PADDING_ZONE_DEPOT : Number = 10;
		private static const MARGE_INF_ZONE_DEPOT : Number = 20;
		private static const MARGE_INF : Number = 20;
		private static const MARGE_V_ENTRE_BOUTONS : Number = 5;
		private static const COEFF_BOUTONS : Number = 1.5;
		private static const TEXTE_SUCCES : String = "C'est exact. Passez à la question suivante !";
		private static const TEXTE_1_ELEMENT_TROP : String = "Il y a un élément en trop. ";
		private static const TEXTE_DES_ELEMENTS_TROP : String = "Il y a des éléments en trop. ";
		private static const TEXTE_1_ELEMENT_MNQ : String = "Il manque un élément. ";
		private static const TEXTE_DES_ELEMENTS_MNQ : String = "Il manque des éléments. ";
		private static const PATTERN_LIENS : RegExp = /(#)[^§]*(§)/g;
		private var bandeau : Bandeau;
		private var modele : Modele;
		private var pointeurHCube : int;
		private var pointeurVCube : int;
		private var zoneQuestion : TextField;
		private var zoneDepot : ZoneDepot;
		private var cubesDansZone : Vector.<Cube> ;
		private var cubesHorsZone : Vector.<Cube>;
		private var cubeEnDeplacement : Cube;
		private var suivant : SimpleButton;
		private var valider : SimpleButton;
		private var alerte : Alerte;
		private var zoneErreur : TextField;
		private var reinit : Loop;
		private var back : Back;
		private var notionsCapturees : Vector.<String>;
		public static const LARGEUR : uint = 950;
		public static const HAUTEUR : uint = 600;

		public function Main() {
			PoolCubes.initialiser(LARGEUR_CUBES, HAUTEUR_CUBES);
			cubesDansZone = new Vector.<Cube>();
			cubesHorsZone = new Vector.<Cube>();
			mettreBandeau();
			mettreZoneQuestion();
			mettreZoneErreurs();
			mettreZonedepot();
			mettreBoutons();
			creerModele();
			nouvelExercice();
			ecouter();
			creerAlerte();
		}

		private function creerAlerte() : void {
			alerte = new Alerte();
			addChild(alerte);
			root.addEventListener(MouseEvent.MOUSE_DOWN, masquerAlerte);
		}

		private function masquerAlerte(event : MouseEvent) : void {
			alerte.masquer();
		}

		private function mettreBoutons() : void {
			suivant = new Play();
			addChild(suivant);
			suivant.scaleX = suivant.scaleY = COEFF_BOUTONS;
			suivant.x = Main.LARGEUR - suivant.width - MARGE_LATERALE;
			suivant.y = Main.HAUTEUR - suivant.height - MARGE_INF;
			suivant.addEventListener(MouseEvent.CLICK, gererClicBoutonSuivant);
			valider = new Valid();
			valider.scaleX = valider.scaleY = COEFF_BOUTONS;
			valider.x = suivant.x;
			valider.y = suivant.y - MARGE_V_ENTRE_BOUTONS - suivant.height;
			addChild(valider);
			valider.addEventListener(MouseEvent.CLICK, gererClicBoutonValider);

			reinit = new Loop();
			reinit.scaleX = reinit.scaleY = COEFF_BOUTONS;
			reinit.x = suivant.x;
			reinit.y = valider.y - MARGE_V_ENTRE_BOUTONS - valider.height;
			addChild(reinit);
			reinit.addEventListener(MouseEvent.CLICK, gererClicBoutonReinit);

			back = new Back();
			back.scaleX = back.scaleY = COEFF_BOUTONS;
			back.x = suivant.x;
			back.y = reinit.y - MARGE_V_ENTRE_BOUTONS - reinit.height;
			addChild(back);
			back.addEventListener(MouseEvent.CLICK, gererClicBoutonBack);
		}

		private function gererClicBoutonBack(event : MouseEvent) : void {
			if (!back.enabled) return;
			nouvelExercice(true);
		}

		private function gererClicBoutonReinit(event : MouseEvent) : void {
			var c : Cube;
			var groupeAVider : Vector.<Cube> = modele.placementInitialDansZone() ? cubesHorsZone : cubesDansZone;
			while (groupeAVider.length > 0) {
				c = groupeAVider[0];
				retirerDesZones(groupeAVider[0]);
				placerCube(c, modele.placementInitialDansZone());
			}
		}

		private function gererClicBoutonValider(event : MouseEvent) : void {
			var bonneReponse : Boolean = true;
			var placementCorrect : Boolean;
			var elementsEnTrop : uint = 0;
			var elementsManquants : uint = 0;
			for each (var c : Cube in cubesDansZone) {
				placementCorrect = modele.controlerPlacement(c.id, true);
				bonneReponse = bonneReponse && placementCorrect;
				if (!placementCorrect) {
					if (modele.nbErreurs > 0)
						c.emphaserFaux();
					elementsEnTrop++;
				}
			}
			for each ( c in cubesHorsZone) {
				placementCorrect = modele.controlerPlacement(c.id, false);
				bonneReponse = bonneReponse && placementCorrect;
				if (!placementCorrect) {
					if (modele.nbErreurs > 0)
						c.emphaserFaux();
					elementsManquants++;
				}
			}
			if (bonneReponse) {
				alerte.afficher(TEXTE_SUCCES, Alerte.MESSAGE_FINAL);
			} else {
				modele.nbErreurs++;
				var message : String = "";
				if (elementsEnTrop == 1) message += TEXTE_1_ELEMENT_TROP;
				else if (elementsEnTrop > 1) message += TEXTE_DES_ELEMENTS_TROP;
				if (elementsManquants == 1) message += TEXTE_1_ELEMENT_MNQ;
				else if (elementsManquants > 1) message += TEXTE_DES_ELEMENTS_MNQ;
				alerte.afficher(message, Alerte.MESSAGE_ERREUR);
			}
			actualiserNbErreurs();
		}

		private function actualiserNbErreurs() : void {
			if (modele.nbErreurs == 0) zoneErreur.text = "";
			else if (modele.nbErreurs == 1) zoneErreur.text = modele.nbErreurs + " erreur";
			else if (modele.nbErreurs >= 2) zoneErreur.text = modele.nbErreurs + " erreurs";
			zoneErreur.visible = modele.nbErreurs > 0;
		}

		private function gererClicBoutonSuivant(event : MouseEvent) : void {
			nouvelExercice();
		}

		private function mettreZonedepot() : void {
			zoneDepot = new ZoneDepot((LONGUEURS_SERIES_DANS_ZONE + 1) * MARGE_ENTRE_CUBES + LONGUEURS_SERIES_DANS_ZONE * LARGEUR_CUBES, HAUTEUR_ZONE_DEPOT);
			zoneDepot.x = MARGE_LATERALE;
			addChild(zoneDepot);
		}

		private function mettreZoneQuestion() : void {
			zoneQuestion = new TextField();
			zoneQuestion.multiline = true;
			zoneQuestion.wordWrap = true;
			zoneQuestion.antiAliasType = AntiAliasType.ADVANCED;
			zoneQuestion.width = Main.LARGEUR - 2 * MARGE_LATERALE;
			zoneQuestion.embedFonts = true;
			zoneQuestion.defaultTextFormat = FormatsTextes.formatTexte(FormatsTextes.QUESTION);
			zoneQuestion.autoSize = TextFieldAutoSize.LEFT;
			zoneQuestion.selectable = false;
			addChild(zoneQuestion);
			zoneQuestion.y = bandeau.getBounds(this).bottom + MARGE_SUP_QUESTION;
			zoneQuestion.x = MARGE_LATERALE;
			zoneQuestion.addEventListener(TextEvent.LINK, gererClicLien);
		}

		private function gererClicLien(event : TextEvent) : void {
			alerte.afficher(modele.getLibelleElement(event.text) + " :\n" + modele.getDefinition(event.text), Alerte.MESSAGE_INFO);
		}

		private function mettreZoneErreurs() : void {
			zoneErreur = new TextField();
			zoneErreur.selectable = false;
			zoneErreur.multiline = false;
			zoneErreur.wordWrap = false;
			zoneErreur.antiAliasType = AntiAliasType.ADVANCED;
			zoneErreur.width = Main.LARGEUR;
			zoneErreur.embedFonts = true;
			zoneErreur.defaultTextFormat = FormatsTextes.formatTexte(FormatsTextes.ERREUR);
			zoneErreur.background = true;
			zoneErreur.backgroundColor = CharteCouleurs.ROUGE;
			zoneErreur.height = 26;
			zoneErreur.text = " ";
			addChild(zoneErreur);
			zoneErreur.y = Main.LARGEUR - zoneErreur.height;
			zoneErreur.x = 0;
		}

		private function ecouter() : void {
			root.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		private function gererMouseDown(event : MouseEvent) : void {
			if (event.target is Cube) {
				commencerDrag(event.target as Cube);
			}
		}

		private function commencerDrag(cube : Cube) : void {
			root.removeEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			root.addEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
			root.addEventListener(MouseEvent.MOUSE_MOVE, gererMouseMove);
			cubeEnDeplacement = cube;
			retirerDesZones(cubeEnDeplacement);
			cube.debutDrag();
		}

		private function retirerDesZones(cubeEnDeplacement : Cube) : void {
			var index : Number = cubesDansZone.indexOf(cubeEnDeplacement);

			if (index > -1) cubesDansZone.splice(index, 1);
			index = cubesHorsZone.indexOf(cubeEnDeplacement);
			if (index > -1) cubesHorsZone.splice(index, 1);
			rectifierPositions();
		}

		private function gererMouseMove(event : MouseEvent) : void {
			zoneDepot.emphaser(estDansZone(cubeEnDeplacement));
		}

		private function gererMouseUp(event : MouseEvent) : void {
			root.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			root.removeEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
			root.removeEventListener(MouseEvent.MOUSE_MOVE, gererMouseMove);
			cubeEnDeplacement.finDrag();
			placerCube(cubeEnDeplacement, estDansZone(cubeEnDeplacement));
			cubeEnDeplacement = null;
			zoneDepot.emphaser(false);
		}

		private function estDansZone(cubeEnDeplacement : Cube) : Boolean {
			return zoneDepot.hitTestPoint(cubeEnDeplacement.support.getBounds(this).left, cubeEnDeplacement.support.getBounds(this).top) && zoneDepot.hitTestPoint(cubeEnDeplacement.support.getBounds(this).right, cubeEnDeplacement.support.getBounds(this).bottom);
		}

		private function nouvelExercice(enArriere : Boolean = false) : void {
			demantelerAncienExercice();
			if (enArriere) modele.exercicePrecedent();
			else modele.exerciceSuivant();
			afficherQuestion();
			creerCubes();
			actualiserNbErreurs();
			actualiserBoutonReculer();
		}

		private function actualiserBoutonReculer() : void {
			back.enabled = modele.isBackPossible();
			back.alpha = back.enabled ? 1 : 0.75;
		}

		private function afficherQuestion() : void {
			zoneQuestion.text = ajouterLiens(modele.getQuestion());
			zoneQuestion.setTextFormat(zoneQuestion.defaultTextFormat);
			var format : TextFormat = FormatsTextes.formatTexte(FormatsTextes.LIENS_QUESTION);
			var numero : uint = 0;
			for each (var notion : String in notionsCapturees) {
				var debut : int = zoneQuestion.text.indexOf(notion);
				format.url = "event:" + modele.getIdNotion(numero);
				zoneQuestion.setTextFormat(format, debut, debut + notion.length);
				numero++;
			}
			if (zoneQuestion.numLines == 1) zoneQuestion.appendText("\n  ");

			zoneDepot.y = zoneQuestion.getBounds(this).bottom + MARGE_SUP_ZONE_DEPOT;
		}

		private function ajouterLiens(question : String) : String {
			var resultat : Array;
			if (resultat = question.match(PATTERN_LIENS)) {
				for (var i : int = 0; i < resultat.length; i++) {
					resultat[i] = resultat[i].replace(/[#§]/g, "");
				}
				notionsCapturees = Vector.<String>(resultat);
			}
			question = question.replace(/[#§]/g, "");
			return question;
		}

		private function creerCubes() : void {
			var idElements : Vector.<String> = modele.getElementsId();
			pointeurHCube = MARGE_ENTRE_CUBES;
			pointeurVCube = Main.HAUTEUR - MARGE_ENTRE_CUBES;
			for each (var id : String in idElements) {
				creerCube(id);
			}
			PoolCubes.replacerCubesInutilises();
		}

		private function creerCube(id : String) : void {
			var cube : Cube = PoolCubes.donnerCube();
			cube.id = id;
			cube.libelle = modele.getLibelleElement(id);
			cube.definition = modele.getDefinition(id);
			addChild(cube);

			if (cube.x == 0) cube.x = Main.LARGEUR / 2;
			if (cube.y == 0) cube.y = Main.HAUTEUR + 40;
			placerCube(cube, modele.placementInitialDansZone());
		}

		private function placerCube(cube : Cube, dansZone : Boolean) : void {
			var groupe : Vector.<Cube> = dansZone ? cubesDansZone : cubesHorsZone;
			var cubeEnContact : Cube = determinerCubeEnContact(cube, groupe);
			if (cubeEnContact) {
				var posCubeEnContact : uint = groupe.indexOf(cubeEnContact);
				if (cube.x > cubeEnContact.x) {
					groupe.splice(posCubeEnContact + 1, 0, cube);
				} else {
					groupe.splice(posCubeEnContact, 0, cube);
				}
			} else {
				groupe.push(cube);
			}
			rectifierPositions();
		}

		private function determinerCubeEnContact(cube : Cube, cubes : Vector.<Cube>) : Cube {
			var cubeEnContact : Cube;
			var distance : Number = 99999;
			var nouvelleDistance : Number;
			for each (var c : Cube in cubes) {
				if (c.hitTestObject(cube)) {
					nouvelleDistance = Point.distance(cube.getBounds(this).topLeft, c.getBounds(this).topLeft);
					if (nouvelleDistance < distance) {
						cubeEnContact = c;
						distance = nouvelleDistance;
					}
				}
			}
			return cubeEnContact;
		}

		private function rectifierPositions() : void {
			var xCube : Number;
			var yCube : Number;
			for (var i : int = 0; i < cubesDansZone.length; i++) {
				xCube = i % LONGUEURS_SERIES_DANS_ZONE * (LARGEUR_CUBES + MARGE_ENTRE_CUBES) + zoneDepot.x + PADDING_ZONE_DEPOT;
				yCube = Math.floor(i / LONGUEURS_SERIES_DANS_ZONE) * (HAUTEUR_CUBES + MARGE_ENTRE_CUBES) + zoneDepot.y + PADDING_ZONE_DEPOT;
				cubesDansZone[i].assignerPosition(xCube, yCube);
			}
			for ( i = 0; i < cubesHorsZone.length; i++) {
				xCube = i % LONGUEURS_SERIES_HORS_ZONE * (LARGEUR_CUBES + MARGE_ENTRE_CUBES) + zoneDepot.x ;
				yCube = Math.floor(i / LONGUEURS_SERIES_HORS_ZONE) * (HAUTEUR_CUBES + MARGE_ENTRE_CUBES) + zoneDepot.getBounds(this).bottom + MARGE_INF_ZONE_DEPOT;
				cubesHorsZone[i].assignerPosition(xCube, yCube);
			}
		}

		private function demantelerAncienExercice() : void {
			while (cubesDansZone.length > 0)
				PoolCubes.restituer(cubesDansZone.pop());
			while (cubesHorsZone.length > 0)
				PoolCubes.restituer(cubesHorsZone.pop());
			if (cubeEnDeplacement)
				PoolCubes.restituer(cubeEnDeplacement);
			cubeEnDeplacement = null;
		}

		private function creerModele() : void {
			modele = new Modele();
		}

		private function mettreBandeau() : void {
			bandeau = new BandeauAnimationCubesVab();
			addChild(bandeau);
			bandeau.x = bandeau.y = 0;
		}
	}
}
