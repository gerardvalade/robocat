// XT60Holder for Tarot 680 - a OpenSCAD 
// Copyright (C) 2015  Gerard Valade

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
length = 21;
width = 27;
heigth = 11;
M3_dia = 3+0.5;
M3_hole = 3;
M2_hole = 1.8;
M2_dia= 2+0.5;

bracket_mounting_hole = 30.5;
bracket_mounting_heigth = 14;
controler_mounting_hole = 30.5;


thick=1.5;
pillar_width = 47;
pilar_heigth = 35;
top_height = 20;// 10.5+1.2 +2;
bottom_height = 15;//pilar_heigth-top_height-0.4;

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

module frskyD4R($fn = 4)
{
	module connector()
	{
		//translate([31.12/2, -3, 2.5]) color([0.9, 0.8, 0.2])
		color([0.2, 0.2, 0.2]) cube([2.5, 15, 5], center=false);
		translate([0, 1, 1]) color([0.9, 0.8, 0.2])
			for (y=[0:5]) {
				translate([0, y*2.54, 0]) rotate([0, 90, 0]) cylinder(d=.6, h=8.5);
				translate([0, y*2.54, 2.54]) rotate([0, 90, 0]) cylinder(d=.6, h=8.5);
			}
		
	}
	module telemetryPort()
	{
		color([0.9,0.9,0.9])
		difference() { 
			cube([7.5, 4.5, 3.0], center=true);
			cube([7, 5, 2.5], center=true);
		
		}
		color([0.9, 0.8, 0.2]) for (x=[0:3]) {
			translate([x*1.25-1.9, 2.8, 0]) rotate([90, 0, 0]) cylinder(d=.5, h=5);
		}
		
	}

	difference() {	
		translate([0, 0, 7.34/2]) color([0.4, 0.4, 0.4]) cube([31.12, 23.16, 7.34], center=true);
		translate([11.9, -9.5, 6.0]) 
				cube([7.5, 4.5, 3.0], center=true);
	}
	translate([11.9, -9.5, 6.0]) telemetryPort();	
	translate([31.12/2, -7.34, 2]) connector();

}

module fc_board()
{
	module connector()
	{
		translate([0, 0, 12/2+0.1]) color("red") cube([15, 8.5, 2], center=true);
		translate([-14.5/2+1, -8.5/2+2.54, 2.5+3.5]) color([0.9, 0.8, 0.2])
			for (x=[0:5]) for (y=[0:2]) {
				translate([ x*2.54, y*2.54, 0]) rotate([0, 0, 0]) cylinder(d=.5, h=8.5);
			}
	}
	difference() {
		translate([0, 0, 11/2]) color("green") roundCornersCube(35, 35, 1, 3);
		translate([-13+8, 16, 14.5/2+5]) cube([16.3, 10, 14.5], center=true);
		for(x=[-1,1]) for(y=[-1,1])
			translate([x*controler_mounting_hole/2, y*controler_mounting_hole/2, -1])  cylinder(d=M3_hole, h=30);
		
	}
	translate([-13+8, 13, 1]) connector();
	
}

module fc_boxe()
{
	difference() {
		translate([0, 0, 11/2]) color("yellow") roundCornersCube(40,40, 11, 3);
		translate([-13+8, 16, 14.5/2+5]) cube([16.3, 10, 14.5], center=true);
	}
	//translate([-13+8, 13, 0]) connector();
	fc_board();
	
}




module V_antenna(full_view=false, frskyWidth=23.5, $fn=30)
{
	base_length = 33;
	base_width = 36;
	v_width= 26;
	v_height= 2;
	
	module Vsupport()
	{
		module cc()
		{
			roundCornersCube(7.2, 7.2, 4, 2);
		}
		difference() { 
			union() {
				translate([0, 0, 1.3]) cube([7.2, v_width, 2.6], center=true);
				for (y = [-1, 1]) {
					translate([0, y*(v_width/2), v_height])  rotate([-y*45, 0, 0]) 
					{
						translate([0, 0, -1]) cylinder(d=7, h=18, center=false, $fn=6);
					}
					translate([0, y*(v_width)/2, 3]) 
					{
						roundCornersCube(7.2, 7.2, 6, 2);
					}
					
				}
			}
			for (y = [-1, 1]) {
				translate([0, y*v_width/2, -2]) 
				{
					cube([7.2, 7.2, 4], center=true);// cube([7.2, 7.2, 10], center=true);
				}
			}
		}
	}
	
	translate([0, 0, 0]) difference()
	{
		union() {
			//round_corners_cube(base_length, base_width, plate_tin, 3);
			translate([0, 0, 0]) Vsupport();
		}
		
//		#translate([-2.1, 0, .6]) cube([base_length-8, 5, 2], center=true);
//		#translate([0, 0, -0.1]) cube([6.1+2, 8, 3], center=true);
		
		for (y = [-1, 1]) {
			translate([0, y*(v_width/2), v_height])  rotate([-y*45, 0, 0]) {
				translate([0, 0, 8.5]) cylinder(d=3, h=16, center=true);
				translate([0, 0, 14]) cylinder(d=3.8, h=20, center=true);
				//#translate([0, 0, -0]) cylinder(d=3.8, h=1, center=true);
			}
			translate([0, y*(v_width-8)/2, 3.4]) rotate([90, 0, 0]) cylinder(d=3.8, h=10, center=true);
			
			// Head screw hole
			//#translate([(base_length-26)/2, y*11, 0]) cylinder(d=M25_head_dia, h=50, center=true);
		} 
		//translate([-5,0,10]) color(cut_color) cube([10,60,25], center=true);
		//if (cut_view) translate([0,0,10]) color(cut_color) cube([10,40,25], center=true);
	}
	if (full_view)
		color("pink") for (y = [-1, 1]) {
			translate([0, y*(v_width/2), v_height])  rotate([-y*45, 0, 0]) 
			{
				translate([0, 0, 40]) {
					difference() {
						cylinder(d=3, h=80, center=true);
						cylinder(d=1.5, h=85, center=true);
					}
				}
			}
		} 
	
	
}


module frskyD4R_plate(full_view=false)
{
	receiver_width = 23.2;
	receiver_length = 31.2;
	module plain()
	{
		translate([-26, 0, 0]) V_antenna(full_view=full_view);
		//translate([-3.5, 0, thick/2])  roundCornersCube(15, 55, thick, 3);
		translate([0, 0, 0]) {
			translate([-5, 0, thick/2])  roundCornersCube(receiver_length+14, receiver_width+3.6, thick, 3);
			translate([-5, 0, thick]) {
				translate([0, (receiver_width+2)/2, 3/2]) cube([receiver_length, 1.5, 3], center=true);
				translate([-7/2, -(receiver_width+2)/2, 3/2]) cube([23, 1.5, 3], center=true);
			}
		}
		hull()
		{
			translate([-bracket_mounting_hole/2, bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
			translate([-bracket_mounting_hole/2,  -bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
		}
		
	}
	module hole()
	{
		for(x=[-1,1]) for(y=[-1,1])
			translate([x*bracket_mounting_hole/2, y*bracket_mounting_hole/2, -1])  cylinder(d=M2_dia, h=thick+2);
	}
	difference() {
		plain();
		hole();
	}
	if (full_view) translate([-5, 0, thick]) frskyD4R();
	
}

module frskyXM_plate(full_view=false)
{
	receiver_width = 12;
	receiver_length = 21.5;
	module arm()
	{
		
		hull()
		{
			translate([-bracket_mounting_hole/2, bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
			translate([-bracket_mounting_hole/2,  -bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
		}
	}
	module plain()
	{
		translate([-26, 0, 0]) V_antenna(full_view=full_view);
		//translate([-3.5, 0, thick/2])  roundCornersCube(15, 55, thick, 3);
		translate([0, 0, 0]) {
			translate([-10, 0, thick/2])  roundCornersCube(receiver_length+4, receiver_width+3.6, thick, 3);
			translate([0, 0, thick]) for(y=[-1, 1]){
				translate([-11, y*(receiver_width+2)/2, 3/2]) cube([receiver_length, 1.5, 3], center=true);
			}
		}
		arm();		
		
	}
	module hole()
	{
		for(y=[-1,1])
			translate([-bracket_mounting_hole/2, y*bracket_mounting_hole/2, -1])  cylinder(d=M2_dia, h=thick+2);
	}
	difference() {
		plain();
		hole();
	}
	if (full_view)
				translate([-10, 0, thick+1]) color("green")cube([receiver_length, receiver_width, 2], center=true);
	
}

module frskyXSR_plate(full_view=false)
{
	receiver_width = 19.3;
	receiver_length = 27;
	module arm()
	{
		hull()
		{
			translate([-bracket_mounting_hole/2, bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
			translate([-bracket_mounting_hole/2,  -bracket_mounting_hole/2, 0]) cylinder(d=7, h=thick);
		}
	}
	module plain()
	{
		translate([-26, 0, 0]) V_antenna(full_view=full_view);
		translate([0, 0, 0]) {
			translate([-11, 0, thick/2])  color("gray") roundCornersCube(receiver_length+10, receiver_width+3.6, thick, 3);
			translate([0, 0, thick]) for(y=[-1, 1]){
				translate([-8, y*(receiver_width+2)/2, 4/2]) cube([receiver_length, 1.5, 4], center=true);
			}
		}
		arm();		
		
	}
	module hole()
	{
		for(y=[-1,1])
			translate([-bracket_mounting_hole/2, y*bracket_mounting_hole/2, -1])  cylinder(d=M2_dia, h=thick+2);
	}
	difference() {
		plain();
		hole();
	}
	if (full_view)
				translate([-9, 0, thick+2]) color("green")cube([receiver_length, receiver_width, 2], center=true);
	
}

module buzzer()
{
	color("black") cylinder(d=12, h=10, center=false);
	color("green") cube([16, 15, 2], center=true);
}


module frsky_view()
{
	translate([0, 0, bracket_mounting_heigth])  frskyXSR_plate(full_view=true);
	
}

module frsky_view2()
{
	translate([0, 0, bracket_mounting_heigth])  frskyD4R_plate(full_view=true);
	translate([80, 0, bottom_height])  frskyXM_plate(full_view=true);
	translate([160, 0, bottom_height])  frskyXSR_plate(full_view=true);
}
module frsky_view3()
{

	translate([-24.5-1, 0, bottom_height])  frskyXM_plate(full_view=true);

}

//translate([0, 80, 0]) frsky_view();
//translate([0, 150, 0]) frsky_view2();
//translate([0, 230, 0]) frsky_view3();

translate([0, 0, 0]) frskyD4R_plate();
translate([0, -60, 0]) frskyXM_plate();
translate([0, 60, 0]) frskyXSR_plate();
