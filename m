From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42362] New: [ext4] possible circular locking dependency
 detected
Date: Sun, 4 Sep 2011 16:44:17 GMT
Message-ID: <bug-42362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36461 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1IDQoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 12:44:19 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p84GiJIb000966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 4 Sep 2011 16:44:19 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42362

           Summary: [ext4] possible circular locking dependency detected
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.1-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: combuster@archlinux.us
        Regression: No


I found this after I've noticed that transfering files from my camera (Sony
HX9V) withing shotwell is painfully slow. I'm not sure if this is the culprit
but I wanted to report this nevertheless...

Here is dmesg output:

[  137.861302] =======================================================
[  137.861304] [ INFO: possible circular locking dependency detected ]
[  137.861306] 3.1.0-rc3-RC #1
[  137.861307] -------------------------------------------------------
[  137.861309] shotwell/1250 is trying to acquire lock:
[  137.861311]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffffa00a5a46>]
ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861321] 
[  137.861321] but task is already holding lock:
[  137.861323]  (&mm->mmap_sem){++++++}, at: [<ffffffff810bf2ae>]
sys_munmap+0x36/0x5b
[  137.861329] 
[  137.861329] which lock already depends on the new lock.
[  137.861330] 
[  137.861331] 
[  137.861331] the existing dependency chain (in reverse order) is:
[  137.861333] 
[  137.861333] -> #1 (&mm->mmap_sem){++++++}:
[  137.861336]        [<ffffffff8106bdf0>] check_prevs_add+0x8b/0x104
[  137.861341]        [<ffffffff8106c1ca>] validate_chain.isra.37+0x361/0x39d
[  137.861344]        [<ffffffff8106c89a>] __lock_acquire+0x36f/0x3e8
[  137.861346]        [<ffffffff8106cd31>] lock_acquire+0x7e/0x99
[  137.861349]        [<ffffffff810b7ffd>] might_fault+0x7b/0x9e
[  137.861353]        [<ffffffff810f0e2a>] filldir+0x6a/0xc2
[  137.861357]        [<ffffffffa009dd6d>] call_filldir+0x91/0xb8 [ext4]
[  137.861361]        [<ffffffffa009df13>] ext4_dx_readdir+0x16f/0x1d2 [ext4]
[  137.861365]        [<ffffffffa009e116>] ext4_readdir+0x68/0x37e [ext4]
[  137.861369]        [<ffffffff810f1070>] vfs_readdir+0x76/0xac
[  137.861372]        [<ffffffff810f1182>] sys_getdents+0x79/0xc9
[  137.861375]        [<ffffffff8135b512>] system_call_fastpath+0x16/0x1b
[  137.861378] 
[  137.861379] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[  137.861382]        [<ffffffff8106bbc6>] check_prev_add+0x68/0x207
[  137.861385]        [<ffffffff8106bdf0>] check_prevs_add+0x8b/0x104
[  137.861387]        [<ffffffff8106c1ca>] validate_chain.isra.37+0x361/0x39d
[  137.861390]        [<ffffffff8106c89a>] __lock_acquire+0x36f/0x3e8
[  137.861392]        [<ffffffff8106cd31>] lock_acquire+0x7e/0x99
[  137.861395]        [<ffffffff81355060>] __mutex_lock_common+0x61/0x470
[  137.861398]        [<ffffffff81355556>] mutex_lock_nested+0x36/0x3b
[  137.861401]        [<ffffffffa00a5a46>] ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861406]        [<ffffffff810f6c14>] evict+0xa1/0x15b
[  137.861409]        [<ffffffff810f6e3f>] iput_final+0x171/0x17a
[  137.861411]        [<ffffffff810f6e80>] iput+0x38/0x3c
[  137.861413]        [<ffffffff810f3210>] dentry_iput+0x96/0xa6
[  137.861415]        [<ffffffff810f3bdf>] dentry_kill+0xaa/0xc1
[  137.861418]        [<ffffffff810f3ff2>] dput+0x10d/0x11d
[  137.861420]        [<ffffffff810e42be>] __fput+0x18a/0x1a2
[  137.861423]        [<ffffffff810e42eb>] fput+0x15/0x17
[  137.861425]        [<ffffffff810bdfd6>] remove_vma+0x4c/0x7d
[  137.861427]        [<ffffffff810bf154>] do_munmap+0x262/0x27b
[  137.861430]        [<ffffffff810bf2bc>] sys_munmap+0x44/0x5b
[  137.861432]        [<ffffffff8135b512>] system_call_fastpath+0x16/0x1b
[  137.861435] 
[  137.861435] other info that might help us debug this:
[  137.861436] 
[  137.861437]  Possible unsafe locking scenario:
[  137.861438] 
[  137.861439]        CPU0                    CPU1
[  137.861440]        ----                    ----
[  137.861441]   lock(&mm->mmap_sem);
[  137.861443]                                lock(&sb->s_type->i_mutex_key);
[  137.861446]                                lock(&mm->mmap_sem);
[  137.861448]   lock(&sb->s_type->i_mutex_key);
[  137.861450] 
[  137.861450]  *** DEADLOCK ***
[  137.861451] 
[  137.861452] 1 lock held by shotwell/1250:
[  137.861453]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810bf2ae>]
sys_munmap+0x36/0x5b
[  137.861457] 
[  137.861458] stack backtrace:
[  137.861460] Pid: 1250, comm: shotwell Not tainted 3.1.0-rc3-RC #1
[  137.861461] Call Trace:
[  137.861465]  [<ffffffff8134770a>] print_circular_bug+0xcc/0xdd
[  137.861467]  [<ffffffff8106bbc6>] check_prev_add+0x68/0x207
[  137.861470]  [<ffffffff8106bdf0>] check_prevs_add+0x8b/0x104
[  137.861473]  [<ffffffff8106c1ca>] validate_chain.isra.37+0x361/0x39d
[  137.861476]  [<ffffffff8106c89a>] __lock_acquire+0x36f/0x3e8
[  137.861479]  [<ffffffff8106cd31>] lock_acquire+0x7e/0x99
[  137.861484]  [<ffffffffa00a5a46>] ? ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861487]  [<ffffffff81355060>] __mutex_lock_common+0x61/0x470
[  137.861491]  [<ffffffffa00a5a46>] ? ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861496]  [<ffffffffa00a5a46>] ? ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861499]  [<ffffffff8106cc3e>] ? __lock_release+0x8c/0x9c
[  137.861502]  [<ffffffff81355556>] mutex_lock_nested+0x36/0x3b
[  137.861507]  [<ffffffffa00a5a46>] ext4_evict_inode+0x1e/0x2c6 [ext4]
[  137.861512]  [<ffffffffa00a5a28>] ? ext4_da_writepages+0x395/0x395 [ext4]
[  137.861514]  [<ffffffff810f6c14>] evict+0xa1/0x15b
[  137.861517]  [<ffffffff810f6e3f>] iput_final+0x171/0x17a
[  137.861519]  [<ffffffff810f6e80>] iput+0x38/0x3c
[  137.861521]  [<ffffffff810f3210>] dentry_iput+0x96/0xa6
[  137.861523]  [<ffffffff810f3bdf>] dentry_kill+0xaa/0xc1
[  137.861525]  [<ffffffff810f3ff2>] dput+0x10d/0x11d
[  137.861528]  [<ffffffff810e42be>] __fput+0x18a/0x1a2
[  137.861530]  [<ffffffff810e42eb>] fput+0x15/0x17
[  137.861533]  [<ffffffff810bdfd6>] remove_vma+0x4c/0x7d
[  137.861535]  [<ffffffff810bf154>] do_munmap+0x262/0x27b
[  137.861537]  [<ffffffff810bf2bc>] sys_munmap+0x44/0x5b
[  137.861540]  [<ffffffff8135b512>] system_call_fastpath+0x16/0x1b

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
