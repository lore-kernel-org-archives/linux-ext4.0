From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/12] reiserfs: Convert to private i_dquot field
Date: Tue, 21 Oct 2014 16:38:34 +0200
Message-ID: <1413902316-17997-11-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, hch@lst.de, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098AbaJUOiz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2014 10:38:55 -0400
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CC: reiserfs-devel@vger.kernel.org
CC: Jeff Mahoney <jeffm@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/reiserfs.h |  4 ++++
 fs/reiserfs/super.c    | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 1894d96ccb7c..bb79cddf0a1f 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -97,6 +97,10 @@ struct reiserfs_inode_info {
 #ifdef CONFIG_REISERFS_FS_XATTR
 	struct rw_semaphore i_xattr_sem;
 #endif
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index f1376c92cf74..f9bbac270cb5 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -594,6 +594,10 @@ static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	atomic_set(&ei->openers, 0);
 	mutex_init(&ei->tailpack);
+#ifdef CONFIG_QUOTA
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -750,6 +754,11 @@ static ssize_t reiserfs_quota_write(struct super_block *, int, const char *,
 				    size_t, loff_t);
 static ssize_t reiserfs_quota_read(struct super_block *, int, char *, size_t,
 				   loff_t);
+
+static struct dquot **reiserfs_get_dquots(struct inode *inode)
+{
+	return REISERFS_I(inode)->i_dquot;
+}
 #endif
 
 static const struct super_operations reiserfs_sops = {
@@ -768,6 +777,7 @@ static const struct super_operations reiserfs_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read = reiserfs_quota_read,
 	.quota_write = reiserfs_quota_write,
+	.get_dquots = reiserfs_get_dquots,
 #endif
 };
 
@@ -1633,6 +1643,7 @@ static int read_super_block(struct super_block *s, int offset)
 #ifdef CONFIG_QUOTA
 	s->s_qcop = &reiserfs_qctl_operations;
 	s->dq_op = &reiserfs_quota_operations;
+	sb_dqopt(s)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
 	/*
-- 
1.8.1.4

