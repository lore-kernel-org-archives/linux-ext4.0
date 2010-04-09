From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15742] New: Fallocated extents handled incorrectly if beyond
 i_size
Date: Fri, 9 Apr 2010 17:21:01 GMT
Message-ID: <bug-15742-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44226 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0DIRVG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 13:21:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o39HL2pn009575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 17:21:02 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15742

           Summary: Fallocated extents handled incorrectly if beyond
                    i_size
           Product: File System
           Version: 2.5
    Kernel Version: v2.6.25
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmonakhov@openvz.org
        Regression: No


bad commit: 3977c965ec35ce1a7eac988ad313f0fc9aee9660

Zerrout trick allow us to optimize cases where it is more reasonable
to explicitly zeroout extent and mark it as initialized instead of
splitting to several small ones.
But this optimization is not acceptable is extent is beyond i_size
Because it is not possible to have initialized blocks after i_size.
Fsck treat this as incorrect inode size.

#TESTCASE
mkfs.ext4 /dev/sdb1
mount /dev/sdb1 /mnt
./falloc_test /mnt/F1
umount /mnt
fsck.ext4 -f /dev/sdb1

fsck.ext4 -f /dev/sdb1
e2fsck 1.41.9 (22-Aug-2009)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 1, should be 40960.  Fix<y>? no

--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-09 17:20:56 ---
Created an attachment (id=25931)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25931)
testcase

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
