From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/12] reiserfs: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:32 +0200
Message-ID: <1412191894-9113-11-git-send-email-jack@suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com
To: linux-fsdevel@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1412191894-9113-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

CC: reiserfs-devel@vger.kernel.org
CC: Jeff Mahoney <jeffm@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/reiserfs.h |  4 ++++
 fs/reiserfs/super.c    | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 735c2c2b4536..197e59cbeb1c 100644
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
index d46e88a33b02..c39227ded8f2 100644
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
 
@@ -771,6 +775,13 @@ static const struct super_operations reiserfs_sops = {
 #endif
 };
 
+static const int reiserfs_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = (int)offsetof(struct reiserfs_inode_info, i_dquot) -
+		      (int)offsetof(struct reiserfs_inode_info, vfs_inode),
+#endif
+};
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 
@@ -1633,7 +1644,9 @@ static int read_super_block(struct super_block *s, int offset)
 #ifdef CONFIG_QUOTA
 	s->s_qcop = &reiserfs_qctl_operations;
 	s->dq_op = &reiserfs_quota_operations;
+	sb_dqopt(s)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 #endif
+	sb_init_inode_fields(s, reiserfs_inode_fields);
 
 	/*
 	 * new format is limited by the 32 bit wide i_blocks field, want to
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
