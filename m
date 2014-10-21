From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/12] gfs2: Set allowed quota types
Date: Tue, 21 Oct 2014 16:38:27 +0200
Message-ID: <1413902316-17997-4-git-send-email-jack@suse.cz>
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
Received: from cantor2.suse.de ([195.135.220.15]:51261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbaJUOix (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2014 10:38:53 -0400
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We support user and group quotas. Tell vfs about it.

Acked-by: Steven Whitehouse <swhiteho@redhat.com>
CC: cluster-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/ops_fstype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index d3eae244076e..23854d24eb50 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1083,6 +1083,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	sb->s_xattr = gfs2_xattr_handlers;
 	sb->s_qcop = &gfs2_quotactl_ops;
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_time_gran = 1;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
-- 
1.8.1.4

