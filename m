From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/3] fs: add SEEK_HOLE and SEEK_DATA flags V4
Date: Mon, 23 May 2011 17:43:09 -0400
Message-ID: <1306186991-1905-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sunil.mushran@oracle.com, viro@ZenIV.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
using fiemap in things like cp cause more problems than it solves, so lets try
and give userspace an interface that doesn't suck.  We need to match solaris
here, and the definitions are

*o* If /whence/ is SEEK_HOLE, the offset of the start of the
next hole greater than or equal to the supplied offset
is returned. The definition of a hole is provided near
the end of the DESCRIPTION.

*o* If /whence/ is SEEK_DATA, the file pointer is set to the
start of the next non-hole file region greater than or
equal to the supplied offset.

So in the generic case the entire file is data and there is a virtual hole at
the end.  That means we will just return i_size for SEEK_HOLE and will return
the same offset for SEEK_DATA.  This is how Solaris does it so we have to do it
the same way.

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V3->V4:
-Fix the SEEK_HOLE/SEEK_DATA values to match solaris
-Fix the generic case to work the same way solaris works as best as possible

 fs/read_write.c    |   17 +++++++++++++++++
 include/linux/fs.h |    4 +++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5520f8a..9c3b453 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -64,6 +64,23 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 			return file->f_pos;
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so as long as
+		 * offset isn't at the end of the file then the offset is data.
+		 */
+		if (offset >= inode->i_size)
+			return -ENXIO;
+		break;
+	case SEEK_HOLE:
+		/*
+		 * There is a virtual hole at the end of the file, so as long as
+		 * offset isn't i_size or larger, return i_size.
+		 */
+		if (offset >= inode->i_size)
+			return -ENXIO;
+		offset = inode->i_size;
+		break;
 	}
 
 	if (offset < 0 && !unsigned_offsets(file))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cdf9495..fe1e250 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,7 +31,9 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-#define SEEK_MAX	SEEK_END
+#define SEEK_DATA	3	/* seek to the next data */
+#define SEEK_HOLE	4	/* seek to the next hole */
+#define SEEK_MAX	SEEK_HOLE
 
 struct fstrim_range {
 	__u64 start;
-- 
1.7.2.3
