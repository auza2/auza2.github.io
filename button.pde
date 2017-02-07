// Class taken from http://processingjs.org/learning/topic/buttons/ but was altered
boolean locked = false;
class Button
{
  String name;
  int x, y;
  int size;
  PImage icon;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    println("you pressed" + name);
    return overCircle(x,y,size);
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int centerx, int centery, float radius) 
  {
    float disX = centerx - mouseX;
    float disY = centery - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < radius ) {
      return true;
    } 
    else {
      return false;
    }
  }
}


class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    
    stroke(highlightcolor); 
    fill(basecolor);
    ellipse(x, y, size, size);
  }
}