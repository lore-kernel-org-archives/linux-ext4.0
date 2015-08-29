From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103731] New: timeout on SSD and kernel 4.1.3 and >
Date: Sat, 29 Aug 2015 19:02:47 +0000
Message-ID: <bug-103731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46136 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbbH2TCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Aug 2015 15:02:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 69597207A6
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 19:02:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 900A32079F
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 19:02:48 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103731

            Bug ID: 103731
           Summary: timeout on SSD and kernel 4.1.3 and >
           Product: File System
           Version: 2.5
    Kernel Version: >4.1.3
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: giudeluca88@hotmail.it
        Regression: No

there is an error in boot.-
this error generate a timeout of 4 seconds.
attach dmesg to clarify this bug (I have a SSD samsung 850 EVO and Fedora 22)


[    1.947795] input: ETPS/2 Elantech Touchpad as
/devices/platform/i8042/serio4/input/input12
[    5.890091] ata1.00: qc timeout (cmd 0x2f)
[    5.890096] ata1.00: failed to get NCQ Send/Recv Log Emask 0x5
[    5.890099] ata1.00: ATA-9: Samsung SSD 850 EVO 250GB, EMT01B6Q, max
UDMA/133
[    5.890102] ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    5.890105] ata1.00: failed to get Identify Device Data, Emask 0x40
[    5.890111] ata1.00: failed to set xfermode (err_mask=0x40)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
