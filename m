From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] New: Incorrectly calculated free blocks result in ENOSPC
 from writepage
Date: Mon, 12 Apr 2010 11:26:24 GMT
Message-ID: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51244 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0DLL0g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 07:26:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3CBQPAN015219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 11:26:25 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768

           Summary: Incorrectly calculated free blocks result in ENOSPC
                    from writepage
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmonakhov@openvz.org
                CC: tytso@mit.edu
        Regression: No


Created an attachment (id=25965)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25965)
testcase

No mount per-sb counters (freeblocks/freeinodes/dir and etc) are initialized 
before journal was replayed.
But in fact if journal wasn't empty statistics will be probably changed after
journal replay. This result in per-sb counter  inconsistency which result in
incorrect delalloc reservation. See testcase.
This is long standing bug at least from 2.6.12 where the linus's tree starts i
(was too lazy to dig in to old-git tree).
But it case of ext3 this result only in incorrect numbers from statfs()
The fix is simple, we just have to move counter initialisation after
journal_reply.
I've open this bug only as testcase storage.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
