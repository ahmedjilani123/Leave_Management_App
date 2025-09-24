using {Leave_Management_App.db as db} from '../db/LMP_Schema';

service LeaveManagementSrv @(requires:'authenticated-user') {
 @odata.draft.enabled

  entity LeaveRequests  @(restrict: [
    { grant: ['READ','CREATE','UPDATE','DELETE'], to: ['User'],where :'User.Email = $user' },
    { grant: ['*'], to: ['admin'] },                                      
    { grant: ['READ','UPDATE'], to: ['manager'] } 
  ]) as projection on db.LeaveRequest
  actions{
    action approveLeaveRequest(Comments:String) returns LeaveRequests;
   action rejectLeaveRequest() returns String;
  };

@odata.draft.enabled
  entity Users @(restrict: [
    { grant: ['READ','CREATE','UPDATE','DELETE'], to: ['admin'] },                                       
    { grant: ['READ','UPDATE'], to: ['User'] ,where :'User.Email = $user'}, 
    { grant: ['READ','UPDATE'], to: ['manager'] }                                  
  ]) as projection on db.User_Data;
}

annotate LeaveManagementSrv.LeaveRequests with @(
  UI:{
    SelectionFields  : [
      
        User.UserName, Status,LeaveType
    ],
      LineItem  : [
          {
            
              $Type : 'UI.DataField',
              @UI.Importance : #High,
              
              Value : UserName
          },
        {
            $Type : 'UI.DataField',
            @UI.Importance : #High,
            Value : Reason,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'LeaveManagementSrv.approveLeaveRequest',
            Label : 'Approved',
            Criticality : #Positive
        },
        {
            $Type : 'UI.DataField',
            @UI.Importance : #High,
            Value : LeaveType,
        },
       
        {
            $Type : 'UI.DataField',
            Value : Status,
           @UI.Importance : #High,
            Criticality:Criticality
        }
      ],
      FieldGroup #BasicInfo : {
          $Type : 'UI.FieldGroupType',
          Label : 'Basic Information',
          Data : [
            {
                $Type : 'UI.DataField',
                Value : Reason,
                Label : 'Reason for Leave'
            },
            {
                $Type : 'UI.DataField',
                Value : LeaveType,
                Label : 'Leave Type'
            },
             
          ]
      },
     FieldGroup #leaveDetails : {
         $Type : 'UI.FieldGroupType',
          Label : 'Leave Details',
          Data : [
            {
                $Type : 'UI.DataField',
                Value : RemainingLeaves,
                Label : 'Remaining Leaves'
            },
            {
                $Type : 'UI.DataField',
                Value : TotalDays,
                Label : 'Total Days'
            },
            {
                $Type : 'UI.DataField',
                Value : StartDate,
                Label : 'Start Date'
            },
            {
                $Type : 'UI.DataField',
                Value : EndDate,
                Label : 'End Date'
            },
            {
                $Type : 'UI.DataField',
                Value : IsHalfDay,
                Label : 'Is Half Day'
            },
            {
                $Type : 'UI.DataField',
                Value : HalfDayType,
                Label : 'Half Day Type'
            }
          ]
     },
     Facets  : [
         {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#leaveDetails',
             ID : 'leaveDetailsID',
              Label : 'Leave Details'
         },
         {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#BasicInfo',
              ID : 'BasicInfoID',
                Label : 'Basic Information'
         },
     ]
  }
) ;
annotate LeaveManagementSrv.Users with @(
  UI:{
    SelectionFields  : [
        UserName,Email
    ],
      LineItem  : [
          {
              $Type : 'UI.DataField',
              Value : UserName
          },
        {
            $Type : 'UI.DataField',
            Value : Email,
        },
        {
            $Type : 'UI.DataField',
            Value : FirstName,
        },
        {
            $Type : 'UI.DataField',
            Value : LastName,
        },
        {
            $Type : 'UI.DataField',
            Value : Role,
        }
      ]
  }
) ;

