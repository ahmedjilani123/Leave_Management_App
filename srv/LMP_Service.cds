using {Leave_Management_App.db as db} from '../db/LMP_Schema';

service LeaveManagementSrv @(requires:'authenticated-user') {
@odata.draft.enabled
  @(restrict: [
    { grant: ['READ','CREATE','UPDATE'], to: ['User'],where :'User.Email = $user' },
    { grant: ['*'], to: ['admin'] },                                      
    { grant: ['READ','UPDATE'], to: ['manager'] } 
  ])
  entity LeaveRequests as projection on db.LeaveRequest;

  @(restrict: [
    { grant: ['*'], to: ['admin'] },                                       
    { grant: ['READ','UPDATE'], to: ['User'] }, 
    { grant: ['READ','UPDATE'], to: ['manager'] }                                  
  ])
  entity Users as projection on db.User_Data;

}

annotate LeaveManagementSrv.LeaveRequests with @(
  UI:{
    SelectionFields  : [
        User.@UserName, Status,LeaveType
    ],
      LineItem  : [
          {
              $Type : 'UI.DataField',
              Value : UserName
          },
        {
            $Type : 'UI.DataField',
            Value : Reason,
        },
        {
            $Type : 'UI.DataField',
            Value : LeaveType,
        },
        {
            $Type : 'UI.DataField',
            Value : TotalDays,
        },
        {
            $Type : 'UI.DataField',
            Value : StartDate,
        },
        {
            $Type : 'UI.DataField',
            Value : EndDate,
        },
        {
            $Type : 'UI.DataField',
            Value : Status,
            Criticality:Criticality
        }
      ]
  }
) ;
