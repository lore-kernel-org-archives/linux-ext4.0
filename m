From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg
Date: Thu,  7 Jun 2012 09:52:33 -0400
Message-ID: <1339077153-13212-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Kees Cook <keescook@chromium.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48267 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2FGNwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 09:52:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext3 filesystems that are converted to use as many ext4 file system
features as possible will enable uninit_bg to speed up e2fsck times.
These file systems will have a native ext3 layout of inode tables and
block allocation bitmaps (as opposed to ext4's flex_bg layout).
Unfortunately, in these cases, when first allocating a block in an
uninitialized block group, ext4 would incorrectly calculate the number
of free blocks in that block group, and then errorneously report that
the file system was corrupt:

EXT4-fs error (device vdd): ext4_mb_generate_buddy:741: group 30, 32254 clusters in bitmap, 32258 in gd

This problem can be reproduced via:

    mke2fs -q -t ext4 -O ^flex_bg /dev/vdd 5g
    mount -t ext4 /dev/vdd /mnt
    fallocate -l 4600m /mnt/test

The problem was caused by a bone headed mistake in the check to see if a
particular metadata block was part of the block group.

Many thanks to Kees Cook for finding and bisecting the buggy commit
which introduced this bug (commit fd034a84e1, present since v3.2).

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Kees Cook <keescook@chromium.org>
---

Note: I send to push this to Linus soon, preferably before 3.5-rc2, so
I'd appreciate any comments ASAP.  Thanks!!

 fs/ext4/balloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 99b6324..cee7812 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -90,8 +90,8 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
 	 * unusual file system layouts.
 	 */
 	if (ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp), block_group)) {
-		block_cluster = EXT4_B2C(sbi, (start -
-					       ext4_block_bitmap(sb, gdp)));
+		block_cluster = EXT4_B2C(sbi,
+					 ext4_block_bitmap(sb, gdp) - start);
 		if (block_cluster < num_clusters)
 			block_cluster = -1;
 		else if (block_cluster == num_clusters) {
@@ -102,7 +102,7 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
 
 	if (ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp), block_group)) {
 		inode_cluster = EXT4_B2C(sbi,
-					 start - ext4_inode_bitmap(sb, gdp));
+					 ext4_inode_bitmap(sb, gdp) - start);
 		if (inode_cluster < num_clusters)
 			inode_cluster = -1;
 		else if (inode_cluster == num_clusters) {
@@ -114,7 +114,7 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
 	itbl_blk = ext4_inode_table(sb, gdp);
 	for (i = 0; i < sbi->s_itb_per_group; i++) {
 		if (ext4_block_in_group(sb, itbl_blk + i, block_group)) {
-			c = EXT4_B2C(sbi, start - itbl_blk + i);
+			c = EXT4_B2C(sbi, itbl_blk + i - start);
 			if ((c < num_clusters) || (c == inode_cluster) ||
 			    (c == block_cluster) || (c == itbl_cluster))
 				continue;
-- 
1.7.10.2.552.gaa3bb87

