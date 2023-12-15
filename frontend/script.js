function createGroup() {
    var groupName = document.getElementById('createGroupName').value;
    var numberOfProcesses = document.getElementById('numberOfProcesses').value;
  
    var xhr = new XMLHttpRequest();
    xhr.open("POST", '/start', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
      "group_name": groupName,
      "number_of_processes": numberOfProcesses
    }));
  
    xhr.onload = function() {
      if (xhr.status == 200) {
        // Create a new div for the group
        var groupDiv = document.createElement('div');
        groupDiv.className = 'group';
        groupDiv.innerHTML = '<h2>' + groupName + '</h2>';
  
        // Add process names to the div
        for (var i = 0; i < numberOfProcesses; i++) {
          var processName = 'Process ' + (i + 1);
          var processP = document.createElement('p');
          processP.textContent = processName;
          groupDiv.appendChild(processP);
        }
  
        // Add the div to the groups container
        var groupsContainer = document.getElementById('groupsContainer');
        groupsContainer.appendChild(groupDiv);
      }
    };
  }
  