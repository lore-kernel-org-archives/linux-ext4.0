From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 5/7]ext4: Implement the block allocation with preferred
 allocation range
Date: Tue, 23 Jun 2009 17:25:39 +0900
Message-ID: <4A409183.3020202@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4: Implement the block allocation with preferred blocks

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This patch changes the block allocator to use inode preferred blocks.

Set the following information from ext4_inode->i_alloc_rule which
specified inode has to ext4_allocation_context for block allocator.

  1. start physical offset to use
  2. block length that is covered
  3. flag (0: mandatory 1:advisory)

If flag is "mandatory", set EXT4_MB_HINT_TRY_GOAL and EXT4_MB_HINT_GOAL_ONLY
flags to ext4_allocation_context->ac_flag.
On the other hand, in "advisory" case, only set EXT4_MB_HINT_TRY_GOAL.
There is no effect to existing block allocation algorithm for ext4.

If requested blocks count is more than blocks counts ext4_alloc_rule has,
block allocator tries to use ext4_alloc_rule->len blocks
from ext4_alloc_rule->start at first,
and then uses the rest of blocks with normal mballoc algorithm.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/ext4.h    |    4 ++++
 fs/ext4/extents.c |   23 ++++++++++++++++-------
 fs/ext4/mballoc.c |   27 +++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 40f1577..b6469d5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -93,6 +93,9 @@ typedef unsigned int ext4_group_t;
 /* use in-allocatable blocks that have advisory flag */
 #define EXT4_MB_ALLOC_ADVISORY	       4096

+#define EXT4_MB_HINT_FLAGS(flag)        ((flag) ? EXT4_MB_HINT_TRY_GOAL : \
+				EXT4_MB_HINT_TRY_GOAL|EXT4_MB_HINT_GOAL_ONLY)
+
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
 	struct inode *inode;
@@ -1400,6 +1403,7 @@ extern void ext4_mb_release_arule_list(struct ext4_sb_info *);
 extern int ext4_mb_add_inode_arule(struct inode *inode,
 					struct ext4_alloc_rule *arule);
 extern void ext4_mb_del_inode_arule(struct inode *inode);
+extern void ext4_mb_dec_inode_arule(struct inode *inode, unsigned int len);

 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f9ab60f..240702c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2783,6 +2783,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
+	struct ext4_inode_info *ei = EXT4_I(inode);

 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%u requested for inode %u\n",
@@ -2938,15 +2939,23 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,

 	/* allocate new block */
 	ar.inode = inode;
-	ar.goal = ext4_ext_find_goal(inode, path, iblock);
 	ar.logical = iblock;
-	ar.len = allocated;
-	if (S_ISREG(inode->i_mode))
-		ar.flags = EXT4_MB_HINT_DATA;
-	else
-		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
+	if (ei->i_alloc_rule && ei->i_alloc_rule->alloc_pid == current->pid) {
+		ar.goal = ei->i_alloc_rule->alloc_rule.start;
+		ar.len = allocated;
+		ar.flags = EXT4_MB_HINT_FLAGS(
+				ei->i_alloc_rule->alloc_rule.alloc_flag);
+	} else {
+		ar.goal = ext4_ext_find_goal(inode, path, iblock);
+		ar.len = allocated;
+		if (S_ISREG(inode->i_mode))
+			ar.flags = EXT4_MB_HINT_DATA;
+		else
+			/* disable in-core pa for non-regular files */
+			ar.flags = 0;
+	}
 	newblock = ext4_mb_new_blocks(handle, &ar, &err);
+	ext4_mb_dec_inode_arule(inode, ar.len);
 	if (!newblock)
 		goto out2;
 	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1a97a3d..ff79189 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4579,6 +4579,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	struct super_block *sb = ar->inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	struct ext4_inode_info *ei = EXT4_I(ar->inode);
 	ext4_group_t group;
 	unsigned int len;
 	ext4_fsblk_t goal;
@@ -4587,10 +4588,6 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	/* we can't allocate > group size */
 	len = ar->len;

-	/* just a dirty hack to filter too big requests  */
-	if (len >= EXT4_BLOCKS_PER_GROUP(sb) - 10)
-		len = EXT4_BLOCKS_PER_GROUP(sb) - 10;
-
 	/* start searching from the goal */
 	goal = ar->goal;
 	if (goal < le32_to_cpu(es->s_first_data_block) ||
@@ -4598,6 +4595,16 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 		goal = le32_to_cpu(es->s_first_data_block);
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);

+	if (ei->i_alloc_rule && ei->i_alloc_rule->alloc_pid == current->pid) {
+		/* we need to adjust len not to over a blockgroup region */
+		if (len + block > EXT4_BLOCKS_PER_GROUP(sb))
+			len = EXT4_BLOCKS_PER_GROUP(sb) - block;
+	} else {
+		/* just a dirty hack to filter too big requests  */
+		if (len >= EXT4_BLOCKS_PER_GROUP(sb) - 10)
+			len = EXT4_BLOCKS_PER_GROUP(sb) - 10;
+	}
+
 	/* set up allocation goals */
 	ac->ac_b_ex.fe_logical = ar->logical;
 	ac->ac_b_ex.fe_group = 0;
@@ -5795,3 +5802,15 @@ void ext4_mb_del_inode_arule(struct inode *inode)
 	kfree(ei->i_alloc_rule);
 	ei->i_alloc_rule = NULL;
 }
+
+void ext4_mb_dec_inode_arule(struct inode *inode, unsigned int len)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	if (ei->i_alloc_rule && ei->i_alloc_rule->alloc_pid == current->pid) {
+		ei->i_alloc_rule->alloc_rule.len -= len;
+		ei->i_alloc_rule->alloc_rule.start += len;
+		if (ei->i_alloc_rule->alloc_rule.len <= 0)
+			ext4_mb_del_inode_arule(inode);
+	}
+}


