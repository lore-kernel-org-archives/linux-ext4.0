From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194511] New: filesystem slow down
Date: Wed, 08 Feb 2017 16:05:32 +0000
Message-ID: <bug-194511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdBHQPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 8 Feb 2017 11:15:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5ACC5202F2
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2017 16:05:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 59D6D20268
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2017 16:05:33 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194511

            Bug ID: 194511
           Summary: filesystem slow down
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.44 und 4.8.???
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
          Assignee: fs_ext3@kernel-bugs.osdl.org
          Reporter: dieter.ferdinand@gmx.de
        Regression: No

hello,
last month i try to update to the last kernel 4.4.xx. but that was a big fault.

after the update, it looks fine, but after some time (ca 30 minutes after a
restart of the server, the system slow down and i need to much time to copy
files to the drives.

i test the speed:
read usb >30000 MB/s
read sata >100000MB/s
write filesystem usb ca 1 MB/s
write filesystem sata ca 1 MB/s

this month i used a rescue-system with a kernel 4.8.??? to change a
harddisk-config on a server and i get the same problem:
to backup, format and restore a filesystem with less then 1 GB data i need over
2 hours.
the initialisation of a 160GB ext3-filesystem need over 30 minutes. this is
impossible!

at the same time, a raid is rebuild with over 100 MB/s. i stop the rebuild, but
this have no effect to the write-speed of mke2fs to init the filesystem. at
last, i reinstall the system in less then 30 minutes two times again because
the system don't boot after my changes. i think a selinux-problem.
this systenm use kernel 3.10.0 at the moment without problems.

after two days, i install the kernel 3.18.47 from kernel.org to have the latest
3.xx kernel and this kernel works fine and since installation without problems.

only, i must deaktivate initramfs, but i think, that is no problem of the
kernel and i have no time to analyse this problem at the moment.

goodby

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
