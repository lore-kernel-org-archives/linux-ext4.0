From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/5 v2] e2fsprogs: Use punch hole as "discard" on regular files
Date: Fri, 12 Aug 2011 18:42:57 +0200
Message-ID: <1313167380-3283-2-git-send-email-lczerner@redhat.com>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, adilger@dilger.ca,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1HLQnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 12:43:15 -0400
In-Reply-To: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsprogs tools (mke2fs, e2fsck) is run on regular file instead of
on block device, we can use punch hole instead of regular discard
command which would not work on regular file anyway. This gives us
several advantages. First of all when e2fsck is run with '-E discard'
parameter it will punch out all ununsed space from the image, hence
trimming down the file system image. And secondly, when creating an
file system on regular file (with '-E discard' which is default), we
can use punch hole to clear the file content, hence we can skip inode
table initialization, because reads from sparse area returns zeros. This
will result in faster file system creation (without the need to specify
lazy_itable_init) and smaller images.

This commit also fixes some tests that would fail due to mke2fs showing
discard progress, hence the output would differ.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: fix tests for case there is no punch hole support
    add ifdefs to cover no punch hole or fallocate support

 lib/ext2fs/ext2_io.h        |    1 +
 lib/ext2fs/unix_io.c        |   53 ++++++++++++++++++++++++++++++++++++------
 misc/mke2fs.c               |   10 ++++++-
 tests/f_resize_inode/script |    1 +
 tests/m_bigjournal/script   |    2 +-
 tests/run_mke2fs            |    2 +-
 6 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index e71ada9..bcc2f87 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -30,6 +30,7 @@ typedef struct struct_io_stats *io_stats;
 
 #define CHANNEL_FLAGS_WRITETHROUGH	0x01
 #define CHANNEL_FLAGS_DISCARD_ZEROES	0x02
+#define CHANNEL_FLAGS_BLOCK_DEVICE	0x04
 
 #define io_channel_discard_zeroes_data(i) (i->flags & CHANNEL_FLAGS_DISCARD_ZEROES)
 
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 21a273d..ecddfa6 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -49,6 +49,9 @@
 #if HAVE_SYS_RESOURCE_H
 #include <sys/resource.h>
 #endif
+#if HAVE_LINUX_FALLOC_H
+#include <linux/falloc.h>
+#endif
 
 #if defined(__linux__) && defined(_IO) && !defined(BLKROGET)
 #define BLKROGET   _IO(0x12, 94) /* Get read-only status (0 = read_write).  */
@@ -488,6 +491,20 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 		goto cleanup;
 	}
 
+	/*
+	 * If the device is really a block device, then set the
+	 * appropriate flag, otherwise we can set DISCARD_ZEROES flag
+	 * because we are going to use punch hole instead of discard
+	 * and if it succeed, subsequent read from sparse area returns
+	 * zero.
+	 */
+	if (ext2fs_stat(io->name, &st) == 0) {
+		if (S_ISBLK(st.st_mode))
+			io->flags |= CHANNEL_FLAGS_BLOCK_DEVICE;
+		else
+			io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
+	}
+
 #ifdef BLKSSZGET
 	if (flags & IO_FLAG_DIRECT_IO) {
 		if (ioctl(data->dev, BLKSSZGET, &data->align) != 0)
@@ -853,13 +870,12 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
 }
 
 #if defined(__linux__) && !defined(BLKDISCARD)
-#define BLKDISCARD	_IO(0x12,119)
+#define BLKDISCARD		_IO(0x12,119)
 #endif
 
 static errcode_t unix_discard(io_channel channel, unsigned long long block,
 			      unsigned long long count)
 {
-#ifdef BLKDISCARD
 	struct unix_private_data *data;
 	__uint64_t	range[2];
 	int		ret;
@@ -868,14 +884,35 @@ static errcode_t unix_discard(io_channel channel, unsigned long long block,
 	data = (struct unix_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
-	range[0] = (__uint64_t)(block) * channel->block_size;
-	range[1] = (__uint64_t)(count) * channel->block_size;
+	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
+#ifdef BLKDISCARD
+		range[0] = (__uint64_t)(block) * channel->block_size;
+		range[1] = (__uint64_t)(count) * channel->block_size;
 
-	ret = ioctl(data->dev, BLKDISCARD, &range);
-	if (ret < 0)
+		ret = ioctl(data->dev, BLKDISCARD, &range);
+#else
+		goto unimplemented;
+#endif
+	} else {
+#ifdef FALLOC_FL_PUNCH_HOLE
+		/*
+		 * If we are not on block device, try to use punch hole
+		 * to reclaim free space.
+		 */
+		ret = fallocate(data->dev,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				(off_t)(block) * channel->block_size,
+				(off_t)(count) * channel->block_size);
+#else
+		goto unimplemented;
+#endif
+	}
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP)
+			goto unimplemented;
 		return errno;
+	}
 	return 0;
-#else
+unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;
-#endif
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e062bda..9685e2d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2073,12 +2073,18 @@ static int mke2fs_discard_device(ext2_filsys fs)
 	struct ext2fs_numeric_progress_struct progress;
 	blk64_t blocks = ext2fs_blocks_count(fs->super);
 	blk64_t count = DISCARD_STEP_MB;
-	blk64_t cur = 0;
+	blk64_t cur;
 	int retval = 0;
 
-	retval = io_channel_discard(fs->io, 0, 0);
+	/*
+	 * Let's try if discard really works on the device, so
+	 * we do not print numeric progress resulting in failure
+	 * afterwards.
+	 */
+	retval = io_channel_discard(fs->io, 0, fs->blocksize);
 	if (retval)
 		return retval;
+	cur = fs->blocksize;
 
 	count *= (1024 * 1024);
 	count /= fs->blocksize;
diff --git a/tests/f_resize_inode/script b/tests/f_resize_inode/script
index 327f41b..1665e1a 100644
--- a/tests/f_resize_inode/script
+++ b/tests/f_resize_inode/script
@@ -15,6 +15,7 @@ dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 echo mke2fs -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 16384 > $OUT
 $MKE2FS -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 \
 	| sed -e '1d' | grep -v "automatically checked" | 
+	grep -v 'Discarding device blocks' |
 	grep -v "whichever comes first" >> $OUT 
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/m_bigjournal/script b/tests/m_bigjournal/script
index 29e0a24..1e21fdf 100644
--- a/tests/m_bigjournal/script
+++ b/tests/m_bigjournal/script
@@ -1,4 +1,4 @@
 DESCRIPTION="journal over 4GB in size"
 FS_SIZE=11000000
-MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init"
+MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init,nodiscard"
 . $cmd_dir/run_mke2fs
diff --git a/tests/run_mke2fs b/tests/run_mke2fs
index ab807a5..4abea53 100644
--- a/tests/run_mke2fs
+++ b/tests/run_mke2fs
@@ -9,7 +9,7 @@ MKE2FS_SKIP_PROGRESS=true
 MKE2FS_SKIP_CHECK_MSG=true
 export MKE2FS_SKIP_PROGRESS MKE2FS_SKIP_CHECK_MSG
 > $TMPFILE
-PREP_CMD='$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 | sed -e 1d | tr -d \\015 > $OUT1 ; $DEBUGFS -R features $TMPFILE 2>&1 | sed -e 1d | tr -d \\015 >> $OUT1 ; echo " " >> $OUT1'
+PREP_CMD='$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 | sed -e 1d | grep -v "Discarding device blocks" | tr -d \\015 > $OUT1 ; $DEBUGFS -R features $TMPFILE 2>&1 | sed -e 1d | tr -d \\015 >> $OUT1 ; echo " " >> $OUT1'
 AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs | tr -d \\015 >> $OUT1'
 . $cmd_dir/run_e2fsck
 unset FS_SIZE MKE2FS_OPTS MKE2FS_SKIP_PROGRESS
-- 
1.7.4.4

