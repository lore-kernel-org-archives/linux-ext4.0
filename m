From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114621] New: /etc/fstab: impossible to disable relatime
Date: Tue, 15 Mar 2016 12:17:11 +0000
Message-ID: <bug-114621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50263 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934698AbcCOMRR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 08:17:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 20F2E202E6
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 12:17:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 42E70202EC
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 12:17:12 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114621

            Bug ID: 114621
           Summary: /etc/fstab: impossible to disable relatime
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.15-pv
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: armin_mohring@web.de
        Regression: No

/etc/fstab: no entry relatime.
But the partitions are mounted with option relatime.

But this causes an error in dmesg.
NCQ is disabled for a SSD and a HDD.

----------------------
[    5.640926] ata2.00: ATA-9: WDC WD4003FZEX-00Z4SA0, 01.01A01, max UDMA/133
[    5.640931] ata2.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    5.641470] ata2.00: configured for UDMA/133
[    5.642179] ata3.00: ATAPI: HL-DT-ST BD-RE  BH16NS55, 1.01, max UDMA/133
[    5.642252] ata1.00: supports DRM functions and may not be fully accessible
[    5.642296] ata1.00: READ LOG DMA EXT failed, trying unqueued
[    5.642320] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    5.642323] ata1.00: ATA-9: Samsung SSD 850 PRO 512GB, EXM01B6Q, max
UDMA/133
[    5.642326] ata1.00: 1000215216 sectors, multi 1: LBA48 NCQ (depth 31/32),
AA
[    5.642542] ata1.00: supports DRM functions and may not be fully accessible
[    5.642580] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    5.642632] ata1.00: configured for UDMA/133

-------------------------------------

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
