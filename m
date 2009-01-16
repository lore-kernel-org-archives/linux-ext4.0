From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/11] reiserfs: Remove unnecessary quota functions
Date: Fri, 16 Jan 2009 19:08:19 +0100
Message-ID: <1232129299-22018-12-git-send-email-jack@suse.cz>
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
 <1232129299-22018-10-git-send-email-jack@suse.cz>
 <1232129299-22018-11-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48000 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762570AbZAPSIZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:25 -0500
In-Reply-To: <1232129299-22018-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

reiserfs_dquot_initialize() and reiserfs_dquot_drop() is no longer
needed because of modified quota locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   58 +-------------------------------------------------
 1 files changed, 2 insertions(+), 56 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index f3c820b..317c035 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -629,8 +629,6 @@ static const struct super_operations reiserfs_sops = {
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 
-static int reiserfs_dquot_initialize(struct inode *, int);
-static int reiserfs_dquot_drop(struct inode *);
 static int reiserfs_write_dquot(struct dquot *);
 static int reiserfs_acquire_dquot(struct dquot *);
 static int reiserfs_release_dquot(struct dquot *);
@@ -639,8 +637,8 @@ static int reiserfs_write_info(struct super_block *, int);
 static int reiserfs_quota_on(struct super_block *, int, int, char *, int);
 
 static struct dquot_operations reiserfs_quota_operations = {
-	.initialize = reiserfs_dquot_initialize,
-	.drop = reiserfs_dquot_drop,
+	.initialize = dquot_initialize,
+	.drop = dquot_drop,
 	.alloc_space = dquot_alloc_space,
 	.alloc_inode = dquot_alloc_inode,
 	.free_space = dquot_free_space,
@@ -1896,58 +1894,6 @@ static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 }
 
 #ifdef CONFIG_QUOTA
-static int reiserfs_dquot_initialize(struct inode *inode, int type)
-{
-	struct reiserfs_transaction_handle th;
-	int ret, err;
-
-	/* We may create quota structure so we need to reserve enough blocks */
-	reiserfs_write_lock(inode->i_sb);
-	ret =
-	    journal_begin(&th, inode->i_sb,
-			  2 * REISERFS_QUOTA_INIT_BLOCKS(inode->i_sb));
-	if (ret)
-		goto out;
-	ret = dquot_initialize(inode, type);
-	err =
-	    journal_end(&th, inode->i_sb,
-			2 * REISERFS_QUOTA_INIT_BLOCKS(inode->i_sb));
-	if (!ret && err)
-		ret = err;
-      out:
-	reiserfs_write_unlock(inode->i_sb);
-	return ret;
-}
-
-static int reiserfs_dquot_drop(struct inode *inode)
-{
-	struct reiserfs_transaction_handle th;
-	int ret, err;
-
-	/* We may delete quota structure so we need to reserve enough blocks */
-	reiserfs_write_lock(inode->i_sb);
-	ret =
-	    journal_begin(&th, inode->i_sb,
-			  2 * REISERFS_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (ret) {
-		/*
-		 * We call dquot_drop() anyway to at least release references
-		 * to quota structures so that umount does not hang.
-		 */
-		dquot_drop(inode);
-		goto out;
-	}
-	ret = dquot_drop(inode);
-	err =
-	    journal_end(&th, inode->i_sb,
-			2 * REISERFS_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (!ret && err)
-		ret = err;
-      out:
-	reiserfs_write_unlock(inode->i_sb);
-	return ret;
-}
