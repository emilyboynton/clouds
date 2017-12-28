import java.util.Map;
import java.util.List;
import java.util.Random;

JSONArray json;

//  TO DO
//  1. create hashmap for the output clouds & count
//      A. also add new var/cond for count
//  2. maybe hash them? also maybe colors?
//  3. rework the pos/neg values
//  4. copy over data.csv and start new one --why?
//  5. THEN reorganize/group function types
//  6. comment up this bitch and remove legacy code/ prints
//  7. rename variables sz, feeling, etc more accurately 
//  8. check edge cases, make sure you've seen all colors/cloud names

float sz = random(1, 2);
String [] positive_words, negative_words, clouds;

float x1, y1, x2, y2; // function domain
float step, y; // step = step within domain

int pos_size, neg_size, clouds_size;

//only used in pdj d_pdj functions
float pdj_a = random(1, 3);
float pdj_b = random(-3, 2);
float pdj_c = random(-3, 2);
float pdj_d = random(-1, 1);

//
String feeling, cloud_name;



HashMap<String, Integer> used_clouds = new HashMap<String, Integer>();

int st;
String pos_or_neg;
boolean go = true;

float amount = random(1, 2);
int func_type = floor(random(1, 21));


int background, foreground;

void setup() {
  size(600, 600);
  smooth(8);
  noFill();
  strokeWeight(0.9);
  println(func_type);
  println(sz + ", " + amount);
  
  
  json = loadJSONArray("new_pos_list.json");
  positive_words = json.getStringArray();
  pos_size = json.size();
  
  json = loadJSONArray("new_neg_list.json");
  negative_words = json.getStringArray();
  neg_size = json.size();
  
  json = loadJSONArray("clouds.json");
  clouds = json.getStringArray();
  clouds_size = json.size();
  
  //~~~~~~~~~~~~~~~~~GET BACKGROUND/SKY COLOR~~~~~~~~~~~~~~~~~~~~~
    json = loadJSONArray("colors.json");
    int rand = floor(random(0, json.size()));
    JSONObject background_obj = json.getJSONObject(rand);
    println(background_obj.getString("name"));
    String background_name = background_obj.getString("name");
    background = color(background_obj.getInt("red"), background_obj.getInt("green"), background_obj.getInt("blue"));
    background(background);


  //~~~~~~~~~~~~~~~~~GET FOREGROUND/CLOUD COLOR~~~~~~~~~~~~~~~~~~~~~
    JSONObject drawColors_obj = background_obj.getJSONObject("draw_colors");  
    String foreground_name = background_name;
    while (foreground_name == background_name){
      rand = floor(random(0, json.size()));
      JSONObject foreground_obj = json.getJSONObject(rand);
      foreground_name = foreground_obj.getString("name");    
      pos_or_neg = drawColors_obj.getString(foreground_name);
      foreground = color(foreground_obj.getInt("red"),
      foreground_obj.getInt("green"),
      foreground_obj.getInt("blue"),
      foreground_obj.getInt("alpha"));
    }
    
    println(foreground_name, pos_or_neg);
  
  stroke(foreground);  
  x1=y1=-sz;
  x2=y2=sz;
  y=y1;
  step=(x2-x1)/(3.321*width);
}

void draw() {
  if (go) {
    for (int i=0; (i<20) && go; i++) { // draw 20 lines at once
      for (float x=x1; x<=x2; x+=step) {
        drawVariation(x, y);
      }
      y+=step;
      if (y>y2) {
        go = false;
        if (pos_or_neg == "pos"){
          nameCloud(positive_words, pos_size);
        }
        else {
          nameCloud(negative_words, neg_size);
        }
      }
    }
  }
}
 
 
 
void nameCloud(String word_list[], int list_size){
  feeling = word_list[(floor(random(0, list_size + 1)))];
  cloud_name = feeling + clouds[floor(random(0, clouds.length))] + ".jpg";
  println(cloud_name);
}
 
 
 
//~~~~~~~~~~~~~~~~~DRAW CASES~~~~~~~~~~~~~~~~~~~~~
 
 
void drawVariation(float x, float y) {
  PVector v = new PVector(x,y);
 
  switch(func_type){
    case 1:
      v = addF(sinusoidal(v,amount), pdj(v, amount));
      break;
    case 2:
      v = addF(hyperbolic(v,amount), pdj(v, amount));
      break;
    case 3:
      v = subF(pdj(v, amount), sinusoidal(v, amount));
      break;
    case 4:
      v = addF(julia(julia(v,amount), amount), pdj(pdj(v, amount), amount));
      break;
    case 5:
      v = addF(sinusoidal(v,amount), pdj(v, amount));
      v = addF(sinusoidal(v,amount), julia(pdj(v,amount), amount ));
      break;
    case 6:
      v = addF(julia(v,amount),pdj(v, amount));
      break;
    case 7:
      v = subF(d_pdj(v, amount), pdj(julia(v, amount), amount));
      break;
    case 8:
      v = subF(pdj(pdj(v, amount), amount), julia(v, amount));
      break;
    case 9:
      v = subF(sinusoidal(julia(v, amount), amount), pdj(sinusoidal(v, amount), amount));
      //v = pdj(v, amount);
      break;
    case 10:
      v = sinusoidal(julia(d_pdj(v, amount), amount), amount);
      v = pdj(v, amount);
      break;
    case 11:
      v = julia(d_pdj(pdj(v, amount), amount), amount);
      break;
    case 12:
      v = pdj(julia(pdj(v, amount), amount), amount);
      break;
    case 13:
      v = addF(pdj(v, amount), pdj(julia(v, amount), amount));
      break;
    case 14:
      v = addF(d_pdj(d_pdj(v, amount), amount), julia(v, amount));
      break;
    case 15:
      v = subF(d_pdj(v, amount), julia(v, amount));
      break;
    case 16:
      v = subF(julia(v, amount), d_pdj(v, amount));
      break;
    case 17:
      v = julia(pdj(julia(hyperbolic(pdj(v, amount), amount), amount), amount), amount);
      break;
    case 18:
      v = addF(d_pdj(d_pdj(v, amount), amount), julia(julia(v, amount), amount));
      break;
    case 19:
      v = subF(sinusoidal(hyperbolic(v, amount), amount), hyperbolic(d_pdj(v, amount), amount));
      break;
    case 20:
      v = pdj(pdj(v, amount), amount);
      break;
      
  }
    // this all but ensures some of the function will be onscreen
    // it creates a tiling effect with a to-be determined offest
    v.x = (v.x - x1) % (x2-x1);
    if(v.x<0) v.x += (x2-x1);
    v.y = (v.y - y1) % (y2-y1);
    if(v.y<0) v.y += (y2-y1);
    v.x += x1;
    v.y += y1;
  //v = addF(sinusoidal(v,amount), pdj(v, amount));
  
  // draws the functions with an offset for the tiled effect
  // original values are (...0, width/height)
  float xx = map(v.x+0.003*randomGaussian(), x1, x2, -100, width+100);
  float yy = map(v.y+0.003*randomGaussian(), y1, y2, -100, height+100);
  point(xx, yy);
}


//maybe have these in a separate file too?????????????????
PVector sinusoidal(PVector v, float amount) {
  return new PVector(amount * sin(v.x), amount * sin(v.y));
}

PVector hyperbolic(PVector v, float amount) {
  float r = v.mag() + 1.0e-10;
  float theta = atan2(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return new PVector(x, y);
}

PVector pdj(PVector v, float amount) {
  return new PVector( amount * (sin(pdj_a * v.y) - cos(pdj_b * v.x)),
                      amount * (sin(pdj_c * v.x) - cos(pdj_d * v.y)));
}

PVector julia(PVector v, float amount) {
  float r = amount * sqrt(v.mag());
  float theta = 0.5 * atan2(v.x, v.y) + (int)(2.0 * random(0, 1)) * PI;
  float x = r * cos(theta);
  float y = r * sin(theta);
  return new PVector(x, y);
}

PVector d_pdj(PVector v, float amount) {
  float h = 0.1; // step
  float sqrth = sqrt(h);
  PVector v1 = pdj(v, amount);
  PVector v2 = pdj(new PVector(v.x+h, v.y+h), amount);
  return new PVector( (v2.x-v1.x)/sqrth, (v2.y-v1.y)/sqrth );
}

PVector addF(PVector v1, PVector v2) { return new PVector(v1.x+v2.x, v1.y+v2.y); }
PVector subF(PVector v1, PVector v2) { return new PVector(v1.x-v2.x, v1.y-v2.y); }
PVector mulF(PVector v1, PVector v2) { return new PVector(v1.x*v2.x, v1.y*v2.y); }
PVector divF(PVector v1, PVector v2) { return new PVector(v2.x==0?0:v1.x/v2.x, v2.y==0?0:v1.y/v2.y); }


/// NUMBERS THAT ARENT BROKE 
//float pdj_a = 1.82;
//float pdj_b = 2.5;
//float pdj_c = -2.99;
//float pdj_d = 0.9;

//x1=y1=-4.5;
//x2=y2=4.5;
  
//float amount = 2.2;

//THE FOLLOWING MAYBE CONTAIN:
//v = addF(sinusoidal(v,amount), pdj(v, amount));


////// I LIKE THIS
//      v = divF(sinusoidal(v, amount), pdj(v, amount));

/////ALSO THESE
//       v = pdj(julia(v,amount), amount );
 //     v = hyperbolic(sinusoidal(v, amount), amount);
 
//
//       v = addF(sinusoidal(v,amount), pdj(v, amount));
      // v = julia(pdj(v,amount), amount );
      
      
      
      //      v = divF(julia(v, amount), pdj(v, amount)); ///DEAD
      
     //stroke(20, 60, 100, 15);      //OG

      
   //case 5:
   //  background(222);
   //  stroke(115, 150, 220, 15);
   //  break;


//!!!!!!!!!!
//       v = sinusoidal(julia(d_pdj(v, amount), amount), amount);