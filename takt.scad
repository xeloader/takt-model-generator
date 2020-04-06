box_size=99; // [10:0.25:250]
wall_thickness=2;
with_grid=true; // [true, false]

/* [Advanced Sizing] */
// will not edit model unless cube shaped is disabled
cube_shaped=true;
box_height=99; // [10:0.25:250]
box_width=99; // [10:0.25:250]

/* [Parts] */
sides=true;
Holes_for_screws=true;
bottom_lid=false;
bottom_lid_style="flat"; // [flat, grid, circle, fence]
top_lid=false;
top_lid_style="flat"; // [flat, grid, circle, fence]

/* [Type-Grid] */
grid_n=4;
grid_h=0.5;

/* [Type-Fence] */
fence_height=20;
fence_n=3;
fence_thickness=2;
fence_frame_thickness=2;


/* [Type-Circle] */
film_thickness = 0.5; // [-1:0.5:100]
frame = false;
frame_height = 70;
frame_thickness = 2;

/* [Screws] */
hole_offset=12.5;
prep_hole_d=8;
screw_hole_d=5.45;

/* [Modularity] */
diagonal_cut=true;
prep_hole_geo="square"; // [square, circle]

/* [SCAD related] */
error_on_not_interconnectable=false; // [true, false]
$fn = 48;

if (error_on_not_interconnectable) {
assert(box_size/2 > 2*hole_offset, "Settings yields non interconnectable boxes"); 
}

module rotate_about_pt(z, y, pt) {
    translate(pt)
        rotate([0, y, z])
            translate(-pt)
                children();   
}

module cut_line(diag_cut_len) {
    cut_size=sqrt(pow(wall_thickness,2)+pow(wall_thickness,2));
    translate([diag_cut_len/2,0])
    rotate([45])
    cube([diag_cut_len, cut_size, cut_size], center=true);
}

module side(with_grid=false, diagonal_cut=false, with_circle=false, with_fence=false){
    b_height=cube_shaped ? box_size : box_height;
    b_width=cube_shaped ? box_size : box_width;
    max_pt_h = b_height-hole_offset;
    max_pt_w = b_width-hole_offset;
    min_pt = hole_offset;
    center_pt = box_size / 2;
    circle_r = (box_size*0.91)/2;
    difference() {
    union() {
    difference() {
    difference() {
        if (cube_shaped) {
            cube([box_size, wall_thickness, box_size]);
        } else {
            cube([box_width, wall_thickness, box_height]);
        }
        if (Holes_for_screws) 
        union() {
            translate([min_pt, 0, max_pt_h]) screwHole();
            translate([max_pt_w, 0, min_pt]) screwHole();
            translate([min_pt, 0, min_pt]) screwHole();
            translate([max_pt_w, 0, max_pt_h]) screwHole();
        }
    }
    if (with_circle) {
        rotate([90, 0])
        translate([center_pt, center_pt, -wall_thickness-0.01])
        cylinder(r=circle_r, h=wall_thickness-film_thickness);
    }
    if (with_fence) {
        fence_size = box_size-2*2*hole_offset;
        offset = hole_offset*2;
        translate([0,0,offset]){
            translate([fence_frame_thickness,-0.01,0])
            cube([box_size-fence_frame_thickness*2, wall_thickness+1, fence_size], center=false);
            
            translate([fence_frame_thickness,-0.01,0])
            rotate([0,90]){
                translate([-3*offset+fence_frame_thickness+1, 0, offset-fence_frame_thickness])
            cube([box_size-fence_frame_thickness*2, wall_thickness+1, fence_size], center=false);
            }
               
        }
    }
    if (with_grid) {
        grid_size = box_size-2*hole_offset;
        grid_step = grid_size / (grid_n - 1);
        translate([hole_offset, 0, hole_offset]){
        grid_max_i = grid_n-1;
        for(i=[0:grid_max_i]) {
            for (j=[0:grid_max_i]) {
                if (
                    !(i == 0 && (j == 0 || j == grid_max_i)) && 
                    !(i == grid_max_i && (j == 0 || j == grid_max_i))
                ) {
                translate([j*grid_step, -0.01, i*grid_step]) 
                rotate([-90, 0, 0])
                    gridHole();
                }
            }
        }
    }
    }
}
    if (with_fence) {
        max_i = fence_n - 1;
        fence_size = box_size-2*2*hole_offset;
        offset = (hole_offset*2);
        step_size = fence_size / (fence_n - 1);
        translate([box_size/2, -fence_height/2+fence_thickness, offset]) {
        for (i=[0:max_i]) {
            translate([0,0,step_size*i])
            cube([box_size, fence_height, fence_thickness], center=true);
        }
        }
        translate([offset, -fence_height/2+fence_thickness, box_size/2]) 
        rotate([0, 90]) {
            for (i=[0:max_i]) {
                translate([0,0,step_size*i])
                cube([box_size, fence_height, fence_thickness], center=true);
            }
        }
        translate([offset, fence_thickness])
        rotate([90])
        cube([fence_size, fence_frame_thickness, fence_height]);

        translate([offset, fence_thickness, box_size-fence_frame_thickness])
        rotate([90])
        cube([fence_size, fence_frame_thickness, fence_height]);
        
        translate([0, fence_thickness, fence_size+offset])
        rotate([90, 90])
        cube([fence_size, fence_frame_thickness, fence_height]);

        translate([box_size-fence_frame_thickness, fence_thickness, fence_size+offset])
        rotate([90, 90])
        cube([fence_size, fence_frame_thickness, fence_height]);

        
    
    }
    if (with_circle && frame) {
        translate([0, wall_thickness])
            union() {
            difference() {
                rotate([90, 0])
                translate([center_pt, center_pt])
                cylinder(r=circle_r, h=frame_height);
                
                rotate([90, 0])
                translate([center_pt, center_pt, -0.01])
                cylinder(r=circle_r-frame_thickness, h=frame_height+0.02);
            }
        }
    }
}

    if (diagonal_cut) {
            translate([0, wall_thickness]) {
                diag_cut_len=box_size+0.01;
                cut_line(diag_cut_len);
                translate([0,0,b_height]) cut_line(diag_cut_len);
                rotate([0,-90]) cut_line(diag_cut_len);
                translate([b_width,0]) rotate([0,-90]) cut_line(diag_cut_len);
            }
        }
    }
}

module gridHole() {
    cylinder(r=2.5, h=grid_h);
}

module screwHole() {
    // 7.95, prephole
    // 5.45 stopper
        prep_depth = 1;
        translate([0,wall_thickness-prep_depth,0])
        translate([0,prep_depth/2+0.01,0]) {
            if (prep_hole_geo == "square") {
                cube([prep_hole_d, prep_depth, prep_hole_d], center=true);
            } else {
                rotate([90, 0, 0])
                cylinder(r=prep_hole_d/2, h=1, center=true);
            }
        }
        
        hole_depth=wall_thickness+1;
        translate([0, hole_depth/2+wall_thickness/2,0])
        rotate([90,0,0])
        cylinder(r=screw_hole_d/2, h=hole_depth);
}

module box(with_grid=false, diagonal_cut=false, with_fence=false) {
center_pt=box_size/2;
    if (sides) {
        translate([0, box_size]) 
        rotate_about_pt(180,0,[center_pt,0,center_pt])
        side(with_grid=with_grid, diagonal_cut=diagonal_cut);
        side(with_grid=with_grid, diagonal_cut=diagonal_cut);

        rotate([0,0,90])
        rotate_about_pt(180,0,[center_pt,0,center_pt])
        side(diagonal_cut=diagonal_cut);

        translate([box_size, 0])
        rotate([0,0,90])
        side(diagonal_cut=diagonal_cut);
    }
    if (bottom_lid) {
        translate([0, box_size])
        rotate([90])
        side(
            with_grid=bottom_lid_style == "grid", 
            with_circle=bottom_lid_style=="circle",
            with_fence=bottom_lid_style=="fence",
            diagonal_cut=diagonal_cut
        );
    }
    if (top_lid) {
        translate([0, 0, box_size])
        rotate([-90])
        side(
            with_grid=top_lid_style == "grid", 
            with_circle=top_lid_style=="circle",
            with_fence=bottom_lid_style=="fence",
            diagonal_cut=diagonal_cut
        );
    }
}
//side(with_fence=true);
box(with_grid=with_grid, diagonal_cut=diagonal_cut);