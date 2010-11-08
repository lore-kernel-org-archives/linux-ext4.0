From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 6/6] Gfs2: fail if we try to use hole punch
Date: Mon,  8 Nov 2010 15:32:07 -0500
Message-ID: <1289248327-16308-6-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1289248327-16308-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Gfs2 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/gfs2/ops_inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..93ecc9f 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1439,6 +1439,10 @@ static long gfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode & FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
 		 sdp->sd_sb.sb_bsize_shift;
 
-- 
1.6.6.1
