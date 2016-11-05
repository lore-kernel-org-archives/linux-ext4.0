From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] New: "orphan list check failed" error in ext4
Date: Sat, 05 Nov 2016 20:27:15 +0000
Message-ID: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755929AbcKEU1T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 5 Nov 2016 16:27:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 333F320386
        for <linux-ext4@vger.kernel.org>; Sat,  5 Nov 2016 20:27:18 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 6CCE820379
        for <linux-ext4@vger.kernel.org>; Sat,  5 Nov 2016 20:27:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

            Bug ID: 187051
           Summary: "orphan list check failed" error in ext4
           Product: File System
           Version: 2.5
    Kernel Version: 4.8.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: me@hussam.eu.org
        Regression: No

I saw a ext4 "orphan list check failed" in my logs. It is happening on a new
1TB hard disk and mostly when idle.
I did a smart check and a a fsck check for bad sectors from the arch linux
rescue usb. neither saw anything.
I formatted the disk again and restored a backup. Then I thought I would just
get a replacement instead of wait for this to happen again.
Same issue happened 50 minutes ago.
"Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent 64bit flex_bg sparse_super large_file huge_file dir_nlink
extra_isize metadata_csum".
and formatted under kernel 4.8 with latest e2fsprogs.
Checking the inode that caused the hiccup reveals it points to a folder in
/usr/share/ that was not touched since the 25th of last month and I have fscked
and rebooted plenty of times since then. I fsck on each reboot anyway.
I did a fsck -D -fv /dev/mapper/root from rescue usb after last reboot too.
Could the metadata_csum option be causing this? the kernel.org ext4 wiki
suggested it is a integrity measure.
My backups don't include system journals to save space on backup media so I
don't have the full kernel crash log.
I am sure there was no I/O error message in the crash log when I typed dmesg
and I was told on arch linux logs that this rules out any hardware errors.

I believe this is the second time this has happened.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
