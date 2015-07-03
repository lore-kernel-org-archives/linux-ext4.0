From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] ext4: be more strict when migrating to non-extent based file
Date: Sat,  4 Jul 2015 00:51:50 +0800
Message-ID: <1435942311-2337-2-git-send-email-guaneryu@gmail.com>
References: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36674 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbbGCQzf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jul 2015 12:55:35 -0400
Received: by widjy10 with SMTP id jy10so114364462wid.1
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2015 09:55:34 -0700 (PDT)
In-Reply-To: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the check in ext4_ind_migrate() is not enough before doing the
real conversion:

a) delayed allocated extents could bypass the check on eh->eh_entries
   and eh->eh_depth

This can be demonstrated by this script

  xfs_io -fc "pwrite 0 4k" -c "pwrite 8k 4k" /mnt/ext4/testfile
  chattr -e /mnt/ext4/testfile

where testfile has two extents but still be converted to non-extent
based file format.

b) only extent length is checked but not the offset, which would result
   in data lose (delalloc) or fs corruption (nodelalloc), because
   non-extent based file only supports at most (12 + 2^10 + 2^20 + 2^30)
   blocks

This can be demostrated by

  xfs_io -fc "pwrite 5T 4k" /mnt/ext4/testfile
  chattr -e /mnt/ext4/testfile
  sync

If delalloc is enabled, dmesg prints
  EXT4-fs warning (device dm-4): ext4_block_to_path:105: block 1342177280 > max in inode 53
  EXT4-fs (dm-4): Delayed block allocation failed for inode 53 at logical offset 1342177280 with max blocks 1 with error 5
  EXT4-fs (dm-4): This should not happen!! Data will be lost

If delalloc is disabled, e2fsck -nf shows corruption
  Inode 53, i_size is 5497558142976, should be 4096.  Fix? no

Fix the two issues by

a) forcing all delayed allocation blocks to be allocated before checking
   eh->eh_depth and eh->eh_entries
b) limiting the last logical block of the extent is within direct map

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/migrate.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b52374e..3651141 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -620,6 +620,7 @@ int ext4_ind_migrate(struct inode *inode)
 	struct ext4_inode_info		*ei = EXT4_I(inode);
 	struct ext4_extent		*ex;
 	unsigned int			i, len;
+	ext4_lblk_t			end;
 	ext4_fsblk_t			blk;
 	handle_t			*handle;
 	int				ret;
@@ -633,6 +634,14 @@ int ext4_ind_migrate(struct inode *inode)
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
 		return -EOPNOTSUPP;
 
+	/*
+	 * In order to get correct extent info, force all delayed allocation
+	 * blocks to be allocated, otherwise delayed allocation blocks may not
+	 * be reflected and bypass the checks on extent header.
+	 */
+	if (test_opt(inode->i_sb, DELALLOC))
+		ext4_alloc_da_blocks(inode);
+
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -654,7 +663,8 @@ int ext4_ind_migrate(struct inode *inode)
 	else {
 		len = le16_to_cpu(ex->ee_len);
 		blk = ext4_ext_pblock(ex);
-		if (len > EXT4_NDIR_BLOCKS) {
+		end = le32_to_cpu(ex->ee_block) + len - 1;
+		if (end >= EXT4_NDIR_BLOCKS) {
 			ret = -EOPNOTSUPP;
 			goto errout;
 		}
-- 
1.8.3.1

