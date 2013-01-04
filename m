From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 1/3] lib/ext2fs: Add ext2fs_symlink
Date: Fri,  4 Jan 2013 12:00:58 -0800
Message-ID: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com, Darren Hart <dvhart@infradead.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54065 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3ADUBW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 15:01:22 -0500
In-Reply-To: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Creating symlinks is a complex affair when accounting for slowlinks.

Create a new function, ext2fs_symlink(), modeled after ext2fs_mkdir().
Like ext2fs_mkdir(), ext2fs_symlink() takes on the task of allocating a
new inode and block (for slowlinks), setting up sane default values in
the inode, copying the target path to either the inode (for fastlinks)
or to the first block (for slowlinks), and accounting for the inode and
block stats.  Disallow link targets longer than blocksize as the Linux
kernel prevents this.

It does not attempt to expand the parent directory, instead returning
EXT2_ET_DIR_NO_SPACE and leaving it to the caller to expand just as
ext2fs_mkdir() does. Ideally, I think both of these functions should
make a single attempt to expand the directory.

Note the one remaining FIXME. Do I need to use ext2fs_bmap2() for the
slowlink without extents? If not, how is the 0 block associated with the
inode?

libext2fs.a impact (stripped):
Orig   | Patched | Delta
274752 | 276580  | 1828

V2 incorporates feedback from Ted and Darrick:
o Add error codes to the end of the table
o Remove redundant EXT2_FT_SYMLINK definition
o Time fields set by write_new_inode
o Use size=target_len for slow links as well
o Test for len < blocksize
o Replace file ops with manual block handling
o Keep line width under 80 characters

Signed-off-by: Darren Hart <dvhart@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>
---
 lib/ext2fs/Makefile.in    |   8 +++
 lib/ext2fs/ext2_err.et.in |   3 +
 lib/ext2fs/symlink.c      | 161 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 lib/ext2fs/symlink.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 1a51c51..dc7b0d1 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -80,6 +80,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	res_gdt.o \
 	rw_bitmaps.o \
 	swapfs.o \
+	symlink.o \
 	tdb.o \
 	undo_io.o \
 	unix_io.o \
@@ -155,6 +156,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/res_gdt.c \
 	$(srcdir)/rw_bitmaps.c \
 	$(srcdir)/swapfs.c \
+	$(srcdir)/symlink.c \
 	$(srcdir)/tdb.c \
 	$(srcdir)/test_io.c \
 	$(srcdir)/tst_badblocks.c \
@@ -893,6 +895,12 @@ swapfs.o: $(srcdir)/swapfs.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
+symlink.o: $(srcdir)/symlink.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
 tdb.o: $(srcdir)/tdb.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/tdb.h
 test_io.o: $(srcdir)/test_io.c $(top_builddir)/lib/config.h \
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index c99a167..d20c6b7 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -473,4 +473,7 @@ ec	EXT2_ET_UNKNOWN_CSUM,
 ec	EXT2_ET_MMP_CSUM_INVALID,
 	"MMP block checksum does not match MMP block"
 
+ec	EXT2_ET_FILE_EXISTS,
+	"Ext2 file already exists"
+
 	end
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
new file mode 100644
index 0000000..3e3a527
--- /dev/null
+++ b/lib/ext2fs/symlink.c
@@ -0,0 +1,161 @@
+/*
+ * symlink.c --- make a symlink in the filesystem, based on mkdir.c
+ *
+ * Copyright (c) 2012, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <fcntl.h>
+#include <time.h>
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+
+errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
+                         const char *name, char *target)
+{
+	ext2_extent_handle_t	handle;
+	errcode_t		retval;
+	struct ext2_inode	inode;
+	ext2_ino_t		scratch_ino;
+	blk64_t			blk;
+	int			fastlink;
+	int			target_len;
+	char			*block_buf = 0;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	/* The Linux kernel doesn't allow for links longer than a block */
+	target_len = strlen(target);
+	if (target_len > fs->blocksize) {
+		retval = EXT2_ET_INVALID_ARGUMENT;
+		goto cleanup;
+	}
+
+	/*
+	 * Allocate a data block for slow links
+	 */
+	fastlink = (target_len < sizeof(inode.i_block));
+	if (!fastlink) {
+		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		if (retval)
+			goto cleanup;
+		retval = ext2fs_get_mem(fs->blocksize, &block_buf);
+		if (retval)
+			goto cleanup;
+	}
+
+	/*
+	 * Allocate an inode, if necessary
+	 */
+	if (!ino) {
+		retval = ext2fs_new_inode(fs, parent, LINUX_S_IFLNK | 0755,
+		                          0, &ino);
+		if (retval)
+			goto cleanup;
+	}
+
+	/*
+	 * Create the inode structure....
+	 */
+	memset(&inode, 0, sizeof(struct ext2_inode));
+	inode.i_mode = LINUX_S_IFLNK | 0777;
+	inode.i_uid = inode.i_gid = 0;
+	ext2fs_iblk_set(fs, &inode, 1);
+	inode.i_links_count = 1;
+	inode.i_size = target_len;
+	/* The time fields are set by ext2fs_write_new_inode() */
+
+	if (fastlink) {
+		/* Fast symlinks, target stored in inode */
+		strcpy((char *)&inode.i_block, target);
+	} else {
+		/* Slow symlinks, target stored in the first block */
+		strcpy(block_buf, target);
+		if (fs->super->s_feature_incompat &
+	           EXT3_FEATURE_INCOMPAT_EXTENTS) {
+			/*
+			 * The extent bmap is setup after the inode and block
+			 * have been written out below.
+			 */
+			inode.i_flags |= EXT4_EXTENTS_FL;
+		} else {
+			inode.i_block[0] = blk;
+		}
+	}
+
+	/*
+	 * Write out the inode and inode data block.  The inode generation
+	 * number is assigned by write_new_inode, which means that the
+	 * operations using ino must come after it.
+	 */
+	retval = ext2fs_write_new_inode(fs, ino, &inode);
+	if (retval)
+		goto cleanup;
+
+	if (!fastlink) {
+		retval = io_channel_write_blk(fs->io, blk, 1, block_buf);
+		if (retval)
+			goto cleanup;
+
+		/* FIXME/VERIFY: Do we need ext2fs_bmap2() here? file ops use
+		 * it, mkdir did not */
+
+		if (fs->super->s_feature_incompat &
+		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+			retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
+			if (retval)
+				goto cleanup;
+			retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
+			ext2fs_extent_free(handle);
+			if (retval)
+				goto cleanup;
+		}
+	}
+
+	/*
+	 * Link the symlink into the filesystem hierarchy
+	 */
+	if (name) {
+		retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
+		                       &scratch_ino);
+		if (!retval) {
+			retval = EXT2_ET_FILE_EXISTS;
+			goto cleanup;
+		}
+		if (retval != EXT2_ET_FILE_NOT_FOUND)
+			goto cleanup;
+		retval = ext2fs_link(fs, parent, name, ino, EXT2_FT_SYMLINK);
+		if (retval)
+			goto cleanup;
+	}
+
+	/*
+	 * Update accounting....
+	 */
+	if (!fastlink)
+		ext2fs_block_alloc_stats2(fs, blk, +1);
+	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
+
+cleanup:
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	return retval;
+}
-- 
1.7.11.7

