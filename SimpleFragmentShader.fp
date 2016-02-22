#version 330 core

// Interpolated values from the vertex shaders
in vec2 fragmentUV;

// Values that stay constant
uniform sampler2D myTextureSamplerVolume;
uniform sampler2D myTextureSamplerNormals; // For normals-reading

uniform float rotationAngle;
uniform float isoValue;
uniform float specular_exponent; 


// Ouput data
out vec3 color;

// Input: z coordinate of the point in the volume, between 0 and 1
// Output: grid coordinates (i,j) of the slice where the point lies, between (0,0) and (9,9)
// Warning: use the fonction "floor" to make sure that the coordinates of the slice are integer. For instance, for z = 0.823, the function should return (i=2,j=8) because the closest slice is the 82nd one.
vec2 slice_coordinate(float z)
{
      //rescale z
      float z2 = z*100.;

      //coordinate of the slice
      float j = floor(z2/10.);
      float i = floor(z2 - 10.*j);

      return vec2(i,j);
}

// Input: (x,y,z) coordinates of the point in the volume, between (0,0,0) and (1,1,1)
// Output: (u,v) coordinates of the pixel in the texture
vec2 pixel_coordinate(float x, float y, float z)
{
      vec2 sliceCoord = slice_coordinate(z);

      //coordinate of the pixel in the slice
      float u = x/10.;
      float v = y/10.;

      return vec2(u,v)+slice_coordinate(z)/10.;
}

void main()
{ 
      vec2 pixCoord;
      float x,y,z;

/*
      //extract one horizontal slice (x and y vary with fragment coordinates, z is fixed)
      x = fragmentUV.x;
      y = fragmentUV.y;
      z = 82./100.; //extract 82nd slice
      pixCoord = pixel_coordinate(x,y,z);
      color = texture(myTextureSamplerVolume, pixCoord).rgb;
*/

/*
      //Accumulate all horizontal slices 
    x = fragmentUV.x;
    y = fragmentUV.y;
    color = vec3(0.0,0.0,0.0);
    for (int i=0; i<100; i++) {
        z = float((i+1)/100.); // extract the i th slice
        pixCoord = pixel_coordinate(x,y,z);
        color +=  texture(myTextureSamplerVolume, pixCoord).rgb/100.;
    }
*/

    
/*
      //extract one vertical slice (x and z vary with fragment coordinates, y is fixed)
    x = fragmentUV.x;
    z = fragmentUV.y;
    color = vec3(0.0,0.0,0.0);
    y = 20./256.; // extract the middle vertical slice
    pixCoord = pixel_coordinate(x,y,z);
    color +=  texture(myTextureSamplerVolume, pixCoord).rgb;
  
  */  

 
 /*
      //Accumulate all vertical slices (front view)
    x = fragmentUV.x;
    z = fragmentUV.y;
    color = vec3(0.0,0.0,0.0);
    for (int i=0; i<256; i++) {
        y = float((i+1)/256.); // extract the i th vertical slice
        pixCoord = pixel_coordinate(x,y,z);
        color +=  texture(myTextureSamplerVolume, pixCoord).rgb/256.;
    }
*/

/*
 //Accumulate all vertical slices after rotation by rotationAngle around the z axis
    //float rotationAngle = 0.7;
    float x1,y1;
    x = fragmentUV.x;
    z = fragmentUV.y;
    color = vec3(0.0,0.0,0.0);
    for (int i=0; i<256; i++) {
            y = float(i)/256.;
            // l'axe de rotation central doit rester invariant donc on recentre  puis on revient en 0.5,0.5 après rotation
        x1= (x-0.5)*cos(rotationAngle)+sin(rotationAngle)*(y-0.5)+0.5;
        y1= -(x-0.5)*sin(rotationAngle)+cos(rotationAngle)*(y-0.5)+0.5;
        pixCoord = pixel_coordinate(x1,y1,z);
        if ((texture(myTextureSamplerVolume, pixCoord).r > isoValue)&&(x1 >= 0.)&&(y1 >= 0.)&&(x1 <= 1.)&&(y1 <= 1.)) {
          color +=  texture(myTextureSamplerVolume, pixCoord).rgb/256.;  
        }
    }
*/

/*
     //Ray marching until density above a threshold (i.e., extract an iso-surface)
     float x1,y1;
     x = fragmentUV.x;
     z = fragmentUV.y;
     color = vec3(0.0,0.0,0.0);
     for (int i=0; i<256; i++) {
        y = float(i)/256.;
        // l'axe de rotation central doit rester invariant donc on recentre  puis on revient en 0.5,0.5 après rotation
        x1= (x-0.5)*cos(rotationAngle)+sin(rotationAngle)*(y-0.5)+0.5;
        y1= -(x-0.5)*sin(rotationAngle)+cos(rotationAngle)*(y-0.5)+0.5;
        pixCoord = pixel_coordinate(x1,y1,z);
        if((texture(myTextureSamplerVolume, pixCoord).r > isoValue)&&(x1 >= 0.)&&(y1 >= 0.)&&(x1 <= 1.)&&(y1 <= 1.)){
        	  color=vec3(1.0,1.0,1.0);
        	  break;
          }
    }

*/

/*
     //Ray marching until density above a threshold, display iso-surface normals
     float x1,y1;
     x = fragmentUV.x;
     z = fragmentUV.y;
     color = vec3(0.0,0.0,0.0);
     for (int i=0; i<256; i++) {
        y = float(i)/256.;
        // l'axe de rotation central doit rester invariant donc on recentre  puis on revient en 0.5,0.5 après rotation
        x1= (x-0.5)*cos(rotationAngle)+sin(rotationAngle)*(y-0.5)+0.5;
        y1= -(x-0.5)*sin(rotationAngle)+cos(rotationAngle)*(y-0.5)+0.5;
        pixCoord = pixel_coordinate(x1,y1,z);
        if((texture(myTextureSamplerVolume, pixCoord).r > isoValue)&&(x1 >= 0.)&&(y1 >= 0.)&&(x1 <= 1.)&&(y1 <= 1.)){
        	  color= texture(myTextureSamplerNormals, pixCoord).rgb;  // Not a white color anymore
        	  break;
          }
    }
	
  
*/

    // Phong model

   //Ray marching until density above a threshold, display shaded iso-surface
    float x1,y1;
    x = fragmentUV.x;
    z = fragmentUV.y;
    color = vec3(0.0,0.0,0.0);
    for (int i=0; i<256; i++) {
        y = float(i)/256.;
        // l'axe de rotation central doit rester invariant donc on recentre  puis on revient en 0.5,0.5 après rotation
        x1= (x-0.5)*cos(rotationAngle)+sin(rotationAngle)*(y-0.5)+0.5;
        y1= -(x-0.5)*sin(rotationAngle)+cos(rotationAngle)*(y-0.5)+0.5;
        pixCoord = pixel_coordinate(x1,y1,z);
         
        // Light direction and View direction - The light comes from the observer :
        vec3 viewDirection = vec3 (-sin(rotationAngle), cos(rotationAngle), 0.);
        vec3 L = normalize(viewDirection);
        vec3 V = normalize(viewDirection);
         
        // Normal Vector - The light coordinates are in [-1,1] so we have to map the coordinates from the gradient  :
        vec3 N = normalize(2.0*texture(myTextureSamplerNormals, pixCoord).rgb - 1.0);
         
        // Reflected view direction
        vec3 R = reflect(L,N);
         
        // Specular exponent
        int specular_exponent = 60;
        
        if((texture(myTextureSamplerVolume, pixCoord).r > isoValue)&&(x1 >= 0.)&&(y1 >= 0.)&&(x1 <= 1.)&&(y1 <= 1.)){
            color = max(dot(-L,N),0.0)*vec3(0.5,0.5,0.5) + pow(max(dot(R,V),0.0),specular_exponent)*vec3(1,1,1);
            break;
        }
      
    }
  


}
