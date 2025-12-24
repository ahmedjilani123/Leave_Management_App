using {Leave_Management_App.db as db} from '../db/LMP_Schema';

service LeaveManagementSrv @(requires: 'authenticated-user') {
  entity StatusM as projection on db.StatusM;
  @odata.draft.enabled

  entity LeaveRequests @(restrict: [
    {
      grant: [
        'READ',
        'CREATE',
        'UPDATE',
        'DELETE'
      ],
      to   : ['User'],
      where: 'User.Email = $user'
    },
    {
      grant: ['*'],
      to   : ['admin']
    },
    {
      grant: [
        'READ',
        'UPDATE'
      ],
      to   : ['manager']
    }
  ]) as projection on db.LeaveRequest
    actions {
      action approveLeaveRequest(Comments: String) returns LeaveRequests;
      action rejectLeaveRequest()                  returns String;
    };

  @odata.draft.enabled
  entity Users @(restrict: [
    {
      grant: [
        'READ',
        'CREATE',
        'UPDATE',
        'DELETE'
      ],
      to   : ['admin']
    },
    {
      grant: [
        'READ',
        'UPDATE'
      ],
      to   : ['User'],
      where: 'User.Email = $user'
    },
    {
      grant: [
        'READ',
        'UPDATE'
      ],
      to   : ['manager']
    }
  ]) as projection on db.User_Data;
}

annotate LeaveManagementSrv.LeaveRequests with @(UI: {
  SelectionFields         : [
    User.UserName,
    Status,
    LeaveType
  ],
  LineItem                : [
    {

      $Type         : 'UI.DataField',
      @UI.Importance: #High,

      Value         : UserName
    },
    {
      $Type         : 'UI.DataField',
      @UI.Importance: #High,
      Value         : Reason,
    },
    {
      $Type      : 'UI.DataFieldForAction',
      Action     : 'LeaveManagementSrv.approveLeaveRequest',
      Label      : 'Approved',
      Inline : true,
      @UI.Importance: #High

    },
    {
      $Type         : 'UI.DataField',
      @UI.Importance: #High,
      Value         : LeaveType,
    },

    {
      $Type         : 'UI.DataField',
      Value         : Status,
      @UI.Importance: #High,
      Criticality   : Criticality
    }
  ],
 
  FieldGroup #leaveDetails: {
    $Type: 'UI.FieldGroupType',
    Label: 'Leave Details',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: RemainingLeaves,
        Label: 'Remaining Leaves'
      },
      {
        $Type: 'UI.DataField',
        Value: TotalDays,
        Label: 'Total Days'
      },
      {
        $Type: 'UI.DataField',
        Value: StartDate,
        Label: 'Start Date'
      },
      {
        $Type: 'UI.DataField',
        Value: EndDate,
        Label: 'End Date'
      },
      {
        $Type: 'UI.DataField',
        Value: IsHalfDay,
        Label: 'Is Half Day'
      },
      {
        $Type: 'UI.DataField',
        Value: HalfDayType,
        Label: 'Half Day Type'
      },
       {
        $Type: 'UI.DataField',
        Value: Reason,
        Label: 'Reason for Leave'
      },
      {
        $Type: 'UI.DataField',
        Value: LeaveType,
        Label: 'Leave Type'
      }
    ]
  },
  FieldGroup #ApprovedBy  : {
    $Type: 'UI.FieldGroupType',
    Label: 'Approval Details',
    Data : [
      {
        $Type: 'UI.DataField',
        Label: 'Approved By',
        Value: ApprovedBy.Email
      },
      {
        $Type: 'UI.DataField',
        Value: ApprovedOn,
        Label: 'Approved On'
      },
      {
        $Type: 'UI.DataField',
        Value: Comments,
        Label: 'Comments'
      }
    ]

  },
  FieldGroup #UserInfo : {
      $Type : 'UI.FieldGroupType',
      Label : 'User Information',
      Data  : [
        {
            $Type : 'UI.DataField',
            Label : 'Name',
            Value : User.UserName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Email',
            Value : User.Email,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Phone Number',
            Value : User.PhoneNumber,
        },
         {
            $Type : 'UI.DataField',
            Value : User.Bio,
            Label : 'Bio'
        }
      ]
      
  },
  FieldGroup #UserCompInfo : {
      $Type : 'UI.FieldGroupType',
      Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Skills',
            Value : User.Skills
        },
         {
            $Type : 'UI.DataField',
            Value : User.Department,
            Label : 'Department'
        },
        {
            $Type : 'UI.DataField',
            Value : User.Designation,
            Label : 'Designation'
        },
        {
            $Type : 'UI.DataField',
            Value : User.DateOfJoining,
            Label : 'Date Of Joining'
        }
       
      ],
  },
  Facets                  : [
    {
      $Type : 'UI.ReferenceFacet',
      Target: '@UI.FieldGroup#ApprovedBy',
      ID    : 'ApprovedBysID',
      Label : 'Approval Details'
    },
    {
              $Type : 'UI.ReferenceFacet',
              ID : 'UserCompInfoID',
              Label : 'User Company Info',
              Target : '@UI.FieldGroup#UserCompInfo',
          },
    {
      $Type : 'UI.ReferenceFacet',
      Target: '@UI.FieldGroup#leaveDetails',
      ID    : 'leaveDetailsID',
      Label : 'Leave Details'
    }
  ],
 
  HeaderFacets  : [
     {
         $Type : 'UI.CollectionFacet',
          Label : 'User Details',

         Facets : [
          {
              $Type : 'UI.ReferenceFacet',
              ID : 'UserInfoID',
              Target : '@UI.FieldGroup#UserInfo',
          }
          
         ]
     },
  ],
  HeaderInfo                             : {
      TypeName      : 'Leave Request',
      TypeNamePlural: 'Leave Requests',
      TypeImageUrl  : 'sap-icon://customer',
      Title         : {
        $Type: 'UI.DataField',
        Value: UserName
      },
      Description   : {
        $Type: 'UI.DataField',
        Value: User.Skills
    }

  }
}){
  Status @(Common: {
		
		  ValueListWithFixedValues: true,
		  ValueList               : {
			CollectionPath: 'StatusM',
			Parameters    : [
			  {
				$Type            : 'Common.ValueListParameterInOut',
				LocalDataProperty: 'Status',
				ValueListProperty: 'Status'
			  }
			]
		  }
		} );
}

  	
	



annotate LeaveManagementSrv.Users with @(UI: {
  SelectionFields: [
    UserName,
    Email
  ],
  LineItem       : [
    {
      $Type: 'UI.DataField',
      Value: UserName
    },
    {
      $Type: 'UI.DataField',
      Value: Email,
    },
    {
      $Type: 'UI.DataField',
      Value: FirstName,
    },
    {
      $Type: 'UI.DataField',
      Value: LastName,
    },
    {
      $Type: 'UI.DataField',
      Value: Role,
    }
  ]
});
