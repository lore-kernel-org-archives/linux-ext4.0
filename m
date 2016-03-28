From: Theodore Ts'o <tytso@mit.edu>
Subject: GETNEXTQUOTA causes kernel crash if quota not enabled
Date: Mon, 28 Mar 2016 00:43:39 -0400
Message-ID: <20160328044339.GA15808@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36524 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbcC1Eno (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2016 00:43:44 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan, this looks like a recent change that just landed in the quota
tree.  The crash is in dquot_get_next_id() because
sb_dqopt(sb)->ops[0] is NULL.

This looks like it was introduced in a fairly recent commit:
be6257b251ce ("quota: Add support for ->get_nextdqblk() for VFS
quota").

Please see reproduction below.  It can also be easily reproduced using
"kvm-xfstests -c encrypt generic/244")

							- Ted

root@kvm-xfstests:~# mke2fs -t ext4 -Fq /dev/vdc
/dev/vdc contains a ext4 file system
	last mounted on Mon Mar 28 00:35:45 2016
root@kvm-xfstests:~# mount /vdc
root@kvm-xfstests:~# dmesg -n 7
root@kvm-xfstests:~# ./xfstests/src/test-nextquota -i 0 -u -d /dev/vdc
[   29.881729] ------------[ cut here ]------------
[   29.882608] WARNING: CPU: 0 PID: 2634 at /usr/projects/linux/ext4/fs/quota/dquot.c:2051 dquot_get_next_id+0x40/0xc2
[   29.884416] Modules linked in:
[   29.884832] CPU: 0 PID: 2634 Comm: test-nextquota Tainted: G        W       4.5.0-11280-g3d43bcf-dirty #516
[   29.886028] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   29.886742]  00000000 00000246 f34e3dc8 c13da85f 00000000 c11b86c9 f34e3de0 c10856e0
[   29.887777]  00000803 f61f7800 f34e3e2c f61f78cc f34e3df4 c1085772 00000009 00000000
[   29.888809]  00000000 f34e3e08 c11b86c9 c11b8689 f34e3e7c f61f7800 f34e3e20 c11ba297
[   29.889861] Call Trace:
[   29.890166]  [<c13da85f>] dump_stack+0x72/0xa3
[   29.890760]  [<c11b86c9>] ? dquot_get_next_id+0x40/0xc2
[   29.891402]  [<c10856e0>] __warn+0xbc/0xd3
[   29.891916]  [<c1085772>] warn_slowpath_null+0x16/0x1b
[   29.892552]  [<c11b86c9>] dquot_get_next_id+0x40/0xc2
[   29.893172]  [<c11b8689>] ? dqgrab+0x5e/0x5e
[   29.893702]  [<c11ba297>] dquot_get_next_dqblk+0x23/0x116
[   29.894362]  [<c11bdef5>] quota_getnextquota+0x7b/0x18c
[   29.895003]  [<c107549f>] ? kvm_clock_read+0x1f/0x29
[   29.895612]  [<c10754be>] ? kvm_sched_clock_read+0x9/0x18
[   29.896273]  [<c1059960>] ? paravirt_sched_clock+0x9/0xd
[   29.896930]  [<c10bcb85>] ? lock_acquire+0x11c/0x188
[   29.897541]  [<c10baa64>] ? lock_acquired+0xdf/0x2d7
[   29.898150]  [<c1177f3c>] ? get_super+0x54/0x93
[   29.898709]  [<c16ec37d>] ? down_read+0x62/0x69
[   29.899267]  [<c138c7ea>] ? security_capable+0x2d/0x40
[   29.899909]  [<c108d13b>] ? ns_capable+0x3c/0x55
[   29.900478]  [<c11be917>] SyS_quotactl+0x355/0x691
[   29.901069]  [<c10b84a2>] ? up_read+0x22/0x25
[   29.901612]  [<c10779fb>] ? __do_page_fault+0x378/0x3f5
[   29.902255]  [<c1001640>] do_int80_syscall_32+0x4d/0x5f
[   29.902901]  [<c16edc83>] entry_INT80_32+0x2f/0x2f
[   29.903518] ---[ end trace 41bdb730582c4072 ]---
[   29.904090] quid->type is 0, NULL ops array
[   29.904613] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[   29.905494] IP: [<c11b8712>] dquot_get_next_id+0x89/0xc2
[   29.906255] *pdpt = 000000003402d001 *pde = 0000000000000000 
[   29.907028] Oops: 0000 [#1] SMP 
[   29.907466] Modules linked in:
[   29.907859] CPU: 0 PID: 2634 Comm: test-nextquota Tainted: G        W       4.5.0-11280-g3d43bcf-dirty #516
[   29.909060] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   29.909778] task: f41be200 ti: f34e2000 task.ti: f34e2000
[   29.910441] EIP: 0060:[<c11b8712>] EFLAGS: 00010246 CPU: 0
[   29.911118] EIP is at dquot_get_next_id+0x89/0xc2
[   29.911698] EAX: ffffffda EBX: f61f7800 ECX: f6873000 EDX: 00000000
[   29.912464] ESI: f34e3e2c EDI: f61f78cc EBP: f34e3e08 ESP: f34e3dfc
[   29.913236]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   29.913905] CR0: 80050033 CR2: 0000001c CR3: 359cb780 CR4: 000006f0
[   29.914708] Stack:
[   29.914969]  c11b8689 f34e3e7c f61f7800 f34e3e20 c11ba297 f34e3e2c f41be200 f61f7800
[   29.916037]  c1727400 f34e3ef8 c11bdef5 00000000 00000000 00000000 c107549f f41be200
[   29.917086]  f34e3e48 c10754be f41be200 f34e3e54 c1059960 c1a81794 f41be200 f41be200
[   29.918140] Call Trace:
[   29.918449]  [<c11b8689>] ? dqgrab+0x5e/0x5e
[   29.918976]  [<c11ba297>] dquot_get_next_dqblk+0x23/0x116
[   29.919651]  [<c11bdef5>] quota_getnextquota+0x7b/0x18c
[   29.920293]  [<c107549f>] ? kvm_clock_read+0x1f/0x29
[   29.920905]  [<c10754be>] ? kvm_sched_clock_read+0x9/0x18
[   29.921571]  [<c1059960>] ? paravirt_sched_clock+0x9/0xd
[   29.922224]  [<c10bcb85>] ? lock_acquire+0x11c/0x188
[   29.922836]  [<c10baa64>] ? lock_acquired+0xdf/0x2d7
[   29.923447]  [<c1177f3c>] ? get_super+0x54/0x93
[   29.924009]  [<c16ec37d>] ? down_read+0x62/0x69
[   29.924570]  [<c138c7ea>] ? security_capable+0x2d/0x40
[   29.925202]  [<c108d13b>] ? ns_capable+0x3c/0x55
[   29.925773]  [<c11be917>] SyS_quotactl+0x355/0x691
[   29.926364]  [<c10b84a2>] ? up_read+0x22/0x25
[   29.926899]  [<c10779fb>] ? __do_page_fault+0x378/0x3f5
[   29.927542]  [<c1001640>] do_int80_syscall_32+0x4d/0x5f
[   29.928184]  [<c16edc83>] entry_INT80_32+0x2f/0x2f
[   29.928777] Code: eb 1a 85 f6 75 07 68 f8 a4 95 c1 eb ed ff 76 04 68 04 a5 95 c1 e8 be bb f7 ff 58 5a 8b 46 04 8b 94 83 14 02 00 00 b8 da ff ff ff <83> 7a 1c 00 74 2b 8d bb d0 00 00 00 31 d2 89 f8 e8 21 22 53 00
[   29.931955] EIP: [<c11b8712>] dquot_get_next_id+0x89/0xc2 SS:ESP 0068:f34e3dfc
[   29.932867] CR2: 000000000000001c
[   29.933302] ---[ end trace 41bdb730582c4073 ]---
Killed
root@kvm-xfstests:~# QEMU: Terminated
