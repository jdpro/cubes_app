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
 package cubes.modele {
	import utils.melanger;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author Joachim
	 */
	public class Modele extends EventDispatcher {
		private static const MAX_ESSAIS : uint = 100;
		private var racine : Agregat;
		private var typeExercice : uint;
		private var pileExercices : Vector.<Exercice> ;
		private var pointeurExercice : int;
		private static const EXERCICE_CONSTRUCTION : uint = 0;
		private static const EXERCICE_DECONSTRUCTION : uint = 1;
		private var _nbErreurs : int;
		private var tousExercicesGeneres : Boolean;
		private var idNotions : Vector.<String>;

		public function Modele(target : IEventDispatcher = null) {
			super(target);
			idNotions= new Vector.<String>();
			tousExercicesGeneres = false;
			pointeurExercice = -1;
			pileExercices = new Vector.<Exercice>();
			analyserDonnees();
		}

		private function analyserDonnees() : void {
			racine = Donnees.analyser();
		}

		private function genererExercice() : Boolean {
			var nouvelExercice : Exercice;
			var profondeurQuestion : uint ;
			var profondeurDecomposition : uint ;
			var profondeurCible : uint ;
			var compteurEssais : uint = 0;
			typeExercice = typeExercice == EXERCICE_DECONSTRUCTION ? EXERCICE_CONSTRUCTION : EXERCICE_DECONSTRUCTION;
			do {
				if (compteurEssais > 10) typeExercice = compteurEssais % 2;
				switch(typeExercice) {
					case EXERCICE_CONSTRUCTION:
						profondeurQuestion = Math.random() * (racine.getProfondeur() - 1);
						profondeurDecomposition = profondeurQuestion + Math.random() * (racine.getProfondeur() - profondeurQuestion - 1) + 1;
						nouvelExercice = new ExerciceConstruction(profondeurQuestion, profondeurDecomposition);
						break;
					case EXERCICE_DECONSTRUCTION:
						profondeurQuestion = Math.random() * (racine.getProfondeur() - 2);
						profondeurCible = profondeurQuestion + Math.random() * (racine.getProfondeur() - profondeurQuestion - 3) + 1 ;
						profondeurDecomposition = profondeurCible + Math.random() * (racine.getProfondeur() - profondeurCible - 2) + 1;
						nouvelExercice = new ExerciceDeconstruction(profondeurQuestion, profondeurCible, profondeurDecomposition);
						break;
				}
				compteurEssais++;
			} while (exerciceDejaDonne(nouvelExercice) && compteurEssais < MAX_ESSAIS);
			if (compteurEssais < MAX_ESSAIS) pileExercices.push(nouvelExercice);
			return compteurEssais < MAX_ESSAIS;
		}

		private function exerciceDejaDonne(nouveau : Exercice) : Boolean {
			for each (var e : Exercice in pileExercices) {
				if (e.profondeurDecomposition != nouveau.profondeurDecomposition) continue;
				if (e.profondeurQuestion != nouveau.profondeurQuestion) continue;
				if (e is ExerciceConstruction && nouveau is ExerciceConstruction) {
					return true;
				}
				if (e is ExerciceDeconstruction && nouveau is ExerciceDeconstruction) {
					if ((e as ExerciceDeconstruction).profondeurObjectif == (nouveau as ExerciceDeconstruction).profondeurObjectif)
						return true;
				}
			}
			return false;
		}

		public function getQuestion() : String {
			var elementQuestion : Agregat = racine.getDescendantPrincipal(pileExercices[pointeurExercice].profondeurQuestion);
			idNotions[0] = elementQuestion.id;
			var libelleQuestion : String;
			var libelleCible : String;
			if (pileExercices[pointeurExercice] is ExerciceConstruction) {
				libelleQuestion = elementQuestion.libelle;
				if (!elementQuestion.majusculeObligatoire)
					libelleQuestion = libelleQuestion.toLowerCase();
					idNotions[1]=null;
				return ("Placez dans la zone colorée tout ce qui entre dans " + elementQuestion.article + " #" + libelleQuestion+"§");
			} else {
				var elementCible : Agregat = racine.getDescendantPrincipal((pileExercices[pointeurExercice] as ExerciceDeconstruction).profondeurObjectif);
				idNotions[1] = elementCible.id;
				libelleQuestion = elementQuestion.libelle;
				libelleCible = elementCible.libelle;
				if (!elementQuestion.majusculeObligatoire)
					libelleQuestion = libelleQuestion.toLowerCase();
				if (!elementCible.majusculeObligatoire)
					libelleCible = libelleCible.toLowerCase();
				return ("La zone colorée contient " + elementQuestion.article + " #" + libelleQuestion+"§" + " : retirez des éléments pour obtenir " + elementCible.article + " #" + libelleCible +"§");
			}
		}

		public function getElementsId() : Vector.<String> {
			var pointDeDepart : Number = pileExercices[pointeurExercice] is ExerciceConstruction ? 0 : pileExercices[pointeurExercice].profondeurQuestion;
			var decomposition : Vector.<Agregat> = racine.getDecomposition(pointDeDepart, pileExercices[pointeurExercice].profondeurDecomposition);
			var idElements : Vector.<String> = new Vector.<String>();
			for each (var e : Agregat in decomposition) {
				idElements.push(e.id);
			}
			melanger(Vector.<*>(idElements));
			return idElements;
		}

		public function getLibelleElement(id : String) : String {
			return getElementParId(id).libelle;
		}

		public function getDefinition(id : String) : String {
			return getElementParId(id).definition;
		}

		private function getElementParId(id : String) : Agregat {
			return racine.getElement(id);
		}

		public function placementInitialDansZone() : Boolean {
			return pileExercices[pointeurExercice] is ExerciceDeconstruction;
		}

		public function exerciceSuivant() : void {
			if (pointeurExercice == pileExercices.length - 1) /* on est au bout*/ {
				if (genererExercice()) pointeurExercice++;// soit on crée un nouvel exercice
				else {
					tousExercicesGeneres = true;
					pointeurExercice = 0;
				}
				// soit on revient au début
			} else pointeurExercice++;
			_nbErreurs = 0;
		}

		public function exercicePrecedent() : void {
			if (pointeurExercice == 0) return;
			pointeurExercice--;
			_nbErreurs = 0;
		}

		public function controlerPlacement(id : String, dansZone : Boolean) : Boolean {
			var profondeurReponseAttendue : uint;
			if (pileExercices[pointeurExercice] is ExerciceDeconstruction)
				profondeurReponseAttendue = (pileExercices[pointeurExercice] as ExerciceDeconstruction).profondeurObjectif;
			else profondeurReponseAttendue = pileExercices[pointeurExercice].profondeurQuestion;
			var elementCible : Agregat = racine.getDescendantPrincipal(profondeurReponseAttendue);
			return dansZone == (elementCible.getElement(id) != null);
		}

		public function get nbErreurs() : int {
			return _nbErreurs;
		}

		public function set nbErreurs(nbErreurs : int) : void {
			_nbErreurs = nbErreurs;
		}

		public function isBackPossible() : Boolean {
			return pointeurExercice > 0 || tousExercicesGeneres;
		}

		public function getIdNotion(numero : uint) : String {
			return idNotions[numero];
		}
	}
}
