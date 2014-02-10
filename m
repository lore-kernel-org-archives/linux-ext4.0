From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] ext4: initialize multi-block allocator before checking block descriptors
Date: Mon, 10 Feb 2014 14:25:07 +0400
Message-ID: <1392027907-25924-1-git-send-email-a3at.mail@gmail.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org (open list)
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47290 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBJKZU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Feb 2014 05:25:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

with EXT4FS_DEBUG ext4_count_free_clusters() will call
ext4_read_block_bitmap() without s_group_info initialized.

Here is bt:
(gdb) bt
 #0  ext4_get_group_info (group=0, sb=0xffff880079a10000) at ext4.h:2430
 #1  ext4_validate_block_bitmap (sb=sb@entry=0xffff880079a10000, desc=desc@entry=0xffff880056510000, block_group=block_group@entry=0,
     bh=bh@entry=0xffff88007bf2b2d8) at balloc.c:358
 #2  0xffffffff81232202 in ext4_wait_block_bitmap (sb=sb@entry=0xffff880079a10000, block_group=block_group@entry=0,
     bh=bh@entry=0xffff88007bf2b2d8) at balloc.c:476
 #3  0xffffffff81232eaf in ext4_read_block_bitmap (sb=sb@entry=0xffff880079a10000, block_group=block_group@entry=0) at balloc.c:489
 #4  0xffffffff81232fc0 in ext4_count_free_clusters (sb=sb@entry=0xffff880079a10000) at balloc.c:665
 #5  0xffffffff81259ffa in ext4_check_descriptors (first_not_zeroed=<synthetic pointer>, sb=0xffff880079a10000) at super.c:2143
 #6  ext4_fill_super (sb=sb@entry=0xffff880079a10000, data=<optimized out>, data@entry=0x0 <irq_stack_union>, silent=silent@entry=0)
     at super.c:3851
 #7  0xffffffff811b8340 in mount_bdev (fs_type=<optimized out>, flags=0, dev_name=<optimized out>, data=0x0 <irq_stack_union>,
     fill_super=fill_super@entry=0xffffffff812589c0 <ext4_fill_super>) at super.c:987
 #8  0xffffffff8124ec35 in ext4_mount (fs_type=<optimized out>, flags=<optimized out>, dev_name=<optimized out>, data=<optimized out>)
     at super.c:5365
 #9  0xffffffff811b8cf9 in mount_fs (type=type@entry=0xffffffff81c71840 <ext4_fs_type>, flags=flags@entry=0,
     name=name@entry=0xffff880077a80c70 "/dev/loop4", data=data@entry=0x0 <irq_stack_union>) at super.c:1090
 #10 0xffffffff811d2ff3 in vfs_kern_mount (type=type@entry=0xffffffff81c71840 <ext4_fs_type>, flags=0,
     name=name@entry=0xffff880077a80c70 "/dev/loop4", data=data@entry=0x0 <irq_stack_union>) at namespace.c:813
 #11 0xffffffff811d55de in do_new_mount (data=0x0 <irq_stack_union>, name=0xffff880077a80c70 "/dev/loop4", mnt_flags=32,
     flags=<optimized out>, fstype=0xffff880077a80ca0 "ext4-insane", path=0xffff88007a5b1ed0) at namespace.c:2068
 #12 do_mount (dev_name=0xffff880077a80c70 "/dev/loop4", dir_name=<optimized out>, type_page=0xffff880077a80ca0 "ext4-insane",
     flags=<optimized out>, flags@entry=3236757504, data_page=0x0 <irq_stack_union>) at namespace.c:2392
 #13 0xffffffff811d6183 in SYSC_mount (data=0x0 <irq_stack_union>, flags=3236757504, type=<optimized out>, dir_name=<optimized out>,
     dev_name=0x7ffad9649c20 "/dev/loop4") at namespace.c:2586
 #14 SyS_mount (dev_name=140715365800992, dir_name=<optimized out>, type=<optimized out>, flags=3236757504, data=0) at namespace.c:2559

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 fs/ext4/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1f7784d..7e8c5e4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3838,6 +3838,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
+	ext4_ext_init(sb);
+	err = ext4_mb_init(sb);
+	if (err) {
+		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
+			 err);
+		goto failed_mount;
+	}
+
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread(sb, block);
@@ -4094,14 +4102,6 @@ no_journal:
 		goto failed_mount4a;
 	}
 
-	ext4_ext_init(sb);
-	err = ext4_mb_init(sb);
-	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
-			 err);
-		goto failed_mount5;
-	}
-
 	err = ext4_register_li_request(sb, first_not_zeroed);
 	if (err)
 		goto failed_mount6;
@@ -4175,9 +4175,6 @@ failed_mount8:
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
-	ext4_mb_release(sb);
-failed_mount5:
-	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);
 failed_mount4a:
 	dput(sb->s_root);
@@ -4207,7 +4204,10 @@ failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	ext4_kvfree(sbi->s_group_desc);
+
+	ext4_mb_release(sb);
 failed_mount:
+	ext4_ext_release(sb);
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
 	if (sbi->s_proc) {
-- 
1.8.5.2

