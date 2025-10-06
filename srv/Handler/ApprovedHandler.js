module.exports= async (req) => {
    const db = await cds.connect.to('db');
    const { LeaveRequest, User_Data} = db.entities;
    const {LeaveID} = req.params[0];
    const { Comments } = req.data;
    if(Comments === '' || Comments === undefined){
        req.error({code:400, message:'Comments is required to approve a leave request.',target:'in/Comments'});
        return;
    }
    const leaveRequests = await db.run(SELECT.from(LeaveRequest).where({ LeaveID }));
    if (leaveRequests.length === 0) {
      req.error(404, `Leave request with ID ${LeaveID} not found.`);
    }
    if (leaveRequests[0].Status === 'Approved') {
      req.error(400, `Only pending leave requests can be approved.`);
    }
const Admin = await db.run(SELECT.one.from(User_Data).where({ Email: req.user.id }));
    await db.run(UPDATE(LeaveRequest).set({ Status: 'Approved',ApprovedOn:new Date(), Comments: Comments ,ApprovedBy_UserID:Admin.UserID}).where({ LeaveID }));
    return req.data
    
  }