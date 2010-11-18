From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/6] Ocfs2: handle hole punching via fallocate properly
Date: Wed, 17 Nov 2010 20:46:17 -0500
Message-ID: <1290044780-2902-4-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-dev
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ocfs2/file.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..ad23a18 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
+	int cmd = OCFS2_IOC_RESVSP64;
 
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
@@ -2002,12 +2003,15 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		change_size = 0;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = OCFS2_IOC_UNRESVSP64;
+
 	sr.l_whence = 0;
 	sr.l_start = (s64)offset;
 	sr.l_len = (s64)len;
 
-	return __ocfs2_change_file_space(NULL, inode, offset,
-					 OCFS2_IOC_RESVSP64, &sr, change_size);
+	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
+					 change_size);
 }
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
-- 
1.6.6.1
