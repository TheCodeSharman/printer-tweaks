/// tunable parameters
frame_depth = 6.4;
tube_od = 3.4;
wall_width = 2.0;
gap = 1.5;
width = 15;
frame_overlap = 15;
radius = 2.5;

// internal parameters
$fa = 5;
$fs = 0.01;
total_depth = wall_width*2 + frame_depth;
top_height = tube_od + gap*2;
    
module block_with_rounded_corners( width, height, depth, radius ) {
    intersection() {
        union() {
                    // bottom of the block             
                    translate([0,-depth,0]) cube([width, depth, height - radius]);
            
                    // create 2 cylinders joined by a slab for the top of the block
                    translate ( [0,0,height - radius] ) {
                        translate( [ radius, 0, 0 ] )
                            rotate( [ 90, 0, 0 ] )
                            cylinder( h=depth, r = radius);
                        translate( [width - radius,0,0] )
                            rotate( [ 90, 0, 0 ] )
                                cylinder( h=depth, r = radius);
                         translate([radius,-depth,0])
                             cube([width - radius*2, depth, radius]);
                     }
             }
             
             // clip off any excess so that if the radius is larger than the height we stay
             // within the block dimensions 
             translate( [0,-depth,0] )
                cube( [ width, depth, height ] );
         }
}

difference() {
    // create bulk of shape
    union() {
        cube( [ width, total_depth, frame_overlap ] );
        translate([0,total_depth,frame_overlap]) 
            block_with_rounded_corners( width, top_height, total_depth, radius );
    }
    
    // subtract slot for attachment to frame
    translate( [ -1, (total_depth - frame_depth)/2, -1 ] )
        cube( [ width + 2, frame_depth, frame_overlap + 1 ] );
    
    // subtract hole for PTFE filament guide tube
    translate( [width/2, total_depth + 1, frame_overlap + gap + tube_od/2] )
      rotate( [ 90, 0, 0 ] )
        cylinder( h=total_depth + 2, d=tube_od );
}

