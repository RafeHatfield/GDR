  /******************************
  * Editable section -- Start --
  ******************************/
  // DATE SETTINGS - EDIT AS REQUIRED
  var daysinAdvance = 7; // Sets default days in advance from current date
  var numberNights = 2;  // Sets default number of nights
  var numberYears = 4; // Sets default number of years to display in year select list
  var numberNightsMin = 1; // Sets minimum number of nights accepted
  var imgDir = "assets/globekey/"; // Directory for the dynamic calendar script and images. Trailing slash must be included.

  // FLAG SETTINGS ON/OFF - SET TO 1 FOR ON & 0 FOR OFF
  var wdDisplay = 0; //weekday display
  var numberNightsDisplay = 0; //number of nights display
  var departDateDisplay = 1; //departure dates display
  var departDateUpdate = 1; //auto update departure date

  // WEEK DAY AND NUMBER NIGHTS TEXT - EDIT TEXT AS REQUIRED
  var wdArray = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
  var nightTxt = " Night";
  var nightsTxt = " Nights";

  // ERROR MESSAGE TEXT - EDIT TEXT AS REQUIRED
  var invalidDateTxt = "Invalid Arrival Date. Please check number of days selected";
  var invalidDatePriorTxt = "Arrival Date selected is prior Today's date. Please change...";
  var invalidDepartDateTxt = "Invalid Departure Date. Please check number of days selected";
  var invalidDepartTxt = "Departure Date is prior to Arrival Date selected. Please change...";
  var invalidNightsTxt = "Sorry, reservations under "+numberNightsMin+" nights are not accepted.";
  /******************************
  * Editable section -- End --
  ******************************/

  /**************************************************
  * DO NOT CHANGE JAVASCRIPT SETTINGS BELOW THIS LINE
  **************************************************/
  //Days in each month Array
  var aNumDays = new Array (31,0,31,30,31,30,31,31,30,31,30,31);

  //Cancel out if no departure date display
  if(departDateDisplay == 0) {
    numberNightsDisplay = 0;
    departDateUpdate = 0;
  }

  //Sets dates selected from dyncalendar
  function calendarCallback(day, month, year, objName, formName) {
    if(objName == "calendarArrive"){
      document.forms[formName].fd.selectedIndex = day-1;
      document.forms[formName].fm.selectedIndex = month-1;
      document.forms[formName].fy.selectedIndex = year - document.forms[formName].fy.options[0].text;
      updateDates(document.forms[formName]);
      if(wdDisplay == 1) setWkd(formName, 1);
    }else{  //objName == calendarDepart
      document.forms[formName].td.selectedIndex = day-1;
      document.forms[formName].tm.selectedIndex = month-1;
      document.forms[formName].ty.selectedIndex = year - document.forms[formName].ty.options[0].text;
      if(wdDisplay == 1) setWkd(formName, 1);
    }
  }

  //Update form with selected dates
  function updateDates(form, loadDates) {
    //check Leap Year
    if(form.fm.selectedIndex==1)  {
      var leapYear  = new Date (form.fy.options[form.fy.selectedIndex].text,form.fm.selectedIndex+1,1);
      var leapYear  = new Date (leapYear  - (24*60*60*1000));
      var numDaysInMonth = leapYear.getDate();
    }else{
      var numDaysInMonth = aNumDays[form.fm.selectedIndex];
    }
    // Update departure date only when loading the form and/or departDateUpdate is set to 1
    if(loadDates == 1 || departDateUpdate == 1) {
      var selectDate = new Date(form.fy.options[form.fy.selectedIndex].text, form.fm.selectedIndex, form.fd.selectedIndex);
      var setDate = new Date(selectDate.getTime() + ((numberNights+1) * 86400000));
      var setDay = setDate.getDate();
      var setMonth = setDate.getMonth();
      var setYear = setDate.getFullYear() - form.fy.options[0].text;
      var checkinDate = new Date(form.fy.options[form.fy.selectedIndex].text,form.fm.selectedIndex,form.fd.selectedIndex+1);
      var checkoutDate = new Date(form.ty.options[form.ty.selectedIndex].text,form.tm.selectedIndex,form.td.selectedIndex+1);
      if(checkinDate > checkoutDate) {
        if(setYear == form.ty.length) {
          form.td.options[30].selected=1;
          form.tm.options[11].selected=1;
          form.ty.options[form.ty.length-1].selected=1;
        } else {
          form.td.options[setDay-1].selected=1;
          form.tm.options[setMonth].selected=1;
          form.ty.options[setYear].selected=1;
        }
      }
    }
    if(form.fd.selectedIndex+1 > numDaysInMonth) {
      alert(invalidDateTxt);
      form.fd.selectedIndex = numDaysInMonth-1;
    }
  }

  function setWkd(form, calendar) {
    // change form object if returned from calendar
    if(calendar) form = document.forms[form];
    for (var i = 0; i < form.fy.length; i++) {
      if (form.fy.options[i].selected) var fyear = form.fy.options[i].text;
      if (departDateDisplay == 1 && form.ty.options[i].selected) var tyear = form.ty.options[i].text;
    }
    var checkinDate = new Date(fyear,form.fm.selectedIndex,form.fd.selectedIndex+1);
    if (departDateDisplay == 1) var checkoutDate = new Date(tyear,form.tm.selectedIndex,form.td.selectedIndex+1);
    var numNights = Math.round((checkoutDate - checkinDate) / 86400000);
    if (numNights == 1) numNights += nightTxt;
    else numNights += nightsTxt;
    //Set Days of the week display
    if(wdDisplay == 1 && document.getElementById) {
      document.getElementById('inWd').firstChild.nodeValue = '(' + wdArray[checkinDate.getDay()] + ')';
      if (departDateDisplay == 1) document.getElementById('outWd').firstChild.nodeValue = '(' + wdArray[checkoutDate.getDay()] + ')';
    }
    //Set number of nights display
    if(numberNightsDisplay == 1 && document.getElementById) document.getElementById('lengthStay').firstChild.nodeValue = numNights;
  }

  //Load current dates on form load
  function LoadDates(form) {
    var curDate = new Date();
    var setDate = new Date(curDate.getTime() + (daysinAdvance * 86400000));
    var setDay = setDate.getDate();
    var setMonth = setDate.getMonth();
    var setYear = setDate.getFullYear() - form.fy.options[0].text;
    // Set Arrival Dates
    form.fd.selectedIndex = setDay-1;
    form.fm.selectedIndex = setMonth;
    form.fy.selectedIndex = setYear;
    // Set the Departure Dates
    updateDates(form, departDateDisplay);
    if(wdDisplay == 1 || numberNightsDisplay == 1) setWkd(form);
  }

  //Load current dates on form load
  function checkDates(form) {
    var curDate = new Date();
    for (var i = 0; i < form.fy.length; i++) {
      if (form.fy.options[i].selected) var fyear = form.fy.options[i].text;
      if (departDateDisplay == 1 && form.ty.options[i].selected) var tyear = form.ty.options[i].text;
    }
    var checkinDate = new Date(fyear,form.fm.selectedIndex,form.fd.selectedIndex+2);
    if (departDateDisplay == 1) {
      if(form.tm.selectedIndex==1)  {
        var leapYear  = new Date (form.ty.options[form.ty.selectedIndex].text,form.tm.selectedIndex+1,1);
        var leapYear  = new Date (leapYear  - (24*60*60*1000));
        var numDaysInMonth = leapYear.getDate();
      }else{
        var numDaysInMonth = aNumDays[form.tm.selectedIndex];
      }
      if(form.td.selectedIndex+1 > numDaysInMonth) {
        alert(invalidDepartDateTxt);
        form.td.selectedIndex = numDaysInMonth-1;
        return false;
      }
      var checkoutDate = new Date(tyear,form.tm.selectedIndex,form.td.selectedIndex+2);
      var numNights = Math.round((checkoutDate - checkinDate) / 86400000);
    } else {
      var numNights = form.numnights.selectedIndex+1;
    }
    if(checkinDate.getTime() < curDate.getTime()) {
      alert(invalidDatePriorTxt);
      return false;
    }
    if(numNights < 1) {
      alert(invalidDepartTxt );
      return false;
    }
    if(numNights < numberNightsMin) {
      alert(invalidNightsTxt);
      return false;
    }
  }

  //Generate years options for year select list
  function year_option(form){
    curDate = new Date();
    curYear = curDate.getFullYear();
    for(i = curYear ; i <= curYear+(numberYears-1) ; i++ ){
      document.write('<option value="' + i + '">' + i + '</option>');
    }
  }