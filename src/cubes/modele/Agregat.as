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
	import flash.errors.IllegalOperationError;

	/**
	 * @author Joachim
	 */
	public class Agregat {
		private var composantes : Vector.<Agregat>;
		private var _definition : String;
		private var _libelle : String;
		private var _id : String;
		private var _article : String;
		private var _majusculeObligatoire : Boolean;

		public function Agregat(id : String, libelle : String, definition : String, article : String, majusculeObligatoire : String) {
			_majusculeObligatoire = majusculeObligatoire=="true";
			_id = id;
			_libelle = libelle;
			_definition = definition;
			_article = article;
			composantes = new Vector.<Agregat>();
		}

		public function toString() : String {
			var serialisation : String = _id + "/" + _libelle + "/" + _definition + "{";
			for each (var e : Agregat in composantes) {
				serialisation += e.toString();
			}
			serialisation += "}";
			return serialisation;
		}

		public function ajouterComposante(composante : Agregat) : void {
			composantes.push(composante);
		}

		public function getProfondeur() : uint {
			var profondeur : uint = 0;
			for each (var composante : Agregat in composantes) {
				profondeur = Math.max(composante.getProfondeur(), profondeur);
			}
			return profondeur + 1;
		}

		public function getDescendantPrincipal(profondeur : uint) : Agregat {
			if (profondeur == 0) return this;
			else if (composantes.length == 0) throw new IllegalOperationError("l'arbre n'est pas assez profond");
			else return descendantPrincipal().getDescendantPrincipal(profondeur - 1);
		}

		private function descendantPrincipal() : Agregat {
			var descendant : Agregat;
			for each (var composante : Agregat in composantes) {
				if (!descendant || composante.getProfondeur() > descendant.getProfondeur())
					descendant = composante;
			}
			return descendant;
		}

		public function get libelle() : String {
			return _libelle;
		}

		public function get article() : String {
			return _article;
		}

		public function get id() : String {
			return _id;
		}

		public function get definition() : String {
			return _definition;
		}

		public function getDecomposition(debut : int, profondeur : uint) : Vector.<Agregat> {
			var decomposition : Vector.<Agregat>;
			if (profondeur == 0) {
				decomposition = new Vector.<Agregat>();
				decomposition.push(this);
			} else {
				decomposition = descendantPrincipal().getDecomposition(debut - 1, profondeur - 1);
				if (debut <= 0)
					for each (var composante : Agregat in composantes) {
						if (composante != descendantPrincipal())
							decomposition.push(composante);
					}
			}
			return decomposition;
		}

		public function getElement(id : String) : Agregat {
			if (id == this.id) return this;
			else {
				for each (var composante : Agregat in composantes) {
					if (composante.getElement(id)) return composante.getElement(id);
				}
			}
			return null;
		}

		public function get majusculeObligatoire() : Boolean {
			return _majusculeObligatoire;
		}
	}
}
