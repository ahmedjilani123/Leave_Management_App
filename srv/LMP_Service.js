const cds = require('@sap/cds')

module.exports = async (srv) => {

  const { LeaveRequests ,Users} = srv.entities
   srv.before("READ", LeaveRequests, async (req) => {
   const user = req.user.id;
  })
  srv.on("READ", LeaveRequests, async (req) => {
    const data = await cds.run(req.query);
    let array = Array.isArray(data) ? data : [data];
    array.forEach(item => {
    if(item.Status === 'Pending'){
      item.Criticality = 2;
    }else if(item.Status === 'Approved'){
      item.Criticality = 3;
    }else if(item.Status === 'Rejected'){
      item.Criticality = 1;
    }
  });
    return data;
    
  })
  srv.before("UPDATE", LeaveRequests, async (req) => {

  })
  srv.before("CREATE", LeaveRequests, async (req) => {
    return req.data
  })
  srv.on("READ", Users, async (req) => {
    const data = await cds.run(req.query);
    return data;
  })

  srv.on("approveLeaveRequest", async (req) => {
    const db = await cds.connect.to('db');
    const {LeaveID} = req.params[0];
    const { Comments } = req.data;
    const leaveRequest = await db.run(SELECT.from(LeaveRequests).where({ LeaveID }));
    if (leaveRequest.length === 0) {
      req.error(404, `Leave request with ID ${LeaveID} not found.`);
    }
    if (leaveRequest[0].Status !== 'Pending') {
      req.error(400, `Only pending leave requests can be approved.`);
    }
const Admin = await db.run(SELECT.one.from(Users).where({ Email: req.user.id }));
    await db.run(UPDATE(LeaveRequests).set({ Status: 'Approved', Comments: Comments ,ApprovedBy_UserID:Admin.UserID}).where({ LeaveID }));
    return req.data
    
  })
  
}
