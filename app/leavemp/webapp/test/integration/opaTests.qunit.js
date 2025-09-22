sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'lmp/aj/leavemp/test/integration/FirstJourney',
		'lmp/aj/leavemp/test/integration/pages/LeaveRequestsMain'
    ],
    function(JourneyRunner, opaJourney, LeaveRequestsMain) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('lmp/aj/leavemp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheLeaveRequestsMain: LeaveRequestsMain
                }
            },
            opaJourney.run
        );
    }
);