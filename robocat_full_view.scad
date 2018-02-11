// robocat  - a OpenSCAD 
// Copyright (C) 2016  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

use <robocat_frame.scad>
use <pdb_holder.scad>
use <fc_holder.scad>
use <receiver_holder.scad>

robocat_view();


translate([0, 0, 0]) rotate([0, 0, 0]) pdb_view();

translate([0, 0, 40])  fc_view();
translate([-6, 0, 40])  frsky_view();