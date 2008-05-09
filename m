From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Oops when mounting corrupted image
Date: Sat, 10 May 2008 01:54:42 +0200
Message-ID: <20080509235442.GA2367@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753483AbYEIXyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 19:54:45 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

i get the following oops when mounting a corrupted image with ext4:

[  181.076778] JBD: corrupted journal superblock
[  181.081155] JBD: error -5 scanning journal
[  181.085459] EXT4-fs: error loading journal.
[  181.090472] BUG: unable to handle kernel NULL pointer dereference at
00000120
[  181.090764] IP: [<c0200556>] ext4_sync_fs+0x16/0x90
[  181.091006] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  181.091289] Modules linked in: nfsd exportfs
[  181.091351] 
[  181.091351] Pid: 4556, comm: mount Not tainted
(2.6.26-rc1-00279-g28a4acb-dirty #5)
[  181.091351] EIP: 0060:[<c0200556>] EFLAGS: 00010286 CPU: 0
[  181.091351] EIP is at ext4_sync_fs+0x16/0x90
[  181.091351] EAX: 00000000 EBX: c86c0860 ECX: c0200540 EDX: 00000001
[  181.091351] ESI: 00000001 EDI: c084db80 EBP: c8900de0 ESP: c8900dd0
[  181.091351]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  181.091351] Process mount (pid: 4556, ti=c8900000 task=c86caf40
task.ti=c8900000)
[  181.091351] Stack: c01b6b70 c084db80 c86c0860 c01b6b70 c8900e48
c01b6d08 00000246 c8900e08 
[  181.091351]        c8900e20 00000000 ffffffff c86c0860 c86c09bc
00000002 c8900e20 00000000 
[  181.091351]        00000000 c8900e3c c86c0ab8 c86c0ac0 c8900e3c
00000246 00000001 00000246 
[  181.091351] Call Trace:
[  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
[  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
[  181.091351]  [<c01b6d08>] ? vfs_quota_off+0x198/0x5d0
[  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
[  181.091351]  [<c018293d>] ? deactivate_super+0x6d/0x90
[  181.091351]  [<c0182e74>] ? get_sb_bdev+0x114/0x120
[  181.091351]  [<c019780d>] ? alloc_vfsmnt+0xdd/0x120
[  181.091351]  [<c019780d>] ? alloc_vfsmnt+0xdd/0x120
[  181.091351]  [<c01fe962>] ? ext4_get_sb+0x22/0x30
[  181.091351]  [<c0201090>] ? ext4_fill_super+0x0/0x21e0
[  181.091351]  [<c018299a>] ? vfs_kern_mount+0x3a/0x90
[  181.091351]  [<c0182a49>] ? do_kern_mount+0x39/0xd0
[  181.091351]  [<c0198a45>] ? do_new_mount+0x65/0x90
[  181.091351]  [<c0198bca>] ? do_mount+0x15a/0x1b0
[  181.091351]  [<c01471fd>] ? trace_hardirqs_on+0xbd/0x140
[  181.091351]  [<c06817d9>] ? _spin_unlock_irqrestore+0x39/0x70
[  181.091351]  [<c013d279>] ? down+0x29/0x40
[  181.091351]  [<c0198c8f>] ? sys_mount+0x6f/0xb0
[  181.091351]  [<c0103d8d>] ? sysenter_past_esp+0x6a/0xb1
[  181.091351]  =======================
[  181.091351] Code: 00 c6 42 11 00 e8 3b e8 01 00 5d c3 89 f6 8d bc 27
00 00 00 00 55 89 e5 56 89 d6 53 89 c3 83 ec 08 85 c0 74 64 8b 83 ac 02
00 00 <8b> 90 20 01 00 00 85 d2 74 40 c6 43 11 00 8d 55 f4 8b 80 20 01 
[  181.091351] EIP: [<c0200556>] ext4_sync_fs+0x16/0x90 SS:ESP
0068:c8900dd0
[  181.106189] ---[ end trace e810f4375c8543b9 ]---

An example image resulting in this oops can be found here:

http://www.cccmz.de/~snakebyte/ext4.9.img.bz2

The following patch fixes the issue for me, the mount just fails
with:

[  236.601536] JBD: corrupted journal superblock
[  236.606073] JBD: error -5 scanning journal
[  236.611195] EXT4-fs: error loading journal.


Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/fs/ext4/super.c.orig	2008-05-10 03:47:34.000000000 +0200
+++ linux/fs/ext4/super.c	2008-05-10 03:48:05.000000000 +0200
@@ -2747,6 +2747,10 @@ static int ext4_sync_fs(struct super_blo
 	tid_t target;
 
 	sb->s_dirt = 0;
+
+	if (!EXT4_SB(sb))
+		return 0;
+
 	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
 		if (wait)
 			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
