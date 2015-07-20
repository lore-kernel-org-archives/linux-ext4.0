From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101751] New: 0009103: INFO: task nginx:2334 blocked for more
 than 120 seconds.
Date: Mon, 20 Jul 2015 11:45:20 +0000
Message-ID: <bug-101751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59229 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbbGTLp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2015 07:45:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 025D320662
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:45:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CAC7620626
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:45:21 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101751

            Bug ID: 101751
           Summary: 0009103: INFO: task nginx:2334 blocked for more than
                    120 seconds.
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.84
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zakrzewskim@wp.pl
        Regression: No

Created attachment 183181
  --> https://bugzilla.kernel.org/attachment.cgi?id=183181&action=edit
dmesg logs

I'm getting constant hangs (random programs) with latest kernel 

Sometimes even saving simple vim file takes about 2 minutes !

I've replaced all hardware, motherboard, CPU disks and nothing.

Filesystem check passed.

It affects all our services but mostly nginx and qmail.

My CPU: Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz
Board: MSI X58 Pro-E (MS-7522)
Drives: 2x Intel 520 240 GB software RAID 1 + 2x WD RE4 3 TB software RAID 1

Please help me solving this.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
