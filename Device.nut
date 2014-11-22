local ignoreStandingSwitch = false;
local ignoreButton = false;
local lastStandingState = 0;
local lastButtonState = 0;
local waitingToggle = 0;

standingSwitch <- hardware.pin1;
led <- hardware.pin2;
button <- hardware.pin5;

function debounceStandingSwitch() {
  ignoreStandingSwitch = false;
  standingSwitchPress(true);
}

function debounceButton() {
  ignoreButton = false;
  buttonPress(true);
}

function standingSwitchPress(calledFromDebounce = false) {
  if(!ignoreStandingSwitch)
  {
    local switchState = standingSwitch.read();
    if (switchState == 1) { server.log("standing " + switchState);
    } else { server.log("sitting " + switchState); }
    
    if (switchState != lastStandingState){
      local switchStatus = "StandingDeskSwitch," + switchState;
      agent.send("data", switchStatus);
      lastStandingState = switchState;
      led.write(switchState);
    }
    
    if (!calledFromDebounce){
      ignoreStandingSwitch = true;
      imp.wakeup(0.05, debounceStandingSwitch);
    }
  }
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
        waitingToggle = 1-waitingToggle;
        led.write(waitingToggle);
        local buttonStatus = "WaitButton," + waitingToggle;
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
 
standingSwitch.configure(DIGITAL_IN_PULLUP, standingSwitchPress);
button.configure(DIGITAL_IN_PULLUP, buttonPress);
led.configure(DIGITAL_OUT);
