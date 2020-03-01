
use <zcube.scad>;
use <bolts.scad>;

dimensions = [227, 227, 17];
gap = 2+20;

module blocks() {
	zcube(dimensions, z=gap);
	zcube(dimensions, f=-1);
}

module bottom_connector(outset = 6, width=40) {
	translate([0, -dimensions[1]/2, -dimensions[2]])
	
	hull() {
		translate([0, -outset - dimensions[2]/2, dimensions[2] * 0.5])
		rotate([0, 90, 0])
		translate([0, 0, -width/2])
		cylinder(d=dimensions[2], h=width);
				
		translate([0, -outset - dimensions[2]/2, dimensions[2] * 1.5 + gap])
		rotate([0, 90, 0])
		translate([0, 0, -width/2])
		cylinder(d=dimensions[2], h=width);
	}
}

module bottom_hinge_bolt(outset=6, width=48) {
	translate([0, -dimensions[1]/2, -dimensions[2]])
	translate([0, -outset - dimensions[2]/2, dimensions[2] * 1.5 + gap])
	translate([width/2, 0, 0])
	rotate([90, 0, -90])
	bolted_hole(4, depth=width-4);
}

module bottom_fixed(outset = 6, width=48, inset = 12) {
	difference() {
		union() {
			bottom_connector(width=width-inset*2);
			
			translate([0, -dimensions[1]/2, -dimensions[2]])
			
			hull() {
				translate([0, -outset - dimensions[2]/2, dimensions[2] * 0.5])
				rotate([0, 90, 0])
				translate([0, 0, -width/2])
				cylinder(d=dimensions[2], h=width);
				
				translate([0, -6/2, 0])
				zcube([width, 6, dimensions[2]]);
			}
		}
		
		translate([0, -dimensions[1]/2, -dimensions[2]])
		
		union() {
			hole = [width / 3, dimensions[2] / 3];
			
			translate([0, 0, hole[1]])
			rotate([90, 0, 0])
			countersunk_hole(4, inset=dimensions[2]);
			
			translate([-hole[0], 0, hole[1]*2])
			rotate([90, 0, 0])
			countersunk_hole(4, inset=dimensions[2]);
			
			translate([hole[0], 0, hole[1]*2])
			rotate([90, 0, 0])
			countersunk_hole(4, inset=dimensions[2]);
		}
		
		bottom_hinge_bolt(outset=outset, width=width);
	}
}

module bottom_hinge(outset = 6, width=48, inset = 12) {
	difference() {
		translate([0, -dimensions[1]/2, gap])
		
		difference() {
			hull() {
				translate([0, -6/2, 0])
				zcube([width, 6, dimensions[2]]);
				
				translate([0, -outset - dimensions[2]/2, dimensions[2] * 0.5])
				rotate([0, 90, 0])
				translate([0, 0, -width/2])
				cylinder(d=dimensions[2], h=width);
			}
			
			cutout = dimensions[2] + outset;
			
			translate([0, -cutout/2 - outset, 0])
			zcube([width-inset*2 + 1, cutout, dimensions[2] + 1]);
			
			hole = [(width - inset * 2) / 3, dimensions[2] / 3];
			
			translate([0, 0, hole[1]])
			rotate([90, 0, 0])
			countersunk_hole(4);
			
			translate([-hole[0], 0, hole[1]*2])
			rotate([90, 0, 0])
			countersunk_hole(4);
			
			translate([hole[0], 0, hole[1]*2])
			rotate([90, 0, 0])
			countersunk_hole(4);
		}
		
		bottom_hinge_bolt(outset=outset, width=width);
	}
}

color("brown")
//blocks();

bottom_hinge();
bottom_fixed();
