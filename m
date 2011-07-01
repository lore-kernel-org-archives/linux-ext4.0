From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38642] New: ext4 timestamp format unable to uniquely represent
 times
Date: Fri, 1 Jul 2011 15:05:38 GMT
Message-ID: <bug-38642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51096 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1GAPFj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:05:39 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p61F5cbv004964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jul 2011 15:05:39 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38642

           Summary: ext4 timestamp format unable to uniquely represent
                    times
           Product: File System
           Version: 2.5
    Kernel Version: all
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ersmith.nospam@totalspectrum.ca
        Regression: No


The presence of the extra bits in the ext4 timestamps implies a desire to
represent file times to sub-second accuracy. Unfortunately, standard posix
timestamps are not uniformly 1 SI second long, due to the presence of leap
seconds. For example, the Posix timestamp 1230768000 corresponds to the UTC
times "2008-12-31 23:59:60" and "2009-01-01 00:00:00".

Since there are only 30 bits in the nanosecond field, ext4 cannot accurately
keep track of file times during a leap second.

One possible solution would be to add another bit to the nanosecond field,
allowing nanoseconds to range from 0 to 1999999999 and hence allowing
sufficient range to keep accurate time even during "long" posix timestamps.

Another would be to specify that the seconds fields of ext4 time stamps should
hold actual SI seconds elapsed, rather than POSIX timestamps; this would be
considerably more complicated, though.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
