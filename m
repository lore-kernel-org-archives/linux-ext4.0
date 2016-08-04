From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] New: free space lossage on busy system with bigalloc
 enabled and 128KB cluster
Date: Thu, 04 Aug 2016 19:47:41 +0000
Message-ID: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934012AbcHDT4J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 15:56:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 64D27204EA
	for <linux-ext4@vger.kernel.org>; Thu,  4 Aug 2016 19:47:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 36A1E2049C
	for <linux-ext4@vger.kernel.org>; Thu,  4 Aug 2016 19:47:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

            Bug ID: 151491
           Summary: free space lossage on busy system with bigalloc
                    enabled and 128KB cluster
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.8
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mlmartin@clearsky-data.com
        Regression: No

Created attachment 227581
  --> https://bugzilla.kernel.org/attachment.cgi?id=227581&action=edit
details of fault with scripts for reproduction

file system with bigalloc enabled and 128KB cluster size with a large number of
2MB files being created/overwritten/deleted loses usable space.

Running du and df gives wildly different usage with df showing much more usage
than du. lsof shows no phantom open files. Using dd to fill the file system
shows that df's version of free space is operative, but unmounting and
remounting the file system returns the free space. There is no difference
between df and du usage after remount.

The fault does not seem to be present in the 4.7 kernel (or it takes a lot more
activity for it to show up).

I will build 4.4.16 and retest to see if is present there.

We do have a(n obnoxious) workaround of periodically unmounting/remounting
files systems.

Details of configurations and tests in the attached document

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
