From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] New: system hang during ext4 xattr operation
Date: Thu, 05 Nov 2015 13:54:24 +0000
Message-ID: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32867 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161070AbbKENy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 08:54:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4ACF7208BD
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 13:54:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CB4B5208BA
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 13:54:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

            Bug ID: 107301
           Summary: system hang during ext4 xattr operation
           Product: File System
           Version: 2.5
    Kernel Version: 4.2.3 3.19 3.16
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: sileht@sileht.net
        Regression: No

Created attachment 192191
  --> https://bugzilla.kernel.org/attachment.cgi?id=192191&action=edit
dmesg received via netconsole before the system hang

Hi,

We are running a ceph cluster on ext4 filesystem, we recently got a hardware
failure, the ceph recovery process provokes a huge amount of data write on all
our ext4 filesystems (~40 disks).

Now, we are experienced random nodes hang, we catch some partial backtrace
(that can be found on the ceph bug tracker). And recently we got the full dmesg
log via netconsole (attached to this BZ).

When the freeze occurs, it seems ceph processes lockup all the CPUs, each CPUs
backtrace is related to a xattr operation. 

bug report on ceph side: http://tracker.ceph.com/issues/13662

We have some nodes on debian and some other on ubuntu, we tried kernels 3.16,
3.19, 4.2.3. The issue occurs with all of them. 

Cheers,

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
