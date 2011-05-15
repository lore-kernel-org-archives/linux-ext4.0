From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35162] New: Kernel BUG when syncing ext2 if USB stick is
 removed
Date: Sun, 15 May 2011 17:36:32 GMT
Message-ID: <bug-35162-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42354 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1EORgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 May 2011 13:36:32 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4FHaWaJ028199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 17:36:32 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=35162

           Summary: Kernel BUG when syncing ext2 if USB stick is removed
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com
        Regression: Yes


Subject    : Kernel BUG when syncing ext2 if USB stick is removed
Submitter  : Torsten Hilbrich <torsten.hilbrich@secunet.com>
Date       : 2011-05-12 14:54
Message-ID : 4DCBF4B0.10607@secunet.com
References : http://marc.info/?l=linux-kernel&m=130521215329005&w=2

This entry is being used for tracking a regression from 2.6.38. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
