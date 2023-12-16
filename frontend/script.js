function createGroup() {
  var groupName = document.getElementById('createGroupName').value;
  var numberOfProcesses = document.getElementById('numberOfProcesses').value;

  // Create a new div for the group
  var groupDiv = document.createElement('div');
  groupDiv.className = 'group';

  // Add group name to the div
  var groupNameH2 = document.createElement('h2');
  groupNameH2.textContent = groupName;
  groupDiv.appendChild(groupNameH2);

  var addProccessBtn = document.createElement('button');
  addProccessBtn.textContent = 'Add Process';
  addProccessBtn.className = 'btn btn-primary';
  var deleteProcessBtn = document.createElement('button');
  deleteProcessBtn.textContent = 'Delete Process';
  deleteProcessBtn.className = 'btn btn-primary';
  var joinGroupBtn = document.createElement('button');
  joinGroupBtn.textContent = 'Join Group';
  joinGroupBtn.className = 'btn btn-primary';
  var leaveGroupBtn = document.createElement('button');
  leaveGroupBtn.textContent = 'Leave Group';
  leaveGroupBtn.className = 'btn btn-primary';
  var sendMessageBtn = document.createElement('button');
  sendMessageBtn.textContent = 'Send Message';
  sendMessageBtn.className = 'btn btn-primary';
  var sendMessageToGroupBtn = document.createElement('button');
  sendMessageToGroupBtn.textContent = 'Send Message to Group';
  sendMessageToGroupBtn.className = 'btn btn-primary';


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
  groupDiv.appendChild(addProccessBtn);
  groupDiv.appendChild(deleteProcessBtn);
  groupDiv.appendChild(joinGroupBtn);
  groupDiv.appendChild(leaveGroupBtn);
  groupDiv.appendChild(sendMessageBtn);
  groupDiv.appendChild(sendMessageToGroupBtn);
}