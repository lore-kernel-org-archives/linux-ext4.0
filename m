From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/3 v3] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu,  5 May 2011 16:16:56 -0400
Message-ID: <1304626619-1588-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	viro@ZenIV.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1EEURD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 16:17:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
using fiemap in things like cp cause more problems than it solves, so lets try
and give userspace an interface that doesn't suck.  So we have

-SEEK_HOLE: move the file position to the start of the next hole greater than or
equal to the start of the suplied offset.  This is how solaris defines it, so
thats how it will work for us.  The only trick is preallocated space.  Some
filesystems will be able to safely differentiate between prealloced space and
soon to be converted prealloced space, so preallocated space could easily be
considered a hole.  At the same time some file systems will not be able to make
this differentiation and so for safety will not treat preallocated space as a
hole.

-SEEK_DATA: this is obviously a little more self-explanatory.  Again the only
ambiguity comes in with preallocated extents.  If you have an fs that can't
reliably tell that the preallocated extent is in the process of turning into a
real extent, it is correct for SEEK_DATA to park you at a preallocated extent.

In the generic case we will just assume the entire file is data and there is a
virtual hole at i_size, so SEEK_DATA will return -ENXIO unless you provide an
offset of 0 and the file size is larger than 0, and SEEK_HOLE will put you at
i_size unless pos is larger or equal to i_size.

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
v2->v3:
-Fixed i_mutex unlock screw up
-Just use inode->i_size
-Make the comments clear that we mean the next hole
 fs/read_write.c    |   18 ++++++++++++++++++
 include/linux/fs.h |    4 +++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5520f8a..af9cc51 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -64,6 +64,24 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 			return file->f_pos;
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so data only
+		 * starts at position 0 provided the file has an i_size,
+		 * otherwise it's an empty file and will always be ENXIO.
+		 */
+		if (offset != 0 || inode->i_size == 0)
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
index dbd860a..185b278 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,7 +31,9 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-#define SEEK_MAX	SEEK_END
+#define SEEK_HOLE	3	/* seek to the next hole */
+#define SEEK_DATA	4	/* seek to the next data */
+#define SEEK_MAX	SEEK_DATA
 
 struct fstrim_range {
 	__u64 start;
-- 
1.7.2.3

