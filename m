From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/12] xfs: Set allowed quota types
Date: Fri, 10 Oct 2014 16:55:01 +0200
Message-ID: <1412952910-7142-4-git-send-email-jack@suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1412952910-7142-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We support user, group, and project quotas. Tell VFS about it.

CC: xfs@oss.sgi.com
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b194652033cd..2da4c6512e4d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA
 	sb->s_qcop = &xfs_quotactl_operations;
+	sb->s_dquot.allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP |
+				    QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
 
-- 
1.8.1.4

