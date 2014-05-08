From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 1/10] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 08 May 2014 19:24:42 +0900
Message-ID: <003701cf6aa7$ba00c8d0$2e025a70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com
To: 'Dave Chinner' <david@fromorbit.com>, 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-language: ko
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

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will insert a range
of a file after shifting extents to right as given length.
and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |  8 +++++++-
 include/uapi/linux/falloc.h | 17 +++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 36662d0..74ed498 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -232,7 +232,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole and zero range are mutually exclusive */
@@ -250,6 +251,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
 		return -EINVAL;
 
+	/* Insert range should only be used exclusively. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) &&
+	    (mode & ~FALLOC_FL_INSERT_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index d1197ae..f4d12eb 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,21 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to allocate disk space within the file size
+ * without overwriting any existing data. The contents of the file beyond offset
+ * are shifted towards right by len bytes to create space for inserting
+ * new disk blocks and in this space new zeroed out disk blocks are inserted.
+ * As such, this operation will increase the size of the file by len bytes.
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ *
+ * Attempting to allocate new blocks using this flag at OR beyond the end of
+ * the file is considered an illegal operation - just use ftruncate(2) or
+ * fallocate(2) with mode 0 for such type of operations.
+ */
+#define FALLOC_FL_INSERT_RANGE		0x20
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
