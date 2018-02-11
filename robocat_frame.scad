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

$fn = 30;
fc_hole_width = 30.5;

M3_hole = 3.5;

module bottom_frame()
{
	thick = 1.6;
	rot = -22;
	
	module fente(d, h, w, len)
	{
		for(y = [-1, 1]) hull()
		{
			translate([len/2, y*w/2, 0])	cylinder(d=d, h=h, center=true);
			translate([-len/2, y*w/2, 0])	cylinder(d=d, h=h, center=true);
			
		}	
	}
	
	module arm()
	{
		for(x = [-1, 1])  translate([x*111.5/2, 46/2, 0]) rotate([0, 0, x*rot]) cube([32, 30, thick], center=true);
		for(x = [-1, 1])  translate([x*95/2, 42/2, 0]) rotate([0, 0, x*(-45)]) cube([32, 30, thick], center=true);
	}
	module arm_hole(d, h, w, len)
	{
		module holes(x)
		{
			cylinder(d=d, h=h, center=flase);
			rotate([0, 0, x*rot]){
				translate([21.3/2, 8, 0]) cylinder(d=d, h=h, center=flase);
				translate([-21.3/2, 8.72, 0]) cylinder(d=d, h=h, center=flase);
			
			}
		}
		for(x = [-1, 1]) {
			translate([x*111/2, 48/2, 0]) {
				holes(x);
			}
			mirror([0, 1, 0]) translate([x*111/2, 48/2, 0]) {
				holes(x);
			}
//			translate([x*98.8/2, y*71.48/2, -0.1]) cylinder(d=M3_hole, h=thick+1, center=flase);
//			translate([x*138.2/2, y*54.14/2, -0.1]) cylinder(d=M3_hole, h=thick+1, center=flase);
		}
		
	}
	module pillar()
	{
		translate([0, 0, thick+3]) color("yellow", 0.99) {
			difference() {
				union() {
					arm_hole(d=4.6, h=10);
					arm_hole(d=7, h=3.5, $fn=6);
					translate([0, 0, 10-3.5]) arm_hole(d=7, h=3.5, $fn=6);
				}
				translate([0, 0, -0.1]) arm_hole(d=M3_hole, h=thick+11);
			}
		}
		
	}
	module plain()
	{
		translate([0, 0, thick/2]) {
			color("gray", 0.99) {
				cube([156.5, 51, thick], center=true);
				fente(d=9, h=thick, w=52, len=32);
				arm();
				mirror([0, 1, 0])  arm();
			
			}
		}
		pillar();
	}
	translate([0, 0, -thick])  difference() {
		plain();
		
		translate([0, 0, -0.1]) cylinder(d=25, h=3, center=false);
		
		for(x = [0, 1])  {
			translate([26+x*21, 0, -0.1]) cylinder(d=16, h=3, center=false);
		}
		for(x = [0:2])  {
			translate([-26-x*21, 0, -0.1]) cylinder(d=16, h=3, center=false);
		}
		
		for(x = [-1, 1]) for(y = [-1, 1]) {
			translate([x*fc_hole_width/2, y*fc_hole_width/2, -0.1]) {
				cylinder(d=M3_hole, h=3, center=false);
			}
		}
		fente(d=3.15, h=4, w=52, len=30);
		for(x = [-1, 1])  {
			translate([x*46/2, 0, -0.1]) fente(d=1.7, h=4, w=45, len=12);
			translate([x*80/2, 0, 0]) fente(d=4, h=4, w=38, len=12);
			
		}
		translate([0, 0, -0.1]) arm_hole(d=M3_hole, h=thick+1);
	}	
}

module robocat_view()
{
	bottom_frame();
}

robocat_view();