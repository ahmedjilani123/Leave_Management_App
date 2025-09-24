module.exports = async (req) => {
  const db = await cds.connect.to("db");
  const { LeaveRequest } = db.entities;
  let data;
  if (req.user.is("admin") || req.user.is("manager")) {
    data = await db.run(
      SELECT.from(LeaveRequest).where`Status = 'Pending' OR Status = 'Rejected'`
    );
  } else {
    data = await db.run(req.query);
  }
  let array = Array.isArray(data) ? data : [data];
  array.forEach((item) => {
    if (item.Status === "Pending") {
      item.Criticality = 2;
    } else if (item.Status === "Approved") {
      item.Criticality = 3;
    } else if (item.Status === "Rejected") {
      item.Criticality = 1;
    }
  });
  return data;
};
