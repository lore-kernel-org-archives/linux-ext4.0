From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] ext4: fix NULL pointer dereference in ext4_validate_block_bitmap()
Date: Thu, 27 Feb 2014 11:01:18 +0100
Message-ID: <1393495278-11100-1-git-send-email-mlombard@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaB0KB2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 05:01:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If EXT4FS_DEBUG is defined, ext4_count_clusters() performs some additional
checks on the block bitmaps at mount time, ext4_validate_block_bitmap()
is called but the superblock doesn't contain a valid s_group_info
pointer yet.

This patch fixes the bug by modifying ext4_validate_block_bitmap() so
it verifies whether the s_group_info pointer is valid or not before
using it.

BUG: unable to handle kernel NULL pointer dereference at           (null)
[   21.413041] IP: [<ffffffff8127c454>] ext4_validate_block_bitmap+0x54/0x300
[   21.413041] PGD 2ef6b067 PUD 2efed067 PMD 0
[   21.413041] Oops: 0000 [#1] SMP
[   21.413041] Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc loop cirrus ttm drm_kms_helper snd_pcm drm snd_timer snd i2c_piix4 soundcore parport_pc parport i2c_core pcspkr xfs libcrc32c e1000 floppy
[   21.413041] CPU: 0 PID: 2490 Comm: mount Not tainted 3.14.0-rc4+ #9
[   21.413041] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   21.413041] task: ffff88002e493600 ti: ffff880033094000 task.ti: ffff880033094000
[   21.413041] RIP: 0010:[<ffffffff8127c454>]  [<ffffffff8127c454>] ext4_validate_block_bitmap+0x54/0x300
[   21.413041] RSP: 0018:ffff880033095b38  EFLAGS: 00010246
[   21.413041] RAX: ffff88002dc47800 RBX: 0000000000000000 RCX: 0000000000000020
[   21.413041] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88002dc45000
[   21.413041] RBP: ffff880033095b88 R08: 000000000000000a R09: 00000000000003d7
[   21.413041] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003fb7d800
[   21.413041] R13: ffff88002dc45000 R14: ffff88003d113820 R15: 0000000000000000
[   21.413041] FS:  00007f9e2b4f47e0(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   21.413041] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.413041] CR2: 0000000000000000 CR3: 000000003d776000 CR4: 00000000000006f0
[   21.413041] Stack:
[   21.413041]  ffff88002e493600 ffffffff810c76b0 ffff880033095b48 ffff880033095b48
[   21.413041]  ffff88003d113820 ffff88003d113820 ffff88002dc45000 0000000000000000
[   21.413041]  ffff88003fb7d800 0000000000000000 ffff880033095bb8 ffffffff8127c782
[   21.413041] Call Trace:
[   21.413041]  [<ffffffff810c76b0>] ? wake_atomic_t_function+0x40/0x40
[   21.413041]  [<ffffffff8127c782>] ext4_wait_block_bitmap+0x82/0xf0
[   21.413041]  [<ffffffff8127d23a>] ext4_read_block_bitmap+0x3a/0x60
[   21.413041]  [<ffffffff8127d340>] ext4_count_free_clusters+0xe0/0x1c0
[   21.413041]  [<ffffffff812a8508>] ext4_fill_super+0x1448/0x2ec0
[   21.413041]  [<ffffffff811f2168>] ? iput+0x48/0x190
[   21.413041]  [<ffffffff811da31c>] mount_bdev+0x19c/0x1e0
[   21.413041]  [<ffffffff812a70c0>] ? ext4_calculate_overhead+0x3d0/0x3d0
[   21.413041]  [<ffffffff811be755>] ? __kmalloc_track_caller+0x55/0x240
[   21.413041]  [<ffffffff81295205>] ext4_mount+0x15/0x20
[   21.413041]  [<ffffffff811db193>] mount_fs+0x43/0x1b0
[   21.413041]  [<ffffffff81188010>] ? __alloc_percpu+0x10/0x20
[   21.413041]  [<ffffffff811f5873>] vfs_kern_mount+0x73/0x110
[   21.413041]  [<ffffffff811f7d89>] do_mount+0x259/0xa70
[   21.413041]  [<ffffffff811820a6>] ? memdup_user+0x46/0x90
[   21.413041]  [<ffffffff8118214b>] ? strndup_user+0x5b/0x80
[   21.413041]  [<ffffffff811f887e>] SyS_mount+0x8e/0xe0
[   21.413041]  [<ffffffff816ff1e9>] system_call_fastpath+0x16/0x1b
[   21.413041] Code: f8 02 00 00 3b 50 40 0f 83 5e 02 00 00 49 89 ce 8b 88 a8 00 00 00 41 89 d7 49 89 f4 89 d6 48 8b 90 78 02 00 00 d3 ee 48 8b 48 38 <48> 8b 14 f2 48 83 e9 01 4c 21 f9 48 8b 14 ca 48 89 55 c0 49 8b
[   21.413041] RIP  [<ffffffff8127c454>] ext4_validate_block_bitmap+0x54/0x300
[   21.413041]  RSP <ffff880033095b38>
[   21.413041] CR2: 0000000000000000
[   21.485243] ---[ end trace 768c203492f003e1 ]---
---
 fs/ext4/balloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6ea7b14..8de0ea8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -355,25 +355,32 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 			       struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
-	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
+	struct ext4_group_info *grp = NULL;
 
 	if (buffer_verified(bh))
 		return;
 
+	if (EXT4_SB(sb)->s_group_info)
+		grp = ext4_get_group_info(sb, block_group);
+
 	ext4_lock_group(sb, block_group);
 	blk = ext4_valid_block_bitmap(sb, desc, block_group, bh);
 	if (unlikely(blk != 0)) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
 			   block_group, blk);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
 			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	set_buffer_verified(bh);
-- 
Maurizio Lombardi

