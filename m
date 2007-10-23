From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: patch queue updates
Date: Tue, 23 Oct 2007 21:51:24 +0530
Message-ID: <471E1F84.80207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020701010103080409020007"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49602 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXJWRAG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2007 13:00:06 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9NGNt2x025182
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 02:23:55 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9NGNt7P2494566
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 02:23:56 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9NGNeam021653
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 02:23:40 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------020701010103080409020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updated patch

a) ext4-cleanup-2.patch
    sparse fixes for unlock error. 
b) add ext4-Return-after-ext4_error-in-case-of-failures.patch 
c) add mballoc-compilebench-fix.patch


patches are attached. New patches are added towards the end.

series
.....
ext4-cleanup-2.patch
ext4-cleanup-3.patch
ext4-cleanup-4.patch
48-bit-i_blocks.patch
large-file.patch
ext2_fix_max_size.patch
ext3_fix_max_size.patch
ext4_sync_group_desciptor_with_e2fsprogs.patch
ext4-Return-after-ext4_error-in-case-of-failures.patch
mballoc-compilebench-fix.patch

putting the diff for easy review.

-aneesh

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e29306e..8e42546 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -234,11 +234,13 @@ read_block_bitmap(struct super_block *sb, ext4_grpnum_t block_group)
 	} else {
 		bh = sb_bread(sb, bitmap_blk);
 	}
-	if (!bh)
+	if (!bh) {
 		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %lu, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -630,11 +632,13 @@ do_more:
 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group))
+		     sbi->s_itb_per_group)) {
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1746,11 +1750,13 @@ allocated:
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
-		     EXT4_SB(sb)->s_itb_per_group))
+		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fe7cf9e..8467b3d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3089,13 +3089,14 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		}
 	}
 	if (wind == 0) {
+		__u64 tstart;
 		/* file is quite large, we now preallocate with
 		 * the biggest configured window with regart to
 		 * logical offset */
 		wind = sbi->s_mb_prealloc_table[i - 1];
-		start = ac->ac_o_ex.fe_logical;
-		do_div(start, wind);
-		start = start * wind;
+		tstart = ac->ac_o_ex.fe_logical;
+		do_div(tstart, wind);
+		start = tstart * wind;
 	}
 	size = wind;
 	orig_size = size;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 801c499..10feae6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1713,6 +1713,9 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
+				__releases(kernel_sem)
+				__acquires(kernel_sem)
+
 {
 	struct buffer_head * bh;
 	struct ext4_super_block *es = NULL;

--------------020701010103080409020007
Content-Type: text/x-patch;
 name="ext4-cleanup-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ext4-cleanup-2.patch"

ext4:  Fix sparse warnings.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Fix sparse warnings related to static functions
and local variables.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/extents.c       |    6 +++---
 fs/ext4/inode.c         |   14 ++++++++------
 fs/ext4/super.c         |    3 +++
 include/linux/ext4_fs.h |    2 ++
 4 files changed, 16 insertions(+), 9 deletions(-)


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 392b76e..ce58d45 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1230,7 +1230,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
  * then we have to correct all indexes above.
  * TODO: do we need to correct tree in all cases?
  */
-int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
+static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
 	struct ext4_extent_header *eh;
@@ -1677,7 +1677,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
  * It's used in truncate case only, thus all requests are for
  * last index in the block only.
  */
-int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
+static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path)
 {
 	struct buffer_head *bh;
@@ -1947,7 +1947,7 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-int ext4_ext_remove_space(struct inode *inode, unsigned long start)
+static int ext4_ext_remove_space(struct inode *inode, unsigned long start)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a557c5c..8908ab3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2159,11 +2159,11 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	for (p = first; p < last; p++) {
 		u32 nr = le32_to_cpu(*p);
 		if (nr) {
-			struct buffer_head *bh;
+			struct buffer_head *tbh;
 
 			*p = 0;
-			bh = sb_find_get_block(inode->i_sb, nr);
-			ext4_forget(handle, 0, inode, bh, nr);
+			tbh = sb_find_get_block(inode->i_sb, nr);
+			ext4_forget(handle, 0, inode, tbh, nr);
 		}
 	}
 
@@ -2431,8 +2431,10 @@ void ext4_truncate(struct inode *inode)
 			return;
 	}
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_truncate(inode, page);
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		ext4_ext_truncate(inode, page);
+		return;
+	}
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle)) {
@@ -3283,7 +3285,7 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
+static int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
 			struct ext4_iloc iloc, handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e2bed20..0a4fc5b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1673,6 +1673,9 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
+				__releases(kernel_sem)
+				__acquires(kernel_sem)
+
 {
 	struct buffer_head * bh;
 	struct ext4_super_block *es = NULL;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index f6d4b4c..514464d 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -928,6 +928,8 @@ extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_new_blocks_old (handle_t *handle, struct inode *inode,
+			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,

--------------020701010103080409020007
Content-Type: text/x-patch;
 name="mballoc-compilebench-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mballoc-compilebench-fix.patch"

ext4: Fix mballoc BUG when running compilebench

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This fix the mballoc bug when running compile bench.
Instead of using direct division even though the arguments
are 32 bits we retain do_div. This would be needed if we
move to 64 bit logical block number.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/mballoc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fe7cf9e..8467b3d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3089,13 +3089,14 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		}
 	}
 	if (wind == 0) {
+		__u64 tstart;
 		/* file is quite large, we now preallocate with
 		 * the biggest configured window with regart to
 		 * logical offset */
 		wind = sbi->s_mb_prealloc_table[i - 1];
-		start = ac->ac_o_ex.fe_logical;
-		do_div(start, wind);
-		start = start * wind;
+		tstart = ac->ac_o_ex.fe_logical;
+		do_div(tstart, wind);
+		start = tstart * wind;
 	}
 	size = wind;
 	orig_size = size;

--------------020701010103080409020007
Content-Type: text/x-patch;
 name="ext4-Return-after-ext4_error-in-case-of-failures.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="ext4-Return-after-ext4_error-in-case-of-failures.patch"

ext4: Return after ext4_error in case of failures

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This fix some instances where we were continuing
after calling ext4_error. ext4_error call panic
only if errors=panic mount option is set. So
we need to make sure we return correctly after
ext4_error call

Reported by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/balloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e29306e..8e42546 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -234,11 +234,13 @@ read_block_bitmap(struct super_block *sb, ext4_grpnum_t block_group)
 	} else {
 		bh = sb_bread(sb, bitmap_blk);
 	}
-	if (!bh)
+	if (!bh) {
 		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %lu, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -630,11 +632,13 @@ do_more:
 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group))
+		     sbi->s_itb_per_group)) {
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1746,11 +1750,13 @@ allocated:
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
-		     EXT4_SB(sb)->s_itb_per_group))
+		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 

--------------020701010103080409020007--
