From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/11] quota: Stop setting IMMUTABLE and NOATIME flags on quota files
Date: Wed, 12 Apr 2017 09:26:05 +0200
Message-ID: <20170412072611.29017-6-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we set IMMUTABLE and NOATIME flags on quota files to stop
userspace from messing with them. Now that all filesystems set these
flags in their quota_on handlers, we can stop setting the flags in
generic quota code. This will allow filesystems to stop copying i_flags
to their on-disk flags on various occasions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 74b489e3714d..7e94cb0ecdde 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2188,8 +2188,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 		/* This can happen when suspending quotas on remount-ro... */
 		if (toputinode[cnt] && !sb_has_quota_loaded(sb, cnt)) {
 			inode_lock(toputinode[cnt]);
-			toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
-				  S_NOATIME | S_NOQUOTA);
+			toputinode[cnt]->i_flags &= ~S_NOQUOTA;
 			truncate_inode_pages(&toputinode[cnt]->i_data, 0);
 			inode_unlock(toputinode[cnt]);
 			mark_inode_dirty_sync(toputinode[cnt]);
@@ -2237,7 +2236,6 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int error;
-	int oldflags = -1;
 
 	if (!fmt)
 		return -ESRCH;
@@ -2285,9 +2283,7 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		 * possible) Also nobody should write to the file - we use
 		 * special IO operations which ignore the immutable bit. */
 		inode_lock(inode);
-		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE |
-					     S_NOQUOTA);
-		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
+		inode->i_flags |= S_NOQUOTA;
 		inode_unlock(inode);
 		/*
 		 * When S_NOQUOTA is set, remove dquot references as no more
@@ -2329,14 +2325,9 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	dqopt->files[type] = NULL;
 	iput(inode);
 out_file_flags:
-	if (oldflags != -1) {
-		inode_lock(inode);
-		/* Set the flags back (in the case of accidental quotaon()
-		 * on a wrong file we don't want to mess up the flags) */
-		inode->i_flags &= ~(S_NOATIME | S_NOQUOTA | S_IMMUTABLE);
-		inode->i_flags |= oldflags;
-		inode_unlock(inode);
-	}
+	inode_lock(inode);
+	inode->i_flags &= ~S_NOQUOTA;
+	inode_unlock(inode);
 out_fmt:
 	put_quota_format(fmt);
 
-- 
2.12.0
