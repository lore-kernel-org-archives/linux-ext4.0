From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] New: ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Thu, 15 May 2014 05:01:50 +0000
Message-ID: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53465 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaEOFBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 01:01:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EC5CC2034B
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2014 05:01:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 02F3F2015E
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2014 05:01:51 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

            Bug ID: 76261
           Summary: ext4_da_writepages err -30 after remount ro during
                    shutdown
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.20
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kun.chen@mediatek.com
        Regression: No

Our android 4.4.2 based on linux 3.10.20

when shutdown, it will call sync, echo "u" > /proc/sysrq-trigger. But I find a
problem that sometime shutdown will hang and sometimes shutdown need long
times.

Check the kmsg log there are ext4 error occur, such as:

[76.209728]-(3)[1:init]SysRq: -(3)[1:init]Emergency Remount R/O
[76.282979] (3)[21:kworker/3:0]Emergency Remount Complete
[77.188953] (0)[84:kworker/u8:1]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[77.205402] (0)[84:kworker/u8:1]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[78.220353] (3)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[79.246658] (1)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[80.261003] (3)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[80.272068] (3)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 1024 pages, ino 131067; err -30
[81.300966] (1)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
[81.688616] (0)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30
......
[90.601634] (0)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 1024 pages, ino 131067; err -30
[91.642286] (0)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 8192 pages, ino 131067; err -30

err 30 is -EROFS, error due to writeback to read-only filesystem.
As part of remount, I think linux will writeback all drity datas. Should no
writeback occur after remount R/O. Not sure why I see these errors.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
