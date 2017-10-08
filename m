From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/388 can trigger oops and leave mount point busy - v4.14-rc*
Date: Sun, 8 Oct 2017 14:00:03 -0400
Message-ID: <20171008180003.7tnrzm6ilvdoai27@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:44874 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdJHSAI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Oct 2017 14:00:08 -0400
Received: by mail-qt0-f169.google.com with SMTP id v28so30677710qtv.1
        for <linux-ext4@vger.kernel.org>; Sun, 08 Oct 2017 11:00:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As discussed in last week's ext4 concall:

When run in the 4k test scenario with kvm-xfstests on a 4.14-rc3 kernel,
generic/388 will occasionally trigger an oops that results in a busy mount
point.  This condition persists once it does occur, and subsequent attempts
to run other tests that use the affected mount point (vdc) fail to run until
the test appliance has been restarted.

The frequency of occurrence of this problem is about .5% on my test system.
I can, however, reliably reproduce it by simply kicking off a 1000 test
series of generic/388 runs.

This problem is not unique to the 4k test case, nor to 4.14-rc3.  I first
observed it while running the ext3conv test case on 4.14-rc2.

A typical stack trace and the triggering line of code follow.  The stack
trace does vary, sometimes including ext4_mkdir rather than ext4_create, but
the triggering line of code always remains the same.


[16425.050687] BUG: unable to handle kernel NULL pointer dereference at 0000000000000013
[16425.051512] IP: __ext4_new_inode+0x898/0x1700
[16425.051779] PGD 0 P4D 0 
[16425.051934] Oops: 0000 [#1] SMP
[16425.052124] Modules linked in:
[16425.052310] CPU: 0 PID: 1276 Comm: fsstress Not tainted 4.14.0-rc3 #1
[16425.052691] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[16425.053179] task: ffff88007a450000 task.stack: ffffc90006ae0000
[16425.053532] RIP: 0010:__ext4_new_inode+0x898/0x1700
[16425.053821] RSP: 0018:ffffc90006ae3ac8 EFLAGS: 00010282
[16425.054130] RAX: fffffffffffffffb RBX: ffff88007c996000 RCX: ffffffffffffffff
[16425.054548] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000246
[16425.054970] RBP: ffffc90006ae3b88 R08: 0000000000000000 R09: 0000000000000000
[16425.055389] R10: 00000000ab134266 R11: ffffffff827b7ee0 R12: 0000000000000000
[16425.055807] R13: 0000000000000000 R14: fffffffffffffffb R15: ffffc90006ae3ed4
[16425.056226] FS:  00007f76d56e5700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[16425.056699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16425.057038] CR2: 0000000000000013 CR3: 0000000068117000 CR4: 00000000000006f0
[16425.057458] Call Trace:
[16425.057609]  ? trace_hardirqs_on+0xd/0x10
[16425.057851]  ? __wake_up_common_lock+0x7f/0xa0
[16425.058118]  ext4_create+0xa8/0x190
[16425.058329]  lookup_open+0x703/0x7e0
[16425.058546]  path_openat+0x33a/0xbd0
[16425.058761]  ? __lock_acquire+0x4c6/0x1100
[16425.059010]  do_filp_open+0x8a/0xf0
[16425.059223]  ? _raw_spin_unlock+0x27/0x30
[16425.059464]  do_sys_open+0x123/0x200
[16425.059678]  ? do_sys_open+0x123/0x200
[16425.059903]  SyS_creat+0x1e/0x20
[16425.060098]  do_syscall_64+0x6c/0x210
[16425.060318]  entry_SYSCALL64_slow_path+0x25/0x25
[16425.060593] RIP: 0033:0x7f76d4fe9e70
[16425.060807] RSP: 002b:00007ffd866dae88 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
[16425.061251] RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f76d4fe9e70
[16425.061669] RDX: 0000000000000000 RSI: 00000000000001b6 RDI: 00007f76d00008c0
[16425.062087] RBP: 00007ffd866daff0 R08: fefefefefefefeff R09: fefefefefeff3065
[16425.062505] R10: 0000000000000078 R11: 0000000000000246 R12: 00000000000001b6
[16425.062924] R13: 0000000000000001 R14: 00007ffd866db090 R15: 0000561026afec40
[16425.063349] Code: 00 00 0f 84 58 f8 ff ff f7 45 98 00 00 20 00 0f 85 4b f8 ff ff 48 8b 7d a0 be 00 40 00 00 e8 50 23 fc ff 48 85 c0 49 89 c6 74 52 <8b> 40 18 45 31 ff 41 b8 01 00 00 00 48 89 df 8d 0c c5 00 00 00 
[16425.064475] RIP: __ext4_new_inode+0x898/0x1700 RSP: ffffc90006ae3ac8
[16425.064850] CR2: 0000000000000013
[16425.065080] ---[ end trace e88aa6967d2d389a ]---
[16425.156728] Aborting journal on device vdc-8.


(gdb) l *__ext4_new_inode+0x898
0xffffffff8130dd98 is in __ext4_new_inode (fs/ext4/ialloc.c:819).
814		if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
815	#ifdef CONFIG_EXT4_FS_POSIX_ACL
816			struct posix_acl *p = get_acl(dir, ACL_TYPE_DEFAULT);
817	
818			if (p) {
819				int acl_size = p->a_count * sizeof(ext4_acl_entry);
820	
821				nblocks += (S_ISDIR(mode) ? 2 : 1) *
822					__ext4_xattr_set_credits(sb, NULL /* inode */,
823						NULL /* block_bh */, acl_size,


Thanks,
Eric
