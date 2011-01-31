From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 2/4] Update ext4 routines to specify journal not to fail the
 transaction allocation.
Date: Sun, 30 Jan 2011 17:22:40 -0800
Message-ID: <AANLkTi=WaLRG=5rjPfyPojEuU3w83SfQSFBT+JKnVqKi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64972 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1AaBXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 20:23:03 -0500
Received: by qyj19 with SMTP id 19so2855115qyj.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 17:23:01 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following patch updates ext4 routines to specifiy journal not to fail
the transaction allocation with ENOMEM and retry till it succeeds.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/extents.c |    6 +++---
 fs/ext4/ialloc.c  |    2 +-
 fs/ext4/inode.c   |   17 +++++++++--------
 fs/ext4/super.c   |    9 +++++----
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 63a7581..4ebc6ac 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2333,7 +2333,7 @@ static int ext4_ext_remove_space(struct inode
*inode, ext4_lblk_t start)
 	ext_debug("truncate since %u\n", start);

 	/* probably first extent we're gonna free will be last in block */
-	handle = ext4_journal_start(inode, depth + 1);
+	handle = ext4_journal_start(inode, depth + 1, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -3544,7 +3544,7 @@ void ext4_ext_truncate(struct inode *inode)
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
-	handle = ext4_journal_start(inode, err);
+	handle = ext4_journal_start(inode, err, false);
 	if (IS_ERR(handle))
 		return;

@@ -3752,7 +3752,7 @@ int ext4_convert_unwritten_extents(struct inode
*inode, loff_t offset,
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk += ret;
 		map.m_len = (max_blocks -= ret);
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start(inode, credits, false);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index eb9097a..4499dcd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1257,7 +1257,7 @@ extern int ext4_init_inode_table(struct
super_block *sb, ext4_group_t group,
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
 		goto out;

-	handle = ext4_journal_start_sb(sb, 1);
+	handle = ext4_journal_start_sb(sb, 1, false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..5f7b082 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -129,7 +129,7 @@ static handle_t *start_transaction(struct inode *inode)
 {
 	handle_t *result;

-	result = ext4_journal_start(inode, blocks_for_truncate(inode));
+	result = ext4_journal_start(inode, blocks_for_truncate(inode), false);
 	if (!IS_ERR(result))
 		return result;

@@ -204,7 +204,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto no_delete;

-	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3);
+	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3, false);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
@@ -1398,7 +1398,7 @@ static int _ext4_get_block(struct inode *inode,
sector_t iblock,
 		if (map.m_len > DIO_MAX_BLOCKS)
 			map.m_len = DIO_MAX_BLOCKS;
 		dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
-		handle = ext4_journal_start(inode, dio_credits);
+		handle = ext4_journal_start(inode, dio_credits, false);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			return ret;
@@ -2653,7 +2653,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	 * references to buffers so we are safe */
 	unlock_page(page);

-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode),
+				    false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3049,7 +3050,7 @@ retry:
 		needed_blocks = ext4_da_writepages_trans_blocks(inode);

 		/* start a new transaction*/
-		handle = ext4_journal_start(inode, needed_blocks);
+		handle = ext4_journal_start(inode, needed_blocks, false);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
@@ -5385,7 +5386,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 							    attr->ia_size);
 			if (error) {
 				/* Do as much error cleanup as possible */
-				handle = ext4_journal_start(inode, 3);
+				handle = ext4_journal_start(inode, 3, false);
 				if (IS_ERR(handle)) {
 					ext4_orphan_del(NULL, inode);
 					goto err_out;
@@ -5738,7 +5739,7 @@ void ext4_dirty_inode(struct inode *inode)
 {
 	handle_t *handle;

-	handle = ext4_journal_start(inode, 2);
+	handle = ext4_journal_start(inode, 2, false);
 	if (IS_ERR(handle))
 		goto out;

@@ -5822,7 +5823,7 @@ int ext4_change_inode_journal_flag(struct inode
*inode, int val)

 	/* Finally we can mark the inode as dirty. */

-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3f1d629..eacfea7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4471,7 +4471,8 @@ static int ext4_write_dquot(struct dquot *dquot)

 	inode = dquot_to_inode(dquot);
 	handle = ext4_journal_start(inode,
-				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb),
+				    false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit(dquot);
@@ -4487,7 +4488,7 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	handle_t *handle;

 	handle = ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb), false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_acquire(dquot);
@@ -4503,7 +4504,7 @@ static int ext4_release_dquot(struct dquot *dquot)
 	handle_t *handle;

 	handle = ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb), false);
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
@@ -4534,7 +4535,7 @@ static int ext4_write_info(struct super_block
*sb, int type)
 	handle_t *handle;

 	/* Data block + inode block */
-	handle = ext4_journal_start(sb->s_root->d_inode, 2);
+	handle = ext4_journal_start(sb->s_root->d_inode, 2, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
-- 
1.6.0.4


-- 
Thanks -
Manish
