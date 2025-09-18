const cds = require('@sap/cds')

module.exports = async (srv) => {
  const { LeaveRequests ,Users} = srv.entities
   srv.before("READ", LeaveRequests, async (req) => {
   const user = req.user.id;
  })
  srv.on("READ", LeaveRequests, async (req) => {
     const userEmail = req.user.id           
    const roles = req.user.roles || []
    if (req.user.is("admin")) {
      return await cds.run(req.query)
    }
    if (req.user.is("manager")) {
      const manager = await cds.run(
        SELECT.one.from(Users).where({ Email: userEmail })
      )
      if (!manager) return req.reject(403, "Manager not found")

      const datas = await cds.run(
        SELECT.from(LeaveRequests).where({ 'User.ManagerID_UserID': manager.UserID })
      )
      return datas;
    }
    const employee = await cds.run(
      SELECT.one.from(Users).where({ Email: userEmail })
    )
    if (!employee) return req.reject(403, "User not found in Users")
    const datasuser = await cds.run(
      SELECT.from(LeaveRequests).where({ User_UserID: employee.UserID })
    )
    return datasuser;
  })
     srv.before("READ", Users, async (req) => {
   const user = req.user.id;
  })
  srv.on("READ", Users, async (req) => {
    const data = await cds.run(req.query);
    return data;
  })
  
}
