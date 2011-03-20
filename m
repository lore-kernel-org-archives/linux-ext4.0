From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31542] New: ext4 : "No space left on the device" persists even
 when I deleted more than 40GB of data
Date: Sun, 20 Mar 2011 23:08:53 GMT
Message-ID: <bug-31542-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54886 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1CTXIy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 19:08:54 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2KN8reQ006978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 23:08:53 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=31542

           Summary: ext4 : "No space left on the device" persists even
                    when I deleted more than 40GB of data
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: tavvva@volny.cz
        Regression: No


1.) I recently filled my data partition full and got an error dialog, that
there's no space left on the device (Resume, Retry, Skip, Abort, ... don't
remember exactly)
2.) I used different terminal in order to move some of the big files (more than
40GB in total) from the affected partition to a different harddrive. But df was
still showing 0 bytes available.
3.) Even of that I tried to resume the copying mentioned in point 1.) and it
worked ... the copying was finished successfuly. What a magic!
4.) The situation changed after the reboot. I cannot copy new files to the
affected partition anymore even if there must be at least 30GB of space left.

This is what df returns:
-------------------------
Filesystem    1K-blocks    Used        Available    Use%    Mounted on
/dev/md6    1209519868    1175334268    0        100%    /mnt/data

The difference between total and used blocks gives more than 32GB and I'm sure
that yesterday this space was filled with data.

I'm willing to do any non-destructive tests and collect any debug logs You need
in order to find the root cause of this issue.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
