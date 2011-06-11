From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 37212] New: NULL pointer dereference in inode_has_perm() while
 setquota
Date: Sat, 11 Jun 2011 15:44:34 GMT
Message-ID: <bug-37212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:59237 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab1FKPof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Jun 2011 11:44:35 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p5BFiYVU013304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 11 Jun 2011 15:44:34 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=37212

           Summary: NULL pointer dereference in inode_has_perm() while
                    setquota
           Product: File System
           Version: 2.5
    Kernel Version: 3.0-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    lczerner@redhat.com
        Regression: Yes


Subject    : NULL pointer dereference in inode_has_perm() while setquota
Submitter  : Lukas Czerner <lczerner@redhat.com>
Date       : 2011-06-01 8:35
Message-ID : alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com
References : http://marc.info/?l=linux-kernel&m=130691737405046&w=2

This entry is being used for tracking a regression from 2.6.39. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
