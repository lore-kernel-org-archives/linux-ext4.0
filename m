From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Get rid of extend_disksize parameter of ext4_get_blocks_handle()
Date: Wed, 20 May 2009 19:25:34 +0200
Message-ID: <1242840334-5117-3-git-send-email-jack@suse.cz>
References: <1242840334-5117-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZETRZf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 13:25:35 -0400
In-Reply-To: <1242840334-5117-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Get rid of extenddisksize parameter of ext4_get_blocks_handle(). This seems to
be a relict from some old days and setting disksize in this function does not
make much sence. Currently it was set only by ext4_getblk().  Since the
parameter has some effect only if create == 1, it is easy to check that the
three callers which end up calling ext4_getblk() with create == 1 (ext4_append,
ext4_quota_write, ext4_mkdir) do the right thing and set disksize themselves.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/dir.c     |    3 +--
 fs/ext4/ext4.h    |    6 ++----
 fs/ext4/extents.c |   16 +++-------------
 fs/ext4/inode.c   |   43 ++++++++++++-------------------------------
 4 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b647899..c8e0623 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -131,8 +131,7 @@ static int ext4_readdir(struct file *filp,
 		struct buffer_head *bh = NULL;
 
 		map_bh.b_state = 0;
-		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh,
-						0, 0, 0);
+		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d0f15ef..2b02ae0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1338,8 +1338,7 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
 				       int chunk);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			       ext4_lblk_t iblock, unsigned int max_blocks,
-			       struct buffer_head *bh_result,
-			       int create, int extend_disksize);
+			       struct buffer_head *bh_result, int create);
 extern void ext4_ext_truncate(struct inode *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
@@ -1347,8 +1346,7 @@ extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned int max_blocks,
-			struct buffer_head *bh, int create,
-			int extend_disksize, int flag);
+			struct buffer_head *bh, int create, int flag);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e403321..59e9327 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2775,9 +2775,8 @@ fix_extent_len:
  * return < 0, error case.
  */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
-			ext4_lblk_t iblock,
-			unsigned int max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize)
+			ext4_lblk_t iblock, unsigned int max_blocks,
+			struct buffer_head *bh_result, int create)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
@@ -2786,7 +2785,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
-	loff_t disksize;
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%u requested for inode %u\n",
@@ -2974,14 +2972,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
-	if (extend_disksize) {
-		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
-		if (disksize > i_size_read(inode))
-			disksize = i_size_read(inode);
-		if (disksize > EXT4_I(inode)->i_disksize)
-			EXT4_I(inode)->i_disksize = disksize;
-	}
-
 	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
@@ -3143,7 +3133,7 @@ retry:
 		}
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
-					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
+					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6bd6ce..7711968 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -916,8 +916,7 @@ err_out:
  */
 static int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 				  ext4_lblk_t iblock, unsigned int maxblocks,
-				  struct buffer_head *bh_result,
-				  int create, int extend_disksize)
+				  struct buffer_head *bh_result, int create)
 {
 	int err = -EIO;
 	ext4_lblk_t offsets[4];
@@ -927,11 +926,8 @@ static int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	int indirect_blks;
 	int blocks_to_boundary = 0;
 	int depth;
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
-	loff_t disksize;
-
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
 	J_ASSERT(handle != NULL || create == 0);
@@ -997,18 +993,6 @@ static int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
 					partial, indirect_blks, count);
-	/*
-	 * i_disksize growing is protected by i_data_sem.  Don't forget to
-	 * protect it if you're about to implement concurrent
-	 * ext4_get_block() -bzzz
-	*/
-	if (!err && extend_disksize) {
-		disksize = ((loff_t) iblock + count) << inode->i_blkbits;
-		if (disksize > i_size_read(inode))
-			disksize = i_size_read(inode);
-		if (disksize > ei->i_disksize)
-			ei->i_disksize = disksize;
-	}
 	if (err)
 		goto cleanup;
 
@@ -1144,7 +1128,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  */
 int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned int max_blocks, struct buffer_head *bh,
-			int create, int extend_disksize, int flag)
+			int create, int flag)
 {
 	int retval;
 
@@ -1157,10 +1141,10 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, 0, 0);
+				bh, 0);
 	} else {
 		retval = ext4_get_blocks_handle(handle,
-				inode, block, max_blocks, bh, 0, 0);
+				inode, block, max_blocks, bh, 0);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -1200,10 +1184,10 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	 */
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, create, extend_disksize);
+				bh, create);
 	} else {
 		retval = ext4_get_blocks_handle(handle, inode, block,
-				max_blocks, bh, create, extend_disksize);
+				max_blocks, bh, create);
 
 		if (retval > 0 && buffer_new(bh)) {
 			/*
@@ -1256,7 +1240,7 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
 	}
 
 	ret = ext4_get_blocks_wrap(handle, inode, iblock,
-					max_blocks, bh_result, create, 0, 0);
+					max_blocks, bh_result, create, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -1281,8 +1265,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
-	err = ext4_get_blocks_wrap(handle, inode, block, 1,
-					&dummy, create, 1, 0);
+	err = ext4_get_blocks_wrap(handle, inode, block, 1, &dummy, create, 0);
 	/*
 	 * ext4_get_blocks_handle() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
@@ -1989,7 +1972,7 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle = ext4_journal_current_handle();
 	BUG_ON(!handle);
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+				   bh_result, create, EXT4_DELALLOC_RSVED);
 	if (ret <= 0)
 		return ret;
 
@@ -2007,9 +1990,7 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	}
 
 	/*
-	 * Update on-disk size along with block allocation we don't
-	 * use 'extend_disksize' as size may change within already
-	 * allocated block -bzzz
+	 * Update on-disk size along with block allocation.
 	 */
 	disksize = ((loff_t) iblock + ret) << inode->i_blkbits;
 	if (disksize > i_size_read(inode))
@@ -2306,7 +2287,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	 * preallocated blocks are unmapped but should treated
 	 * the same as allocated blocks.
 	 */
-	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0, 0);
+	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
 	if ((ret == 0) && !buffer_delay(bh_result)) {
 		/* the block isn't (pre)allocated yet, let's reserve space */
 		/*
@@ -2349,7 +2330,7 @@ static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
 	 * so call get_block_wrap with create = 0
 	 */
 	ret = ext4_get_blocks_wrap(NULL, inode, iblock, max_blocks,
-				   bh_result, 0, 0, 0);
+				   bh_result, 0, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
-- 
1.6.0.2

