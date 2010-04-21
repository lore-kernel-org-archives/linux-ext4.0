From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15827] New: ext4_get_blocks may be called while
 ext4_truncate() is in progress
Date: Wed, 21 Apr 2010 15:43:20 GMT
Message-ID: <bug-15827-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52284 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab0DUPp0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 11:45:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3LFhKom008699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 15:43:21 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15827

           Summary: ext4_get_blocks may be called while  ext4_truncate()
                    is in progress
           Product: File System
           Version: 2.5
    Kernel Version: v2.6.29-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmonakhov@openvz.org
        Regression: No


Created an attachment (id=26081)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26081)
dmesg output

During truncate we may need to restart new transaction, to avoid deadlock on
i_data_sem it was dropped 
commit 487caeef9fc08c0565e082c40a8aaf58dad92bbb
Author: Jan Kara <jack@suse.cz>
Date:   Mon Aug 17 22:17:20 2009 -0400

Jan given a good explanation why this approach would work, I have better
explanation why this can't work work.
Yes we have blocked all writers beyond i_size, but writers(flush, page_mkwrite)
before i_size still may change node blocks, so 'path' which was lookup by
truncate is not longer valid. So we are in big big troubles. 

I've add created inode's history tracer patch which spotted the issue.
See attachments.

--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-21 15:41:13 ---
Created an attachment (id=26082)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26082)
debug patch against ext4.git/next + patches from bug #15792

The debug patch is rather ugly, but still useful.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
