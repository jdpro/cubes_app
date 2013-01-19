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
	public class Donnees {
		DATA::VAB {
			[Embed(source="../../../data/vab.xml", mimeType="application/octet-stream")]
			private static const Data : Class;
		}
		DATA::MASSEMON {
			[Embed(source="../../../data/massemon.xml", mimeType="application/octet-stream")]
			private static const Data : Class;
		}
		DATA::POPACT {
			[Embed(source="../../../data/popact.xml", mimeType="application/octet-stream")]
			private static const Data : Class;
		}
		public static function analyser() : Agregat {
			return parcours(XML(new Data));
		}

		private static function parcours(xml : XML) : Agregat {
			var agregat : Agregat = new Agregat(xml.@id, xml.@libelle, xml.@definition, xml.@article, xml.@majuscule_obligatoire);
			if (xml.children().length() > 0) {
				for each (var composante : XML in xml.children()) {
					agregat.ajouterComposante(parcours(composante));
				}
			}
			return agregat;
		}
	}
}
