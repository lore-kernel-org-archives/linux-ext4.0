From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] New: WARNING: at fs/fs-writeback.c:1127
 __mark_inode_dirty
Date: Mon, 28 Jun 2010 17:47:47 GMT
Message-ID: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56394 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0F1Rrs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 13:47:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5SHll16011501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 17:47:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312

           Summary: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    zdenek.kabelac@gmail.com
        Regression: Yes


Subject    : WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Submitter  : Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date       : 2010-06-28 9:40
Message-ID : AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=127771804806465&w=2

This entry is being used for tracking a regression from 2.6.34.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
