From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 65/74] fuse2fs: handle 64-bit dates correctly
Date: Tue, 10 Dec 2013 17:25:32 -0800
Message-ID: <20131211012532.30655.40654.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43919 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3LKBZi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:25:38 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix fuse2fs' interpretation of 64-bit date quantities to match the
kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/fuse2fs.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 105c54f..3b5e5e7 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -289,15 +289,24 @@ static int __translate_error(ext2_filsys fs, errcode_t err, ext2_ino_t ino,
 
 static inline __u32 ext4_encode_extra_time(const struct timespec *time)
 {
-	return (sizeof(time->tv_sec) > 4 ?
-		(time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
-	       ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK);
+	__u32 extra = sizeof(time->tv_sec) > 4 ?
+			((time->tv_sec - (__s32)time->tv_sec) >> 32) &
+			EXT4_EPOCH_MASK : 0;
+	return extra | (time->tv_nsec << EXT4_EPOCH_BITS);
 }
 
 static inline void ext4_decode_extra_time(struct timespec *time, __u32 extra)
 {
-	if (sizeof(time->tv_sec) > 4)
-		time->tv_sec |= (__u64)((extra) & EXT4_EPOCH_MASK) << 32;
+	if (sizeof(time->tv_sec) > 4 && (extra & EXT4_EPOCH_MASK)) {
+		__u64 extra_bits = extra & EXT4_EPOCH_MASK;
+		/*
+		 * Prior to kernel 3.14?, we had a broken decode function,
+		 * wherein we effectively did this:
+		 * if (extra_bits == 3)
+		 *     extra_bits = 0;
+		 */
+		time->tv_sec += extra_bits << 32;
+	}
 	time->tv_nsec = ((extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
 }
 
@@ -323,7 +332,7 @@ do {									       \
 	(timespec)->tv_sec = (signed)((raw_inode)->xtime);		       \
 	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
 		ext4_decode_extra_time((timespec),			       \
-				       raw_inode->xtime ## _extra);	       \
+				       (raw_inode)->xtime ## _extra);	       \
 	else								       \
 		(timespec)->tv_nsec = 0;				       \
 } while (0)
@@ -614,6 +623,7 @@ static int stat_inode(ext2_filsys fs, ext2_ino_t ino, struct stat *statbuf)
 	dev_t fakedev = 0;
 	errcode_t err;
 	int ret = 0;
+	struct timespec tv;
 
 	memset(&inode, 0, sizeof(inode));
 	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
@@ -631,9 +641,12 @@ static int stat_inode(ext2_filsys fs, ext2_ino_t ino, struct stat *statbuf)
 	statbuf->st_size = inode.i_size;
 	statbuf->st_blksize = fs->blocksize;
 	statbuf->st_blocks = inode.i_blocks;
-	statbuf->st_atime = inode.i_atime;
-	statbuf->st_mtime = inode.i_mtime;
-	statbuf->st_ctime = inode.i_ctime;
+	EXT4_INODE_GET_XTIME(i_atime, &tv, &inode);
+	statbuf->st_atime = tv.tv_sec;
+	EXT4_INODE_GET_XTIME(i_mtime, &tv, &inode);
+	statbuf->st_mtime = tv.tv_sec;
+	EXT4_INODE_GET_XTIME(i_ctime, &tv, &inode);
+	statbuf->st_ctime = tv.tv_sec;
 	if (LINUX_S_ISCHR(inode.i_mode) ||
 	    LINUX_S_ISBLK(inode.i_mode)) {
 		if (inode.i_block[0])

