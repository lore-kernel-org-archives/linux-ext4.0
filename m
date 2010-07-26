From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: don't print scary messages for allocation failures
 post-abort
Date: Mon, 26 Jul 2010 14:33:40 -0500
Message-ID: <4C4DE314.6030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0GZTdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 15:33:41 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6QJXeam020959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 15:33:41 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6QJXeqi016366
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 15:33:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I often get emails containing the "This should not happen!!" message,
conveniently trimmed to remove things like:

sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 03 13 c9 70 00 00 28 00
end_request: I/O error, dev sda, sector 51628400
Aborting journal on device dm-0-8.
EXT4-fs error (device dm-0): ext4_journal_start_sb: Detected aborted journal
EXT4-fs (dm-0): Remounting filesystem read-only

I don't think there is any value to the verbosity if the reason is
due to a filesystem abort; it just obfuscates the root cause.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..23875e6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2221,6 +2221,8 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 
 	blks = ext4_map_blocks(handle, mpd->inode, &map, get_blocks_flags);
 	if (blks < 0) {
+		struct super_block *sb = mpd->inode->i_sb;
+
 		err = blks;
 		/*
 		 * If get block returns with error we simply
@@ -2231,7 +2233,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 			return 0;
 
 		if (err == -ENOSPC &&
-		    ext4_count_free_blocks(mpd->inode->i_sb)) {
+		    ext4_count_free_blocks(sb)) {
 			mpd->retval = err;
 			return 0;
 		}
@@ -2243,16 +2245,17 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		 * writepage and writepages will again try to write
 		 * the same.
 		 */
-		ext4_msg(mpd->inode->i_sb, KERN_CRIT,
-			 "delayed block allocation failed for inode %lu at "
-			 "logical offset %llu with max blocks %zd with "
-			 "error %d", mpd->inode->i_ino,
-			 (unsigned long long) next,
-			 mpd->b_size >> mpd->inode->i_blkbits, err);
-		printk(KERN_CRIT "This should not happen!!  "
-		       "Data will be lost\n");
-		if (err == -ENOSPC) {
-			ext4_print_free_blocks(mpd->inode);
+		if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
+			ext4_msg(sb, KERN_CRIT,
+				 "delayed block allocation failed for inode %lu "
+				 "at logical offset %llu with max blocks %zd "
+				 "with error %d", mpd->inode->i_ino,
+				 (unsigned long long) next,
+				 mpd->b_size >> mpd->inode->i_blkbits, err);
+			ext4_msg(sb, KERN_CRIT,
+				"This should not happen!! Data will be lost\n");
+			if (err == -ENOSPC)
+				ext4_print_free_blocks(mpd->inode);
 		}
 		/* invalidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..b941486 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3889,6 +3889,9 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	struct super_block *sb = ac->ac_sb;
 	ext4_group_t ngroups, i;
 
+	if (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
+		return;
+
 	printk(KERN_ERR "EXT4-fs: Can't allocate:"
 			" Allocation context details:\n");
 	printk(KERN_ERR "EXT4-fs: status %d flags %d\n",


