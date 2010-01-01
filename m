From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] New: [regression] msync() call on ext4 causes disk
 thrashing
Date: Fri, 1 Jan 2010 23:09:50 GMT
Message-ID: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42516 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0AAXJv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jan 2010 18:09:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o01N9o6k017917
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jan 2010 23:09:50 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972

           Summary: [regression] msync() call on ext4 causes disk
                    thrashing
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: t.artem@mailcity.com
        Regression: Yes


Created an attachment (id=24398)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24398)
run this way ./test test.txt 100

The attached application causes useless disk thrashing in case of ext4, but
works normally in case of ext3 (and possibly other FS's).

msync() for unchanged mmap'ed files shouldn't cause disk/HDD activity which I
do observe.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
