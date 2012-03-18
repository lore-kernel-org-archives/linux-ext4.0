From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42959] New: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: Sun, 18 Mar 2012 19:48:25 GMT
Message-ID: <bug-42959-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41715 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2CRTsZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Mar 2012 15:48:25 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2IJmPLw006881
	for <linux-ext4@vger.kernel.org>; Sun, 18 Mar 2012 19:48:25 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42959

           Summary: Oops in ext3_block_to_path.isra.40+0x26/0x11b
           Product: File System
           Version: 2.5
    Kernel Version: 3.3-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: florian@mickler.org, rjw@sisk.pl,
                    maciej.rutecki@gmail.com, linux@horizon.com
        Regression: Yes


Subject    : Oops in ext3_block_to_path.isra.40+0x26/0x11b
Submitter  : "George Spelvin" <linux@horizon.com>
Date       : 2012-03-13 13:39
Message-ID : 20120313133945.4642.qmail@science.horizon.com
References : http://marc.info/?l=linux-kernel&m=133164604631245&w=2

This entry is being used for tracking a regression from 3.2. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
