From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] New: NULL pointer dereference in ext4_ext_remove_space
 on 3.5.1
Date: Mon, 17 Sep 2012 11:32:35 +0000 (UTC)
Message-ID: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50414 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab2IQLcm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 07:32:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1704B20297
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 11:32:41 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 55D0B20294
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 11:32:36 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611

           Summary: NULL pointer dereference in ext4_ext_remove_space on
                    3.5.1
           Product: File System
           Version: 2.5
    Kernel Version: 3.5.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: error27@gmail.com
        Regression: Yes


https://lkml.org/lkml/2012/8/15/372

Date: Wed, 15 Aug 2012 21:33:29 +0300
From: Marti Raudsepp <marti@juffo.org>
To: Kernel hackers <linux-kernel@vger.kernel.org>, ext4 hackers
<linux-ext4@vger.kernel.org>
Subject: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID:
<CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>

Hi list,

I was moving and deleting some files between two of my ext4 partitions
when it suddenly crashed and dropped me into an kernel oops screen
(below). I'm using ext4 on kernel 3.5.1 (Arch Linux). Both likely
suspect file systems are stored on LVM2, mounted with
data=writeback,errors=remount-ro,noatime

EXT4-fs (sda3): mounted filesystem with writeback data mode. Opts: (null)
EXT4-fs (dm-1): mounted filesystem with writeback data mode. Opts:
errors=remount-ro
EXT4-fs (dm-0): mounted filesystem with writeback data mode. Opts:
errors=remount-ro

I can't be bothered to transcribe all those 64-bit pointer values, but
here's the human-readable parts (screen shot links below):

BUG: unable to handle kernel NULL pointer dereference at 000...00028
IP: [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]
PGD ... PUD ... PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 2
Modules linked in: [... bazillion modules ...]

Pid: 3687, comm: rm Tainted: G    C    3.5.1-1-ARCH #1 System
manufacturer System Product Name/M3A76-CM
RIP: 0010:[...] [...] ext4_ext_remove_space
[... CPU register dump ...]
Process rm (pid: 3687, threadinfo ..., task ...)
Call Trace:
 [...] ext4_ext_truncate+0x183/0x1c0 [ext]
 [...] ? ext4_mark_inode_dirty+0x7e/0x230 [ext4]
 [...] ext4_truncate+0x135/0x140 [ext4]
 [...] ext4_evict_inode+0x40f/0x4e0 [ext4]
 [...] evict+0xb8/0x1b0
 [...] iput+0x105/0x210
 [...] do_unlinkat+0x1b/0x50
 [...] ? flip_close+0x66/0xa0
 [...] sys_unlinkat+0x1b/0x50
 [...] system_call_fastpath+0x16/0x1b
Code: [...]
RIP [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]
CR2: 000...00028
Taint flag C is caused by the staging r8712u driver (Realtek USB Wi-Fi
adapter). But I wasn't even using it today, so I doubt that had
anything to do with it.

Some "screen shots" taken with a webcam (warning: CSI "zoom & enhance"
technology required)
http://ompldr.org/vZjQ3dw
http://ompldr.org/vZjQ3eg
http://ompldr.org/vZjQ4MA
http://ompldr.org/vZjQ3eQ
http://ompldr.org/vZjQ3eA

Regards,
Marti

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
