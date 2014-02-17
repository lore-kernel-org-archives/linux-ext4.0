From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/6] fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Mon, 17 Feb 2014 16:08:21 +0100
Message-ID: <1392649703-10772-5-git-send-email-lczerner@redhat.com>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaBQPIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Feb 2014 10:08:37 -0500
In-Reply-To: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
functionality as xfs ioctl XFS_IOC_ZERO_RANGE.

It can be used to convert a range of file to zeros preferably without
issuing data IO. Blocks should be preallocated for the regions that span
holes in the file, and the entire range is preferable converted to
unwritten extents - even though file system may choose to zero out the
extent or do whatever which will result in reading zeros from the range
while the range remains allocated for the file.

This can be also used to preallocate blocks past EOF in the same way as
with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
size to remain the same.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/open.c                   | 7 ++++++-
 include/uapi/linux/falloc.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 4b3e1ed..6dc46c1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -231,7 +231,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_ZERO_RANGE))
+		return -EOPNOTSUPP;
+
+	/* Punch hole and zero range are mutually exclusive */
+	if (mode & FALLOC_FL_PUNCH_HOLE && mode & FALLOC_FL_ZERO_RANGE)
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..49951ea 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -4,6 +4,7 @@
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
+#define FALLOC_FL_ZERO_RANGE	0x08 /* zero range */
 
 
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.8.3.1

