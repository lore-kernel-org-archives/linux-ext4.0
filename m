From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/11] ext3: Remove unnecessary quota functions
Date: Fri, 16 Jan 2009 19:08:17 +0100
Message-ID: <1232129299-22018-10-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
 <1232129299-22018-4-git-send-email-jack@suse.cz>
 <1232129299-22018-5-git-send-email-jack@suse.cz>
 <1232129299-22018-6-git-send-email-jack@suse.cz>
 <1232129299-22018-7-git-send-email-jack@suse.cz>
 <1232129299-22018-8-git-send-email-jack@suse.cz>
 <1232129299-22018-9-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1232129299-22018-9-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext3_dquot_initialize() and ext3_dquot_drop() is no longer
needed because of modified quota locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   44 ++------------------------------------------
 1 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index b70d90e..ec410a9 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -707,8 +707,6 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 #define QTYPE2MOPT(on, t) ((t)==USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
 
-static int ext3_dquot_initialize(struct inode *inode, int type);
-static int ext3_dquot_drop(struct inode *inode);
 static int ext3_write_dquot(struct dquot *dquot);
 static int ext3_acquire_dquot(struct dquot *dquot);
 static int ext3_release_dquot(struct dquot *dquot);
@@ -723,8 +721,8 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
 static struct dquot_operations ext3_quota_operations = {
-	.initialize	= ext3_dquot_initialize,
-	.drop		= ext3_dquot_drop,
+	.initialize	= dquot_initialize,
+	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
@@ -2713,44 +2711,6 @@ static inline struct inode *dquot_to_inode(struct dquot *dquot)
 	return sb_dqopt(dquot->dq_sb)->files[dquot->dq_type];
 }
 
-static int ext3_dquot_initialize(struct inode *inode, int type)
-{
-	handle_t *handle;
-	int ret, err;
-
-	/* We may create quota structure so we need to reserve enough blocks */
-	handle = ext3_journal_start(inode, 2*EXT3_QUOTA_INIT_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
-	ret = dquot_initialize(inode, type);
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
-	return ret;
-}
-
-static int ext3_dquot_drop(struct inode *inode)
-{
-	handle_t *handle;
-	int ret, err;
-
-	/* We may delete quota structure so we need to reserve enough blocks */
-	handle = ext3_journal_start(inode, 2*EXT3_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle)) {
-		/*
-		 * We call dquot_drop() anyway to at least release references
-		 * to quota structures so that umount does not hang.
-		 */
-		dquot_drop(inode);
-		return PTR_ERR(handle);
-	}
-	ret = dquot_drop(inode);
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
-	return ret;
-}
-
 static int ext3_write_dquot(struct dquot *dquot)
 {
 	int ret, err;
-- 
1.6.0.2

