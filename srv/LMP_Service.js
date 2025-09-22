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
      item.Criticality = 3;
    }
  });
    return data;
    
  })
     srv.before("READ", Users, async (req) => {
   const user = req.user.id;
  })
  srv.on("READ", Users, async (req) => {
    const data = await cds.run(req.query);
    return data;
  })
  
}
