From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Remove unnecessary double parentheses
Date: Fri, 25 Apr 2014 14:24:36 +0200
Message-ID: <1398428676-15910-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaDYMYl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2014 08:24:41 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3PCOepq032517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2014 08:24:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unnecessary double parentheses.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |  6 +++---
 fs/ext4/inode.c   | 10 +++++-----
 fs/ext4/migrate.c |  2 +-
 fs/ext4/super.c   |  2 +-
 fs/ext4/xattr.c   |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 01b0c20..130a203 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4018,7 +4018,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 						    allocated, newblock);
 
 	/* get_block() before submit the IO, split the extent */
-	if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
+	if (flags & EXT4_GET_BLOCKS_PRE_IO) {
 		ret = ext4_split_convert_extents(handle, inode, map,
 					 path, flags | EXT4_GET_BLOCKS_CONVERT);
 		if (ret <= 0)
@@ -4038,7 +4038,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 		goto out;
 	}
 	/* IO end_io complete, convert the filled extent to written */
-	if ((flags & EXT4_GET_BLOCKS_CONVERT)) {
+	if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		ret = ext4_convert_unwritten_extents_endio(handle, inode, map,
 							path);
 		if (ret >= 0) {
@@ -4477,7 +4477,7 @@ got_allocated_blocks:
 		 * For non asycn direct IO case, flag the inode state
 		 * that we need to perform conversion when IO is done.
 		 */
-		if ((flags & EXT4_GET_BLOCKS_PRE_IO))
+		if (flags & EXT4_GET_BLOCKS_PRE_IO)
 			set_unwritten = 1;
 		if (ext4_should_dioread_nolock(inode))
 			map->m_flags |= EXT4_MAP_UNINIT;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d7b7462..b866dbb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -443,7 +443,7 @@ static void ext4_map_blocks_es_recheck(handle_t *handle,
 	 * could be converted.
 	 */
 	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
-		down_read((&EXT4_I(inode)->i_data_sem));
+		down_read(&EXT4_I(inode)->i_data_sem);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map, flags &
 					     EXT4_GET_BLOCKS_KEEP_SIZE);
@@ -555,7 +555,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * file system block.
 	 */
 	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
-		down_read((&EXT4_I(inode)->i_data_sem));
+		down_read(&EXT4_I(inode)->i_data_sem);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map, flags &
 					     EXT4_GET_BLOCKS_KEEP_SIZE);
@@ -627,7 +627,7 @@ found:
 	 * the write lock of i_data_sem, and call get_blocks()
 	 * with create == 1 flag.
 	 */
-	down_write((&EXT4_I(inode)->i_data_sem));
+	down_write(&EXT4_I(inode)->i_data_sem);
 
 	/*
 	 * if the caller is from delayed allocation writeout path
@@ -1540,7 +1540,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		ext4_es_lru_add(inode);
 		if (ext4_es_is_hole(&es)) {
 			retval = 0;
-			down_read((&EXT4_I(inode)->i_data_sem));
+			down_read(&EXT4_I(inode)->i_data_sem);
 			goto add_delayed;
 		}
 
@@ -1577,7 +1577,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
 	 */
-	down_read((&EXT4_I(inode)->i_data_sem));
+	down_read(&EXT4_I(inode)->i_data_sem);
 	if (ext4_has_inline_data(inode)) {
 		/*
 		 * We will soon create blocks for this page, and let
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 2ae73a8..ec09243 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -505,7 +505,7 @@ int ext4_ext_migrate(struct inode *inode)
 	 * with i_data_sem held to prevent racing with block
 	 * allocation.
 	 */
-	down_read((&EXT4_I(inode)->i_data_sem));
+	down_read(&EXT4_I(inode)->i_data_sem);
 	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
 	up_read((&EXT4_I(inode)->i_data_sem));
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..299891b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1903,7 +1903,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	if (!(sbi->s_mount_state & EXT4_VALID_FS))
 		ext4_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, "
 			 "running e2fsck is recommended");
-	else if ((sbi->s_mount_state & EXT4_ERROR_FS))
+	else if (sbi->s_mount_state & EXT4_ERROR_FS)
 		ext4_msg(sb, KERN_WARNING,
 			 "warning: mounting fs with errors, "
 			 "running e2fsck is recommended");
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 4eec399..3a08470 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -896,7 +896,7 @@ inserted:
 			 * take i_data_sem because we will test
 			 * i_delalloc_reserved_flag in ext4_mb_new_blocks
 			 */
-			down_read((&EXT4_I(inode)->i_data_sem));
+			down_read(&EXT4_I(inode)->i_data_sem);
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			up_read((&EXT4_I(inode)->i_data_sem));
-- 
1.8.3.1

