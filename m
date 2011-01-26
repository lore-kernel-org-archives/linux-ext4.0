From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] New: 38-rc1: umount+rmmod cause ext4 error.
Date: Wed, 26 Jan 2011 20:27:16 GMT
Message-ID: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60073 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1AZU1R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 15:27:17 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0QKRG3H008770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jan 2011 20:27:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652

           Summary: 38-rc1: umount+rmmod cause ext4 error.
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com
        Regression: Yes


Subject    : 38-rc1: umount+rmmod cause ext4 error.
Submitter  : Tao Ma <tm@tao.ma>
Date       : 2011-01-19 6:53
Message-ID : 4D368A70.5030103@tao.ma
References : http://marc.info/?l=linux-ext4&m=129542001031750&w=2

This entry is being used for tracking a regression from 2.6.37. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
