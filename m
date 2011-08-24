From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] New: INFO: possible circular locking dependency detected
 .. at ext4_evict_inode
Date: Wed, 24 Aug 2011 21:18:17 GMT
Message-ID: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40627 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1HXVSS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Aug 2011 17:18:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7OLIHNx002184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 21:18:18 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682

           Summary: INFO: possible circular locking dependency detected ..
                    at ext4_evict_inode
           Product: File System
           Version: 2.5
    Kernel Version: 3.1.0-rc3+
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: baryluk@smp.if.uj.edu.pl
        Regression: Yes


Hi, few minutes after boot and login i got this message. I just logged on
console and started doing small file systems works, like apt-get remove
linux-image-2.6.*, and in the middle I got this

[  509.647307] 
[  509.647311] =======================================================
[  509.650015] [ INFO: possible circular locking dependency detected ]
[  509.650015] 3.1.0-rc3-t43-prod-00091-ga53e77f-dirty #9
[  509.650015] -------------------------------------------------------
[  509.650015] apt-get/7446 is trying to acquire lock:
[  509.650015]  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c11458ea>]
ext4_evict_inode+0x1a/0x370
[  509.650015] 
[  509.650015] but task is already holding lock:
[  509.650015]  (&mm->mmap_sem){++++++}, at: [<c10bbac2>] sys_munmap+0x22/0x50
[  509.650015] 
[  509.650015] which lock already depends on the new lock.
[  509.650015] 
[  509.650015] 
[  509.650015] the existing dependency chain (in reverse order) is:
[  509.650015] 
[  509.650015] -> #1 (&mm->mmap_sem){++++++}:
[  509.650015]        [<c1073e58>] lock_acquire+0x78/0xa0
[  509.650015]        [<c10b2c5b>] might_fault+0x6b/0x90
[  509.650015]        [<c1240636>] copy_to_user+0x36/0x60
[  509.650015]        [<c10eceb6>] filldir+0x66/0xc0
[  509.650015]        [<c113bb6c>] call_filldir+0x8c/0xc0
[  509.650015]        [<c113c387>] ext4_readdir+0x637/0x700
[  509.650015]        [<c10ed066>] vfs_readdir+0x76/0xa0
[  509.650015]        [<c10ed154>] sys_getdents+0x64/0xd0
[  509.650015]        [<c16307dc>] sysenter_do_call+0x12/0x3c
[  509.650015] 
[  509.650015] -> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
[  509.650015]        [<c107373c>] __lock_acquire+0x13cc/0x1640
[  509.650015]        [<c1073e58>] lock_acquire+0x78/0xa0
[  509.650015]        [<c162deb4>] mutex_lock_nested+0x44/0x2c0
[  509.650015]        [<c11458ea>] ext4_evict_inode+0x1a/0x370
[  509.650015]        [<c10f4439>] evict+0x89/0x170
[  509.650015]        [<c10f45ec>] iput+0xcc/0x1c0
[  509.650015]        [<c10efa6f>] dentry_iput+0x7f/0xd0
[  509.650015]        [<c10f19aa>] dput+0x10a/0x200
[  509.650015]        [<c10ddf1b>] fput+0x13b/0x1e0
[  509.650015]        [<c10b94bd>] remove_vma+0x2d/0x60
[  509.650015]        [<c10ba462>] do_munmap+0x182/0x2d0
[  509.650015]        [<c10bbacf>] sys_munmap+0x2f/0x50
[  509.650015]        [<c16307dc>] sysenter_do_call+0x12/0x3c
[  509.650015] 
[  509.650015] other info that might help us debug this:
[  509.650015] 
[  509.650015]  Possible unsafe locking scenario:
[  509.650015] 
[  509.650015]        CPU0                    CPU1
[  509.650015]        ----                    ----
[  509.650015]   lock(&mm->mmap_sem);
[  509.650015]                                lock(&sb->s_type->i_mutex_key);
[  509.650015]                                lock(&mm->mmap_sem);
[  509.650015]   lock(&sb->s_type->i_mutex_key);
[  509.650015] 
[  509.650015]  *** DEADLOCK ***
[  509.650015] 
[  509.650015] 1 lock held by apt-get/7446:
[  509.650015]  #0:  (&mm->mmap_sem){++++++}, at: [<c10bbac2>]
sys_munmap+0x22/0x50
[  509.650015] 
[  509.650015] stack backtrace:
[  509.650015] Pid: 7446, comm: apt-get Not tainted
3.1.0-rc3-t43-prod-00091-ga53e77f-dirty #9
[  509.650015] Call Trace:
[  509.650015]  [<c1627359>] ? printk+0x18/0x1a
[  509.650015]  [<c1627a02>] print_circular_bug+0x1de/0x1e8
[  509.650015]  [<c107373c>] __lock_acquire+0x13cc/0x1640
[  509.650015]  [<c1073e58>] lock_acquire+0x78/0xa0
[  509.650015]  [<c11458ea>] ? ext4_evict_inode+0x1a/0x370
[  509.650015]  [<c162deb4>] mutex_lock_nested+0x44/0x2c0
[  509.650015]  [<c11458ea>] ? ext4_evict_inode+0x1a/0x370
[  509.650015]  [<c12461df>] ? do_raw_spin_lock+0x3f/0x130
[  509.650015]  [<c11458ea>] ext4_evict_inode+0x1a/0x370
[  509.650015]  [<c124635e>] ? do_raw_spin_unlock+0x4e/0x90
[  509.650015]  [<c10f4439>] evict+0x89/0x170
[  509.650015]  [<c10f45ec>] iput+0xcc/0x1c0
[  509.650015]  [<c10efa6f>] dentry_iput+0x7f/0xd0
[  509.650015]  [<c10f19aa>] dput+0x10a/0x200
[  509.650015]  [<c10ddf1b>] fput+0x13b/0x1e0
[  509.650015]  [<c10b94bd>] remove_vma+0x2d/0x60
[  509.650015]  [<c10ba462>] do_munmap+0x182/0x2d0
[  509.650015]  [<c10bbacf>] sys_munmap+0x2f/0x50
[  509.650015]  [<c16307dc>] sysenter_do_call+0x12/0x3c


uniprocessor, i386, pentium-m, debian unstable, gcc-4.6.1-7. INFO appered once
just when started moderate load on file system (apt-get remove something).

It didn't repeated since it.

Kernel config attached.

Regards,
Witek

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
