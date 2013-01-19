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
	/**
	 * @author Joachim
	 */
	public class ExerciceDeconstruction extends Exercice {
		private var _profondeurObjectif : uint;

		public function ExerciceDeconstruction(profondeurQuestion : uint, profondeurObjectif : uint, profondeurDecomposition : uint) {
			_profondeurObjectif = profondeurObjectif;
			super(profondeurQuestion, profondeurDecomposition);
			
		}


		public function get profondeurObjectif() : uint {
			return _profondeurObjectif;
		}
	}
}
