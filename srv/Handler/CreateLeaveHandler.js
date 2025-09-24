module.exports = async (req) => {
const db = await cds.connect.to('db');
const { LeaveRequest,User_Data } = db.entities;
    req.data.Status = 'Pending';
    const user = await db.run(SELECT.one.from(User_Data).where({ Email: req.user.id }));
    req.data.User_UserID = user.UserID;
    req.data.UserName = user.UserName;
    req.data.AppliedOn = new Date().toISOString().split('T')[0];
    const startDate = new Date(req.data.StartDate);
    const endDate = new Date(req.data.EndDate);
    if (endDate < startDate) {
        req.error({code:400, message:'EndDate cannot be before StartDate.',taget:'in/EndDate'});
    }

    const timeDiff = endDate.getTime() - startDate.getTime();
    let totalDays = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;
    if (req.data.IsHalfDay) {
        totalDays -= 0.5;
    }
    req.data.TotalDays = totalDays;

}