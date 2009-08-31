From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14094] New: Ext4 NULL pointer reference in mb_cache function
Date: Mon, 31 Aug 2009 09:24:39 GMT
Message-ID: <bug-14094-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53515 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZHaJYh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 05:24:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7V9Od7R008494
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 09:24:40 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14094

           Summary: Ext4 NULL pointer reference in mb_cache function
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31-rc8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: suokkos@gmail.com
        Regression: No


Created an attachment (id=22922)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22922)
lspci for hardware details.

How bug was caused?

I did run apt-get upgrade in background while starting up firefox and pidgin.
Now there went something wrong in ext4. So I don't know exactly how to
reproduce this.

Reproducing?

Only once just a few minutes ago.

Version where this was seen?

Vanilla kernel v2.6.31-rc7 just a commit before tagging rc8 with a via agp
driver bug patch.

User land is Ubuntu Karmic.

Disk file system was upgraded from ext3 partition.

Debug info?

Sorry. all was lost because file system crashed so I could write it locally or
upload anywhere. I did try to upload it using ssh but that killed my last
working console so I have to do forced shutdown.

So all you have now left is my bad memory that remembers back trace in ext4
mb_*cache*. Which then caused a lot of warnings about scheduling while atomic.

If I can reproduce this I will next time take a photo before trying anything
else.

I'm just about to upgrade to the latest code even tough list of changes don't
look like affecting this.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
