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
$fn=60;

length = 35;
width = 35;

M3_hole = 3.5;
fc_hole_width = 30.5;


module roundCornersCube(x,y,z,r)  // Now we just substract the shape we have created in the four corners
{
	module createMeniscus(h,radius) // This module creates the shape that needs to be substracted from a cube to make its corners rounded.
	{
		difference(){        //This shape is basicly the difference between a quarter of cylinder and a cube
		   translate([radius/2+0.1,radius/2+0.1,0]){
		      cube([radius+0.2,radius+0.1,h+0.2],center=true);         // All that 0.x numbers are to avoid "ghost boundaries" when substracting
		   }
		
		   cylinder(h=h+0.2,r=radius,$fn = 25,center=true);
		}
	
	}
	difference(){
	   cube([x,y,z], center=true);
	
	translate([x/2-r,y/2-r]){  // We move to the first corner (x,y)
	      rotate(0){  
	         createMeniscus(z,r); // And substract the meniscus
	      }
	   }
	   translate([-x/2+r,y/2-r]){ // To the second corner (-x,y)
	      rotate(90){
	         createMeniscus(z,r); // But this time we have to rotate the meniscus 90 deg
	      }
	   }
	      translate([-x/2+r,-y/2+r]){ // ... 
	      rotate(180){
	         createMeniscus(z,r);
	      }
	   }
	      translate([x/2-r,-y/2+r]){
	      rotate(270){
	         createMeniscus(z,r);
	      }
	   }
	}
}

module pillar(d, h)
{
	for(x = [-1, 1]) for(y = [-1, 1]) {
		translate([x*fc_hole_width/2, y*fc_hole_width/2, 0]) {
			cylinder(d=d, h=h, center=false);
		}
	}
	
}

module buzzer_holder(thick = 1.2, up=false)
{
	buzzer_dia = 9.2+0.8;
	buzzer_heigth = 5;
	
	difference()
	{
		union() 
		{
			translate([-20, 0, thick/2]) roundCornersCube(10, 20, thick, 3);
			
			translate([-25, 0, 0]) cylinder(d=buzzer_dia+3, h=buzzer_heigth, center=false);
		}
		
		translate([-25, 0, 0]) color("red") {
			translate([0, 0, -0.1])  cylinder(d=buzzer_dia-1, h=buzzer_heigth+5, center=false);
			if (up==true)
			translate([0, 0, -1]) hull() {
				translate([0, 0, 0])  cylinder(d=buzzer_dia+0.8, h=0.1, center=false);
				translate([0, 0, buzzer_heigth])  cylinder(d=buzzer_dia, h=0.1, center=false);
			}
			if (up==false)
			translate([0, 0, 1]) hull() {
				translate([0, 0, 0])  cylinder(d=buzzer_dia, h=0.1, center=false);
				translate([0, 0, buzzer_heigth])  cylinder(d=buzzer_dia+0.8, h=0.1, center=false);
			}
		
		}
	}
}

module fc_holder()
{
	ext_dia = 6;
	thick = 1.2;
	heigth = 4 + thick;
	
	difference()
	{
		union() 
		{
			translate([0, 0, thick/2]) roundCornersCube(fc_hole_width+ext_dia, fc_hole_width+ext_dia, thick, 3);
			
			pillar(d=ext_dia, h=heigth-1);
			pillar(d=5, h=heigth);
			
		}
		
		translate([0, 0, -0.1]) roundCornersCube(fc_hole_width-ext_dia/2, fc_hole_width-ext_dia/2, thick+2, 3);
		translate([0, 0, -0.1]) pillar(d=M3_hole, h=15);
		//translate([-24, 0, -0.1]) cylinder(d=buzzer_dia, h=thick+10, center=false);
		
	}
	buzzer_holder(thick, up=false);
}

module receiver_holder()
{
	ext_dia = 6;
	thick = 1.2;
	heigth = 6 + thick;

	module receiver(d, h)
	{
		for(y = [-1, 1]) {
			translate([0, y*fc_hole_width/2, 0]) {
				cylinder(d=d, h=h, center=false);
			}
		}
		
	}
	
	difference()
	{
		union() 
		{
			translate([-3, 0, thick/2]) roundCornersCube(fc_hole_width+ext_dia+6, fc_hole_width+ext_dia, thick, 3);
			
			pillar(d=ext_dia, h=heigth-1);
			pillar(d=5, h=heigth);
			translate([-6-fc_hole_width/2, 0, 0]) receiver(d=5, h=4+thick);
		}
		ww=10;
		dia=5;
		for(x=[-1:1]) translate([x*10, 0, -0.1]) hull() {
			translate([0, -ww,  0]) cylinder(d=dia, h=thick+1);
			translate([0, ww,  0]) cylinder(d=dia, h=thick+1);
		}
		
		//translate([0, 0, -0.1]) roundCornersCube(fc_hole_width-ext_dia/2, fc_hole_width-ext_dia/2, thick+2, 3);
		translate([0, 0, -0.1]) pillar(d=3, h=15);
		translate([-6-fc_hole_width/2, 0, -0.1]) receiver(d=2, h=heigth+2);
		
	}
}

module receiver_holder1()
{
	ext_dia = 6;
	thick = 1.2;
	heigth = 6 + thick;
	
	difference()
	{
		union() 
		{
			translate([0, 0, thick/2]) roundCornersCube(fc_hole_width+ext_dia, fc_hole_width+ext_dia, thick, 3);
			
			pillar(d=ext_dia, h=heigth-1);
			pillar(d=5, h=heigth);
		}
		//translate([0, 0, -0.1]) roundCornersCube(20, 20, thick+2, 3);

		ww=10;
		dia=2.5;
		for(x=[-2:2]) translate([0, x*6, -0.1]) hull() {
			translate([-ww, 0, 0]) cylinder(d=dia, h=thick+1);
			translate([ww, 0, 0]) cylinder(d=dia, h=thick+1);
		}


		translate([0, 0, -0.1]) pillar(d=M3_hole, h=15);

	}
	//buzzer_holder(thick, up=true);
}

module fc()
{
	difference()
	{
		union() {
			color("yellow") {
				translate([0, 0, 0.5]) roundCornersCube(35, 35, 1, 3);
				pillar(5, 1);
			}
			
		}
		translate([0, 0, -0.1]) pillar(3, 2);
	}
}

module fc_view()
{
	translate([0, 0, 0]) rotate([0, 0, 0]) fc_holder();
	
	translate([0, 0, 5]) fc();
	translate([0, 0, 13]) rotate([0, 0, 0]) rotate([180, 0, 0]) receiver_holder();
	
	//color("gray", 0.5) translate([0, 0, 27]) roundCornersCube(50, 35, 1, 3);
	
}

translate([0, 40, 0]) rotate([0, 0, 0]) fc_holder();

translate([0, 0, 0]) rotate([0, 0, 0]) receiver_holder();

//translate([-80, 0, 0])  fc_view();