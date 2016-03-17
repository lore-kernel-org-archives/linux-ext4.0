From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] New: Frequent and recurring ext4 "bad header invalid
 magic" errors on a healthy drive
Date: Thu, 17 Mar 2016 05:05:04 +0000
Message-ID: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42368 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbcCQFFH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2016 01:05:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3FAFC2021B
	for <linux-ext4@vger.kernel.org>; Thu, 17 Mar 2016 05:05:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9699D20268
	for <linux-ext4@vger.kernel.org>; Thu, 17 Mar 2016 05:05:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

            Bug ID: 114821
           Summary: Frequent and recurring ext4 "bad header invalid magic"
                    errors on a healthy drive
           Product: File System
           Version: 2.5
    Kernel Version: 3.18.5+
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: dse.ssd@gmail.com
        Regression: No

Recurring ext4 "bad header" errors are reported for a healthy, few months old
external USB drive (WD MyBook 1230) connected to a Raspberry Pi running
Raspbian 7, kernel 3.18.5+. The drive was working fine previously when
formatted in NTFS, SMART has no errors logged, drive passes short and long
SMART self-tests as well as manufacturer diagnostic tests (WD Data Lifeguard).
Another external USB drive (a WD MyBook 1140), formatted in NTFS shows no
problems when connected to the same machine. The specific error is:

ext4_ext_check_inode:495: inode #1523: comm ls: pblk 0 bad header/extent:
invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

The errors are produced whenever some certain files are accessed and the hard
drive produces a distinct (and rather unsettling) clunk every few seconds,
which sounds like a head load/unload or something, but the files seem to be
read without error.

Running fsck reports and fixes some errors and makes the ext4 partition clean
again, but the same errors are produced when the files are read again. The
offending files can be moved to another device and back to the same location to
stop the error from recurring, but it soon appears when accessing other files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
