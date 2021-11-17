function doGet(e) {
  var sheetId = '1lb2zwoIghfjyf48ZuE_l0lN8T6lRMIpr76cP2QVOX4I';
  var name = e.parameter.name;
  var email = e.parameter.email;
  var func = e.parameter.func;
  var rowIndex = e.parameter.rowIndex;
  var lock = e.parameter.lock;
  var res = { "value": sheetId };

  try {
    var sheet = SpreadsheetApp
      .openById(sheetId).getSheetByName("Users");
    var d = new Date();
    var data = sheet.getDataRange().getValues();
    var length = data.length;
    if (func == 'signUp') {
      var timeStamp = d.toLocaleTimeString();
      var rowDate = sheet.appendRow([name, email, timeStamp, "none"]);
      res = {
        "index": length + 1,
        "lock": "none",
        "error": "none",
      };
    }
    else if (func == 'lock') {
      var cell = sheet.getRange(rowIndex, 4);
      cell.setValue(lock);
      res = {
        "index": "none",
        "lock": lock,
        "error": "none"
      };
    }
    else if (func == 'signIn') {
      for (var i = 0; i < data.length; i++) {
        if (data[i][1] == email) {
          res = {
            "index": i,
            "lock": data[i][3],
            "error": "none"
          };
        }
      }
    }

  } catch (ex) {
    res = {
      "index": "none",
      "lock": "none",
      "error": ex['name']
    }
  }
  return ContentService.createTextOutput(JSON.stringify(res)).setMimeType(ContentService.MimeType.JSON);
}
