From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/12] gfs2: Set allowed quota types
Date: Tue,  4 Nov 2014 12:19:44 +0100
Message-ID: <1415099993-18034-4-git-send-email-jack@suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, hch@lst.de,
	Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
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

We support user and group quotas. Tell vfs about it.

Acked-by: Steven Whitehouse <swhiteho@redhat.com>
CC: cluster-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/ops_fstype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index d3eae244076e..455bac77feb5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1082,6 +1082,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	sb->s_export_op = &gfs2_export_ops;
 	sb->s_xattr = gfs2_xattr_handlers;
 	sb->s_qcop = &gfs2_quotactl_ops;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
 	sb->s_time_gran = 1;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
