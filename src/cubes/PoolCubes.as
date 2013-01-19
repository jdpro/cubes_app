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
	/**
	 * @author Joachim
	 */
	public class PoolCubes {
		private static var poolCubes : Vector.<Cube> = new Vector.<Cube>();
		private static var largeurCubes : Number;
		private static var hauteurCubes : Number;

		public static function donnerCube() : Cube {
			if (poolCubes.length > 0)
				return poolCubes.pop();
			return new Cube(largeurCubes, hauteurCubes);
		}

		public static function restituer(c : Cube) : void {
			if(c.parent) c.parent.removeChild(c);
			poolCubes.push(c);
		}

		public static function initialiser(largeur : Number, hauteur : Number) : void {
			hauteurCubes = hauteur;
			largeurCubes = largeur;
		}

		public static function replacerCubesInutilises() : void {
			for each (var c : Cube in poolCubes) {
				c.x=0;
				c.y=0;
				
			}
		}
	}
}
