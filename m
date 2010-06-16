From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16223] New: ext4 in data=journal mode does not support delayed
 allocation
Date: Wed, 16 Jun 2010 00:18:02 GMT
Message-ID: <bug-16223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34932 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab0FPASF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jun 2010 20:18:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5G0I2at016355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jun 2010 00:18:02 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16223

           Summary: ext4 in data=journal mode does not support delayed
                    allocation
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: theosib@gmail.com
        Regression: No


Perhaps you could argue that someone using data=journal mode doesn't care about
write performance, but that would not necessarily be the case.  It would be
really nice if I could use ext4 with data journaling AND get delayed
allocation.  I'm just mentioning this because I'm probably not the only one out
there with this feeling.  In fact, I know I'm not because I've seen the
question asked in forums.

I suspect it might be nontrivial to modify the journaling system so that you
can write data to the journal that has not yet been allocated a location on the
disk, but it seems to me that's basically what you'd have to do.  (Otherwise it
wouldn't be DELAYED allocation, and we need data to hit the journal before it
hits the fs proper.)  Data would be written to the journal, then when it's
going to be committed to the fs, it would be allocated (and that fact added to
the journal?).  If the system goes down, and a journal replay is required, then
the data would be allocated space at that time.  One thing to be concerned
about is having an allocation happen, the data not written to where it's
allocated, and the allocation not logged in the journal--on replay, you might
allocate yet more space for the data, and you'd need some means to recover the
first allocation that's now bogus.

Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
