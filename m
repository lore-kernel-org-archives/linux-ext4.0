From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/12] ocfs2: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:31 +0200
Message-ID: <1412191894-9113-10-git-send-email-jack@suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1412191894-9113-1-git-send-email-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.h |  4 ++++
 fs/ocfs2/super.c | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a6c991c0fc98..aed65d3aff57 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -80,6 +80,10 @@ struct ocfs2_inode_info
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
 };
 
 /*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ddb662b32447..190dc8620ae0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -157,6 +157,13 @@ static const struct super_operations ocfs2_sops = {
 	.quota_write	= ocfs2_quota_write,
 };
 
+static const int ocfs2_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = offsetof(struct ocfs2_inode_info, i_dquot) -
+		      offsetof(struct ocfs2_inode_info, vfs_inode),
+#endif
+};
+
 enum {
 	Opt_barrier,
 	Opt_err_panic,
@@ -563,6 +570,9 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 
 	oi->i_sync_tid = 0;
 	oi->i_datasync_tid = 0;
+#ifdef CONFIG_QUOTA
+	memset(&oi->i_dquot, 0, sizeof(oi->i_dquot));
+#endif
 
 	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
 	return &oi->vfs_inode;
@@ -2069,7 +2079,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_export_op = &ocfs2_export_ops;
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
+	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 	sb->s_xattr = ocfs2_xattr_handlers;
+	sb_init_inode_fields(sb, ocfs2_inode_fields);
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
-- 
1.8.1.4

