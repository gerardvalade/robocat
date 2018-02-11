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

$fn=30;


M3_hole = 3.6;
fc_hole_width = 30.5;



module pdb_holder()
{
	ext_dia = 6;
	thick = 1;
	heigth = 2.5 + thick;
	
	
	module pdb()
	{
		for(x = [-1, 1]) for(y = [-1, 1]) {
			translate([x*fc_hole_width/2, y*fc_hole_width/2, 0]) {
				cylinder(d=ext_dia, h=heigth, center=false);
				//cylinder(d=5, h=heigth, center=false);
			}
		}
		hull() {
			translate([fc_hole_width/2, fc_hole_width/2, 0]) cylinder(d=ext_dia, h=thick, center=false);
			translate([-fc_hole_width/2, -fc_hole_width/2, 0]) cylinder(d=ext_dia, h=thick, center=false);
		}
		hull() {
			translate([-fc_hole_width/2, fc_hole_width/2, 0]) cylinder(d=ext_dia, h=thick, center=false);
			translate([fc_hole_width/2, -fc_hole_width/2, 0]) cylinder(d=ext_dia, h=thick, center=false);
		}
		translate([0, 0, 0]) cylinder(d=25+6, h=thick, center=false);
	}
	
	
	difference()
	{
		union() {
			pdb(); 
			
		}
		translate([0, 0, -0.1]) cylinder(d=25, h=3, center=false);
		for(x = [-1, 1]) for(y = [-1, 1]) translate([x*fc_hole_width/2, y*fc_hole_width/2, -0.1]) cylinder(d=M3_hole, h=heigth+1, center=false); 
	}
}

module esc_holder1()
{
	thick = 1.2;
	rot = -22;
	module round(d, h)
	{
		module cyl()
		{
			cylinder(d=d, h=h, center=flase);
			sz = 0.8; 
			if (h>10) /*>*/ rotate([0, 0, 20])  translate([-sz, -sz, -0.1]) cube([20, 20, h], center=false);
		}
		
		rotate([0, 0, rot]){
			cyl();
			translate([-21.3/2, 8.72, 0]) cyl();
		}
	}

	module plain(){
		translate([-2, 0, 0]) difference() {
			union() {
				translate([3.8, 0, thick/2]) color("red") cube([27+8, 14, thick], center=true);
			}
			spacer= 5;
			for(x=[-2:2])
				hull() {
					translate([x*spacer, -3, -0.1])  cylinder(d=2, h=thick+2, center=flase);
					translate([x*spacer, 3, -0.1])  cylinder(d=2, h=thick+2, center=flase);
				}
		
		}
	}
	
	 difference() {
		union() {
			//translate([-16.5, -7, 0]) rotate([0, 0, 35]) plain();
			//translate([-19, -7, 0])
			rotate([0, 0, 45]) translate([-16, 6, 0]) plain();
			round(d=10, h=3);
			rotate([0, 0, rot]){
				color("red") hull() {
					translate([0, 0, 0])  cylinder(d=5, h=thick, center=flase);
					translate([-21.3/2, 8.72, 0])  cylinder(d=5, h=thick, center=flase);
				}
			}
		}
		translate([0, 0, -0.1]) round(d=4.6+0.5, h=11);
	}
}

esc_height=12.5;
module esc_holder()
{
	thick = 1.5;
	rot = -0;
	module round(d, h)
	{
		module cyl()
		{
			cylinder(d=d, h=h, center=flase);
			sz = 0.8; 
			if (h>13) /*>*/ rotate([0, 0, -45])  translate([-sz, -sz, -0.1]) cube([20, 20, h], center=false);
		}
		
		rotate([0, 0, rot]){
			cyl();
			//translate([-21.3/2, 8.72, 0]) cyl();
		}
	}

	module fente()
	{
		hull() {
			translate([0, 0, -1.5])  rotate([0, 90, 0]) cylinder(d=3, h=thick+2, center=flase);
			translate([0, 0,  1.5])  rotate([0, 90, 0]) cylinder(d=3, h=thick+2, center=flase);
		}
		
	}
	
	module plain(){
		translate([0, 0, 0]) difference() {
			union() {
			  translate([-5+thick/2, -9, esc_height/2])  cube([thick, 30, esc_height], center=true);
			}
			spacer= 7;
			for(x=[-1:1]) {
				translate([-6, x*spacer-10, esc_height/2])  rotate([0, 90, 0]) cylinder(d=4, h=thick+2, center=flase);
				translate([-6, x*spacer-10, esc_height]) rotate([0, 90, 0]) cylinder(d=4, h=thick+2, center=flase);
				translate([-6, x*spacer-10, 0]) rotate([0, 90, 0]) cylinder(d=4, h=thick+2, center=flase);
				//translate([-11, x*spacer, esc_height/2]) fente();
			}
		
		}
	}
	
	module pillar()
	{
		translate([0, 48/2, 0])  round(d=10, h=9.4);
	}
	
	
	module half()
	{
		difference() {
			union() {
				rot = 30;
				translate([0, -48/2, 0])  rotate([0, 0, rot])  translate([0, 48/2, 0])  plain();
			    translate([-18, 0, 0]) cylinder(d=4, h=esc_height);
				pillar();
				mirror([0, 1, 0]) {
					
					translate([0, -48/2, 0])  rotate([0, 0, rot])  translate([0, 48/2, 0])  plain();
					pillar();
				}
				translate([0, -40/2, 0])  cube([thick, 40, esc_height-6], center=false);
			}
			translate([0, 48/2, -0.1]) round(d=6.7+0.5, h=14);
			mirror([0, 1, 0])  translate([0, 48/2, -0.1]) round(d=6.7+0.5, h=14);
			translate([0, 0, esc_height-2.9])  cube([50, 6, 6], center=true);
		}
	
	}
	translate([0, 0, 0]) half();
}
	
module pdb_view()
{
	module pdb()
	{
		thick=1;
		width=33;
		length=37;
		difference()
		{
			union() {
		    	translate([0, 0, thick/2]) cube([length, width, thick], center=true);
		    	translate([(length+12)/2, 0, thick/2]) cube([12, 16, thick], center=true);
		 		for(x = [-1, 1]) for(y = [-1, 1]) translate([x*fc_hole_width/2, y*fc_hole_width/2, 0]) cylinder(d=7, h=thick, center=false); 
		    }
		 	for(x = [-1, 1]) for(y = [-1, 1]) translate([x*fc_hole_width/2, y*fc_hole_width/2, -0.1]) cylinder(d=M3_hole, h=thick+1, center=false); 
			for(y = [-1, 1]) translate([(length+7)/2, y*8/2, -0.1]) cylinder(d=4, h=thick+1, center=false); 
		
		}
	}
	module quater()
	{
		//translate([111/2, 48/2, 0]) mirror([0, 0, 0])  
		color("red") translate([111/2, 0, esc_height]) rotate([180, 0, 0]) esc_holder();
	}
	module half()
	{
		quater();
		mirror([1, 0, 0]) quater();
	}
	
	translate([0, 0, 0]) rotate([0, 0, 0]) pdb_holder();
	translate([0, 0, 3.5]) color("blue", 0.7)  pdb();
	translate([0, 0, 0]) {
		half();
//		mirror([0, 1, 0])  half();
	}
		
	
}	

translate([0, 0, 0]) rotate([0, 0, 0]) pdb_holder();
translate([-30, 0, 0]) esc_holder();
translate([-60, 0, 0]) esc_holder();

