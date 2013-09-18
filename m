From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] New: rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Wed, 18 Sep 2013 12:05:03 +0000
Message-ID: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3IRMFK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 08:05:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A995320367
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 12:05:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 29EC32021B
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 12:05:06 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

            Bug ID: 61601
           Summary: rootflags=noatime causes kernel panic when booting
                    without initrd.
           Product: File System
           Version: 2.5
    Kernel Version: 3.11, 3.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: dragonn@op.pl
        Regression: No

I have create kernel with built in SATA drivers and ext4 filesystem. Everything
boots fine when I launch the kernel without rootflags=noatime. When I add to
the kernel parameters rootflags=noatime I got kernel panic direct after the
kernel launch and try to mount the root partition. This could affect other
filesystem too, but I didn't test it. My kernel cmdline is be default:

root=/dev/sda4 rw acpi=noirq vga=773 logo.nologo loglevel=0 libata.force=noncq
quiet libahci.ignore_sss=1 rootfstype=ext4.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
