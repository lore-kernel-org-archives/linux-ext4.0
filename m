From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/12] ocfs2: Convert to private i_dquot
	field
Date: Tue, 21 Oct 2014 16:38:33 +0200
Message-ID: <1413902316-17997-10-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de,
	Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.h |  4 ++++
 fs/ocfs2/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a9b76de46047..1bb2e27eaad7 100644
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
index 93c85bc745e1..9a97986d54f5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -143,6 +143,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
+static struct dquot **ocfs2_get_dquots(struct inode *inode)
+{
+	return OCFS2_I(inode)->i_dquot;
+}
+
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
@@ -155,6 +160,7 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+	.get_dquots	= ocfs2_get_dquots,
 };
 
 enum {
@@ -563,6 +569,9 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 
 	oi->i_sync_tid = 0;
 	oi->i_datasync_tid = 0;
+#ifdef CONFIG_QUOTA
+	memset(&oi->i_dquot, 0, sizeof(oi->i_dquot));
+#endif
 
 	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
 	return &oi->vfs_inode;
@@ -2073,6 +2082,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_export_op = &ocfs2_export_ops;
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
-- 
1.8.1.4


------------------------------------------------------------------------------
Comprehensive Server Monitoring with Site24x7.
Monitor 10 servers for $9/Month.
Get alerted through email, SMS, voice calls or mobile push notifications.
Take corrective actions from your mobile device.
http://p.sf.net/sfu/Zoho
