From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Sun, 30 Jan 2011 02:36:59 GMT
Message-ID: <201101300236.p0U2axF2024055@demeter2.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43320 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1A3ChA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Jan 2011 21:37:00 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0U2axXJ024056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 02:37:00 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652





--- Comment #8 from Tao Ma <tm@tao.ma>  2011-01-30 02:36:58 ---
(In reply to comment #7)
> Patch: https://bugzilla.kernel.org/show_bug.cgi?id=27652#c6 
> 
> Tao Ma, does this work for you too?

Hi sorry for the delay.
So the patch works for the kernel panic.
Reported-and-Tested-by: Tao Ma <boyu.mt@taobao.com>

As for the original bug, it doesn't help. I can still get the error message.

slab error in kmem_cache_destroy(): cache `ext4_inode_cache': Can't free all
objects
Pid: 4674, comm: rmmod Not tainted 2.6.38-rc2+ #1
Call Trace:
 [<ffffffff820d61ac>] ? kmem_cache_destroy+0x83/0xc7
 [<ffffffffa03a9000>] ? destroy_inodecache+0x15/0x17 [ext4]
 [<ffffffffa03c7264>] ? ext4_exit_fs+0x30/0x60 [ext4]
 [<ffffffff82067bce>] ? sys_delete_module+0x1b5/0x218
 [<ffffffff8207506f>] ? audit_syscall_entry+0x187/0x1ba
 [<ffffffff82002a6b>] ? system_call_fastpath+0x16/0x1b
SLAB: cache with size 888 has lost its name

And as I pointed in the original mail, I have done some basic investigation and
it looks as if it is introduced by Nick's new ext4_i_callback.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
