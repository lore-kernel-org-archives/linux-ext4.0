From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Thu, 25 Aug 2011 10:32:17 GMT
Message-ID: <201108251032.p7PAWHEe007174@demeter2.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:41489 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1HYKcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 06:32:17 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7PAWH4k007176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 10:32:17 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #5 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2011-08-25 10:32:15 ---
Next one, after reboot. (I was trying to revert commit
2581fdc810889fdea97689cb62481201d579c796, however I do not know if I booted
using it, or no :/, so assume it is still with this commit).

[ 5473.013620] 
[ 5473.013622] =======================================================
[ 5473.013626] [ INFO: possible circular locking dependency detected ]
[ 5473.013630] 3.1.0-rc3-t43-prod-00098-gd8e9618-dirty #11
[ 5473.013632] -------------------------------------------------------
[ 5473.013635] mplayer/13337 is trying to acquire lock:
[ 5473.013639]  (&fb_info->lock){+.+.+.}, at: [<c1276f37>] fb_release+0x17/0x50
[ 5473.013652] 
[ 5473.013653] but task is already holding lock:
[ 5473.013656]  (&mm->mmap_sem){++++++}, at: [<c10bbac2>] sys_munmap+0x22/0x50
[ 5473.013665] 
[ 5473.013666] which lock already depends on the new lock.
[ 5473.013667] 
[ 5473.013670] 
[ 5473.013670] the existing dependency chain (in reverse order) is:
[ 5473.013673] 
[ 5473.013674] -> #2 (&mm->mmap_sem){++++++}:
[ 5473.013679]        [<c1073e58>] lock_acquire+0x78/0xa0
[ 5473.013687]        [<c10b2c5b>] might_fault+0x6b/0x90
[ 5473.013691]        [<f8bd1a00>] drm_mode_getresources+0x180/0x580 [drm]
[ 5473.013715]        [<f8bc5143>] drm_ioctl+0x1e3/0x500 [drm]
[ 5473.013725]        [<c10ec7df>] do_vfs_ioctl+0x7f/0x5b0
[ 5473.013730]        [<c10ecd3d>] sys_ioctl+0x2d/0x60
[ 5473.013734]        [<c16307dc>] sysenter_do_call+0x12/0x3c
[ 5473.013741] 
[ 5473.013742] -> #1 (&dev->mode_config.mutex){+.+.+.}:
[ 5473.013748]        [<c1073e58>] lock_acquire+0x78/0xa0
[ 5473.013752]        [<c162de94>] mutex_lock_nested+0x44/0x2c0
[ 5473.013757]        [<f8c50db3>] drm_fb_helper_set_par+0x33/0xd0
[drm_kms_helper]
[ 5473.013764]        [<c1276cec>] fb_set_var+0x17c/0x390
[ 5473.013769]        [<c1277bec>] do_fb_ioctl+0x25c/0x4b0
[ 5473.013774]        [<c1277e8b>] fb_ioctl+0x4b/0x60
[ 5473.013778]        [<c10ec7df>] do_vfs_ioctl+0x7f/0x5b0
[ 5473.013783]        [<c10ecd3d>] sys_ioctl+0x2d/0x60
[ 5473.013787]        [<c16307dc>] sysenter_do_call+0x12/0x3c
[ 5473.013791] 
[ 5473.013792] -> #0 (&fb_info->lock){+.+.+.}:
[ 5473.013797]        [<c107373c>] __lock_acquire+0x13cc/0x1640
[ 5473.013802]        [<c1073e58>] lock_acquire+0x78/0xa0
[ 5473.013806]        [<c162de94>] mutex_lock_nested+0x44/0x2c0
[ 5473.013811]        [<c1276f37>] fb_release+0x17/0x50
[ 5473.013815]        [<c10dde9e>] fput+0xbe/0x1e0
[ 5473.013820]        [<c10b94bd>] remove_vma+0x2d/0x60
[ 5473.013825]        [<c10ba462>] do_munmap+0x182/0x2d0
[ 5473.013830]        [<c10bbacf>] sys_munmap+0x2f/0x50
[ 5473.013834]        [<c16307dc>] sysenter_do_call+0x12/0x3c
[ 5473.013839] 
[ 5473.013840] other info that might help us debug this:
[ 5473.013841] 
[ 5473.013843] Chain exists of:
[ 5473.013844]   &fb_info->lock --> &dev->mode_config.mutex --> &mm->mmap_sem
[ 5473.013852] 
[ 5473.013854]  Possible unsafe locking scenario:
[ 5473.013855] 
[ 5473.013857]        CPU0                    CPU1
[ 5473.013859]        ----                    ----
[ 5473.013861]   lock(&mm->mmap_sem);
[ 5473.013865]                                lock(&dev->mode_config.mutex);
[ 5473.013869]                                lock(&mm->mmap_sem);
[ 5473.013873]   lock(&fb_info->lock);
[ 5473.013877] 
[ 5473.013878]  *** DEADLOCK ***
[ 5473.013879] 
[ 5473.013882] 1 lock held by mplayer/13337:
[ 5473.013884]  #0:  (&mm->mmap_sem){++++++}, at: [<c10bbac2>]
sys_munmap+0x22/0x50
[ 5473.013892] 
[ 5473.013892] stack backtrace:
[ 5473.013897] Pid: 13337, comm: mplayer Not tainted
3.1.0-rc3-t43-prod-00098-gd8e9618-dirty #11
[ 5473.013900] Call Trace:
[ 5473.013906]  [<c1627339>] ? printk+0x18/0x1a
[ 5473.013911]  [<c16279e2>] print_circular_bug+0x1de/0x1e8
[ 5473.013916]  [<c107373c>] __lock_acquire+0x13cc/0x1640
[ 5473.013921]  [<c1073e58>] lock_acquire+0x78/0xa0
[ 5473.013925]  [<c1276f37>] ? fb_release+0x17/0x50
[ 5473.013929]  [<c162de94>] mutex_lock_nested+0x44/0x2c0
[ 5473.013934]  [<c1276f37>] ? fb_release+0x17/0x50
[ 5473.013938]  [<c10b363c>] ? tlb_finish_mmu+0xc/0x40
[ 5473.013943]  [<c10b96ca>] ? unmap_region+0xba/0xd0
[ 5473.013947]  [<c1276f37>] fb_release+0x17/0x50
[ 5473.013951]  [<c10dde9e>] fput+0xbe/0x1e0
[ 5473.013955]  [<c10b94bd>] remove_vma+0x2d/0x60
[ 5473.013960]  [<c10ba462>] do_munmap+0x182/0x2d0
[ 5473.013964]  [<c10bbacf>] sys_munmap+0x2f/0x50
[ 5473.013969]  [<c16307dc>] sysenter_do_call+0x12/0x3c

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
