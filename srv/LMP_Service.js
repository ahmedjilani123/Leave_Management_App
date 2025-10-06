const cds = require('@sap/cds');
const ApprovedHandler = require('./Handler/ApprovedHandler');
const ReadLeaveRequest = require('./Handler/ReadLeaveRequest');
const CreateLeaveHandler = require('./Handler/CreateLeaveHandler');

module.exports = async (srv) => {
  const { LeaveRequests ,Users} = srv.entities
  // ReadLeaveRequest -> Read Leave Requests with Criticality

  srv.on("READ", LeaveRequests,ReadLeaveRequest);

 // ApprovedHandler -> Update Leave Request Status to Approved

  srv.on("approveLeaveRequest",ApprovedHandler);
  
  srv.before("CREATE", LeaveRequests,CreateLeaveHandler)
}
