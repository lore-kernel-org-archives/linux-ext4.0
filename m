From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115441] New: Cant boot with nvme with recent kernels
Date: Tue, 29 Mar 2016 08:40:41 +0000
Message-ID: <bug-115441-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55753 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329AbcC2Ikq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2016 04:40:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7A95320212
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 08:40:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6AD60201FE
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 08:40:41 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=115441

            Bug ID: 115441
           Summary: Cant boot with nvme with recent kernels
           Product: File System
           Version: 2.5
    Kernel Version: 4.3.6-040306
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jarkko_korpi@hotmail.com
        Regression: No

I didnt know what exactly is the component I should be targeting. Most likely
not filesystems. The kernel version I added, does work, but any effort 4.4
series or newer has been a result not booting system which has been fixed using
earlier kernel.

There is some regression that prevents you from booting from nvme ssd. Grub
works, but you just cant boot from the disk.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
