From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] New: kernel BUG at fs/ext4/super.c:818 umounting md
 raid6 volume
Date: Wed, 18 Sep 2013 22:05:53 +0000
Message-ID: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3IRWF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 18:05:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC933203F0
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:05:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 219C6203E1
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:05:55 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

            Bug ID: 61631
           Summary: kernel BUG at fs/ext4/super.c:818 umounting md raid6
                    volume
           Product: File System
           Version: 2.5
    Kernel Version: 3.11.1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jfaulkne@ccs.neu.edu
        Regression: No

Under recent kernels, including 3.11.1, I've been seeing kernel BUGs when
umounting a large md raid6 volume.  umount itself gives me a segfault.  I will
attach my config.gz and dmesg, which includes the BUG message.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
