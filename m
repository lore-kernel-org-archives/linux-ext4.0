From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] libext2fs: refactor Direct I/O alignment requirement calculations
Date: Mon,  7 May 2012 14:56:22 -0400
Message-ID: <1336416985-24605-3-git-send-email-tytso@mit.edu>
References: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38762 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
In-Reply-To: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a new function, ext2fs_get_dio_alignment(), which returns the
alignment requirements for direct I/O.  This way we can factor out the
code from MMP and the Unix I/O manager.  The two modules weren't
consistently calculating the alignment factors, and in particular MMP
would sometimes use a larger alignment factor than was strictly
necessary.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h      |    1 +
 lib/ext2fs/getsectsize.c |   26 ++++++++++++++++++++++++++
 lib/ext2fs/mmp.c         |   37 +++++++++----------------------------
 lib/ext2fs/unix_io.c     |   22 ++++++++--------------
 4 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index fda6ade..9a0e736 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1213,6 +1213,7 @@ extern errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
 					blk64_t *retblocks);
 
 /* getsectsize.c */
+extern int ext2fs_get_dio_alignment(int fd);
 errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
 errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize);
 
diff --git a/lib/ext2fs/getsectsize.c b/lib/ext2fs/getsectsize.c
index 30faecc..9c3f4a2 100644
--- a/lib/ext2fs/getsectsize.c
+++ b/lib/ext2fs/getsectsize.c
@@ -62,6 +62,32 @@ errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize)
 }
 
 /*
+ * Return desired alignment for direct I/O
+ */
+int ext2fs_get_dio_alignment(int fd)
+{
+	int align = 0;
+
+#ifdef BLKSSZGET
+	if (ioctl(fd, BLKSSZGET, &align) < 0)
+		align = 0;
+#endif
+
+#ifdef _SC_PAGESIZE
+	if (align <= 0)
+		align = sysconf(_SC_PAGESIZE);
+#endif
+#ifdef HAVE_GETPAGESIZE
+	if (align <= 0)
+		align = getpagesize();
+#endif
+	if (align <= 0)
+		align = 4096;
+
+	return align;
+}
+
+/*
  * Returns the physical sector size of a device
  */
 errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize)
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 49a11da..bb3772d 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -27,20 +27,6 @@
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
 
-static int mmp_pagesize(void)
-{
-#ifdef _SC_PAGESIZE
-	int sysval = sysconf(_SC_PAGESIZE);
-	if (sysval > 0)
-		return sysval;
-#endif /* _SC_PAGESIZE */
-#ifdef HAVE_GETPAGESIZE
-	return getpagesize();
-#else
-	return 4096;
-#endif
-}
-
 #ifndef O_DIRECT
 #define O_DIRECT 0
 #endif
@@ -54,20 +40,6 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	    (mmp_blk >= fs->super->s_blocks_count))
 		return EXT2_ET_MMP_BAD_BLOCK;
 
-	if (fs->mmp_cmp == NULL) {
-		/* O_DIRECT in linux 2.4: page aligned
-		 * O_DIRECT in linux 2.6: sector aligned
-		 * A filesystem cannot be created with blocksize < sector size,
-		 * or with blocksize > page_size. */
-		int bufsize = fs->blocksize;
-
-		if (bufsize < mmp_pagesize())
-			bufsize = mmp_pagesize();
-		retval = ext2fs_get_memalign(bufsize, bufsize, &fs->mmp_cmp);
-		if (retval)
-			return retval;
-	}
-
 	/* ext2fs_open() reserves fd0,1,2 to avoid stdio collision, so checking
 	 * mmp_fd <= 0 is OK to validate that the fd is valid.  This opens its
 	 * own fd to read the MMP block to ensure that it is using O_DIRECT,
@@ -81,6 +53,15 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 		}
 	}
 
+	if (fs->mmp_cmp == NULL) {
+		int align = ext2fs_get_dio_alignment(fs->mmp_fd);
+
+		retval = ext2fs_get_memalign(fs->blocksize, align,
+					     &fs->mmp_cmp);
+		if (retval)
+			return retval;
+	}
+
 	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
 	    mmp_blk * fs->blocksize) {
 		retval = EXT2_ET_LLSEEK_FAILED;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 3269392..8319eba 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -58,10 +58,6 @@
 #define BLKROGET   _IO(0x12, 94) /* Get read-only status (0 = read_write).  */
 #endif
 
-#if defined(__linux__) && defined(_IO) && !defined(BLKSSZGET)
-#define BLKSSZGET  _IO(0x12,104)/* get block device sector size */
-#endif
-
 #undef ALIGN_DEBUG
 
 #include "ext2_fs.h"
@@ -485,11 +481,15 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	if (flags & IO_FLAG_EXCLUSIVE)
 		open_flags |= O_EXCL;
 #if defined(O_DIRECT)
-	if (flags & IO_FLAG_DIRECT_IO)
+	if (flags & IO_FLAG_DIRECT_IO) {
 		open_flags |= O_DIRECT;
+		io->align = ext2fs_get_dio_alignment(data->dev);
+	}
 #elif defined(F_NOCACHE)
-	if (flags & IO_FLAG_DIRECT_IO)
+	if (flags & IO_FLAG_DIRECT_IO) {
 		f_nocache = F_NOCACHE;
+		io->align = 4096;
+	}
 #endif
 	data->flags = flags;
 
@@ -519,13 +519,6 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 			io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
 	}
 
-#ifdef BLKSSZGET
-	if (flags & IO_FLAG_DIRECT_IO) {
-		if (ioctl(data->dev, BLKSSZGET, &io->align) != 0)
-			io->align = io->block_size;
-	}
-#endif
