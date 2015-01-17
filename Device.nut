local ignoreButton = false;
local lastButtonState = 0;
local workingToggle = 0;

led <- hardware.pin2;
button <- hardware.pin5;

function debounceButton() {
  ignoreButton = false;
  buttonPress(true);
}

function buttonPress(buttonCalledFromDebounce = false) {
  if (!ignoreButton){
    local buttonState = button.read();
    
    if (buttonState == 1) {
      server.log("button pressed: " + buttonState);
    } else { 
      server.log("button released: " + buttonState);
    }
    
    //ignore press if no change
    if (buttonState != lastButtonState){
      server.log("button changed: " + lastButtonState + " to " + buttonState);
      
      if (buttonState == 1) {
        workin = 1-workingToggle;
        led.write(workingToggle);
        local buttonStatus = "WaitButton," + workingToggle;
        agent.send("data", buttonStatus);
      }
      
      lastButtonState = buttonState;
    }  
    
    if (!buttonCalledFromDebounce) {
      ignoreButton = true;
      imp.wakeup(0.05, debounceButton);
    }
  }
}
 
button.configure(DIGITAL_IN_PULLUP, buttonPress);
led.configure(DIGITAL_OUT);

led.write(1); //Startup with light on