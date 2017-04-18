/****************************** Numpad -- Tran ********************************/
/***************************** Also used for date and time ********************/
class Numpad {
  
  // 10 number buttons
  int numSelected = -1;
  int currDateVal = 0;
  FeatureButton[] numFeature = new FeatureButton[10];
  String[] numName = {"", "", "", "", "", "", "", "", "", ""};
  String[] numClicked = {"0_clicked.png", "1_clicked.png", "2_clicked.png", "3_clicked.png", "4_clicked.png", "5_clicked.png", "6_clicked.png", "7_clicked.png", "8_clicked.png", "9_clicked.png"};
  String[] numUnclicked = {"0.png", "1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png"};
  String[] numVal = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
  String[] numPlaceHolder = {"","","","","","","","",""};
  String[] numPlaceHolder2 = {"","","","","","","","",""};
  
  void numpad_show()
  {
    // Display the numpad
    for(int i = 0; i < numName.length; i++){
        numFeature[i].display();
        if(numSelected != -1 && numFeature[i].isClicked == true){
          numFeature[i].displayExpanded();
        }
     }
     
     // Text for date
     text("_ _ _ _ _ _", 250, 446);
     text("/", 334, 446);
     text("/", 434, 446);
     
     // set so text will appear in correct location
     text(numPlaceHolder[0], 250 + 50 * 0, 446);
     text(numPlaceHolder[1], 250 + 50 * 1, 446);
     text(numPlaceHolder[2], 250 + 50 * 2, 446);
     text(numPlaceHolder[3], 250 + 50 * 3, 446);
     text(numPlaceHolder[4], 250 + 50 * 4, 446);
     text(numPlaceHolder[5], 250 + 50 * 5, 446);
     
     // Text for time
     text("_ _ _ _", 250, 1082);
     text(":", 332, 1082);
     text(numPlaceHolder2[0], 250 + 50 * 0, 1082);
     text(numPlaceHolder2[1], 250 + 50 * 1, 1082);
     text(numPlaceHolder2[2], 250 + 50 * 2, 1082);
     text(numPlaceHolder2[3], 250 + 50 * 3, 1082);

  }
  
  void numpad_released()
  {
     // Checking which nums will be pressed
    int previouslySelectednum = numSelected;
    for(int i = 0; i < numFeature.length; i++){
      if(numFeature[i].pressedNum()){
        
          // Sets the previous selected feature to false
         if( previouslySelectednum != -1){
             numFeature[previouslySelectednum].isClicked = false;
         }
         
         numFeature[i].isClicked = true;
         numSelected = i;
         numPlaceHolder[currDateVal] = numVal[numSelected];
         currDateVal += 1;
         if(currDateVal > 5)
         {
           currDateVal = 0;
         }
         break;     
      }
    }
  }
  
  void translate_date()
  {
    
  }
}