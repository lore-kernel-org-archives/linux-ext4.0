From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] ext4: reserve hole in the migration to non-extent based file
Date: Sat,  4 Jul 2015 00:51:51 +0800
Message-ID: <1435942311-2337-3-git-send-email-guaneryu@gmail.com>
References: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33389 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbbGCQ4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jul 2015 12:56:44 -0400
Received: by wiwl6 with SMTP id l6so232068232wiw.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2015 09:56:43 -0700 (PDT)
In-Reply-To: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_ind_migrate() hole is not reserved, a following
delayed allocation write to the "hole" would reclaim the same data
blocks again and results in fs corruption.

  # assmuing 4k block size ext4, with delalloc enabled
  # skip the first block and write to the second block
  xfs_io -fc "pwrite 4k 4k" -c "fsync" /mnt/ext4/testfile

  # converting to indirect-mapped file, which would move the data blocks
  # to the beginning of the file, but extent status cache still marks
  # that region as a hole
  chattr -e /mnt/ext4/testfile

  # delayed allocation writes to the "hole", reclaim the same data block
  # again, results in i_blocks corruption
  xfs_io -c "pwrite 0 4k" /mnt/ext4/testfile
  umount /mnt/ext4
  e2fsck -nf /dev/sda6
  ...
  Inode 53, i_blocks is 16, should be 8.  Fix? no
  ...

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/migrate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3651141..10824b0 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -620,7 +620,7 @@ int ext4_ind_migrate(struct inode *inode)
 	struct ext4_inode_info		*ei = EXT4_I(inode);
 	struct ext4_extent		*ex;
 	unsigned int			i, len;
-	ext4_lblk_t			end;
+	ext4_lblk_t			start, end;
 	ext4_fsblk_t			blk;
 	handle_t			*handle;
 	int				ret;
@@ -659,11 +659,12 @@ int ext4_ind_migrate(struct inode *inode)
 		goto errout;
 	}
 	if (eh->eh_entries == 0)
-		blk = len = 0;
+		blk = len = start = end = 0;
 	else {
 		len = le16_to_cpu(ex->ee_len);
 		blk = ext4_ext_pblock(ex);
-		end = le32_to_cpu(ex->ee_block) + len - 1;
+		start = le32_to_cpu(ex->ee_block);
+		end = start + len - 1;
 		if (end >= EXT4_NDIR_BLOCKS) {
 			ret = -EOPNOTSUPP;
 			goto errout;
@@ -672,7 +673,7 @@ int ext4_ind_migrate(struct inode *inode)
 
 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
 	memset(ei->i_data, 0, sizeof(ei->i_data));
-	for (i=0; i < len; i++)
+	for (i = start; i <= end; i++)
 		ei->i_data[i] = cpu_to_le32(blk++);
 	ext4_mark_inode_dirty(handle, inode);
 errout:
-- 
1.8.3.1

