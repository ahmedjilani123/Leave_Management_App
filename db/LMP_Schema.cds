namespace Leave_Management_App.db;

using {managed} from '@sap/cds/common';

type LeaveStatus   : String enum {
    Pending;
    Approved;
    Rejected;
}

type HalfDayOption : String enum {
    FirstHalf;
    SecondHalf;
}

entity User_Data : managed {
    key UserID           : UUID;
        UserName         : String(100);
        Email            : String(100);
        Role             : String(50);
        Department       : String(100);
        DateOfJoining    : Date;
        IsActive         : Boolean;
        PhoneNumber      : String(15);
        EmergencyContact : String(100);
        Designation      : String(100);
        ManagerID        : Association to User_Data;
        Address          : String;
        Bio              : String(512);
        Skills           : String(256);
        Certifications   : String(256);
        SocialLinks      : String(256);
        Notes            : String(512);
        LeaveRequests    : Association to many LeaveRequest
                               on LeaveRequests.User = $self;
        UserImage        : Association to Attachment;

}

entity LeaveRequest : managed {
    key     LeaveID         : UUID;
            LeaveType       : String(50);
            StartDate       : Date;
            EndDate         : Date;
            UserName        : String(100);
            Reason          : String(256);
            Status          : LeaveStatus;
    virtual Criticality     : Integer;  //1,2,3
            AppliedOn       : DateTime;
            ApprovedBy      : Association to User_Data;
            ApprovedOn      : DateTime;
            Comments        : String(256);
            AttachmentURL   : String(256);
            IsHalfDay       : Boolean;
            HalfDayType     : HalfDayOption;
            TotalDays       : Decimal(5, 2);
            RemainingLeaves : Decimal(5, 2);
            User            : Association to User_Data;
}

entity Attachment {
    key ID       : UUID;
        Content  : LargeBinary  @Core.MediaType: FileType  @Core.ContentDisposition.Filename: FileName;
        FileName : String(256);
        FileType : String(50)   @Core.IsMediaType;
}
