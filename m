From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/35] copy-in: for files,
 only iterate file blocks that are mapped
Date: Wed, 01 Apr 2015 19:36:37 -0700
Message-ID: <20150402023637.25243.95578.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbDBCgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:36:45 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rewrite the file copy-in algorithm to detect smaller holes in the
files we're copying in.  Use SEEK_DATA/SEEK_HOLE/FIEMAP when available
to skip known empty parts.  This fixes the particular bug where zeroed
blocks on a system with 64k pages are needlessly copied into a
4k-block filesystem.  It also saves time by skipping parts we know to
be zeroed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |  280 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 196 insertions(+), 84 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 3bc0515..8ab546e 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -9,12 +9,22 @@
  * %End-Header%
  */
 
+#define _FILE_OFFSET_BITS       64
+#define _LARGEFILE64_SOURCE     1
+#define _GNU_SOURCE		1
+
+#include "config.h"
 #include <time.h>
+#include <sys/types.h>
 #include <unistd.h>
 #include <limits.h> /* for PATH_MAX */
 #ifdef HAVE_ATTR_XATTR_H
 #include <attr/xattr.h>
 #endif
+#include <sys/ioctl.h>
+#include <ext2fs/ext2fs.h>
+#include <ext2fs/ext2_types.h>
+#include <ext2fs/fiemap.h>
 
 #include "create_inode.h"
 #include "nls-enable.h"
@@ -28,14 +38,7 @@
 #endif
 
 /* 64KiB is the minimium blksize to best minimize system call overhead. */
-#ifndef IO_BUFSIZE
-#define IO_BUFSIZE 64*1024
-#endif
-
-/* Block size for `st_blocks' */
-#ifndef S_BLKSIZE
-#define S_BLKSIZE 512
-#endif
+#define COPY_FILE_BUFLEN	65536
 
 static int ext2_file_type(unsigned int mode)
 {
@@ -139,10 +142,9 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 {
 #ifdef HAVE_LLISTXATTR
 	errcode_t			retval, close_retval;
-	struct ext2_inode		inode;
 	struct ext2_xattr_handle	*handle;
 	ssize_t				size, value_size;
-	char				*list;
+	char				*list = NULL;
 	int				i;
 
 	size = llistxattr(filename, NULL, 0);
@@ -382,82 +384,202 @@ try_again:
 	return retval;
 }
 
-static errcode_t copy_file(ext2_filsys fs, int fd, ext2_ino_t newfile,
-			   int bufsize, int make_holes)
+#if !defined HAVE_PREAD64 && !defined HAVE_PREAD
+static ssize_t my_pread(int fd, const void *buf, size_t count, off_t offset)
 {
-	ext2_file_t	e2_file;
-	errcode_t	retval, close_ret;
-	int		got;
-	unsigned int	written;
-	char		*buf;
-	char		*ptr;
-	char		*zero_buf;
-	int		cmp;
-
-	retval = ext2fs_file_open(fs, newfile,
-				  EXT2_FILE_WRITE, &e2_file);
-	if (retval)
-		return retval;
-
-	retval = ext2fs_get_mem(bufsize, &buf);
-	if (retval) {
-		com_err("copy_file", retval, "can't allocate buffer\n");
-		goto out_close;
-	}
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return 0;
 
-	/* This is used for checking whether the whole block is zero */
-	retval = ext2fs_get_memzero(bufsize, &zero_buf);
-	if (retval) {
-		com_err("copy_file", retval, "can't allocate zero buffer\n");
-		goto out_free_buf;
-	}
+	return read(fd, buf, count);
+}
+#endif /* !defined HAVE_PREAD64 && !defined HAVE_PREAD */
 
-	while (1) {
-		got = read(fd, buf, bufsize);
-		if (got == 0)
-			break;
+static errcode_t copy_file_range(ext2_filsys fs, int fd, ext2_file_t e2_file,
+				 off_t start, off_t end, char *buf,
+				 char *zerobuf)
+{
+	off_t off, bpos;
+	ssize_t got, blen;
+	unsigned int written;
+	char *ptr;
+	errcode_t err = 0;
+
+	for (off = start; off < end; off += COPY_FILE_BUFLEN) {
+#ifdef HAVE_PREAD64
+		got = pread64(fd, buf, COPY_FILE_BUFLEN, off);
+#elif HAVE_PREAD
+		got = pread(fd, buf, COPY_FILE_BUFLEN, off);
+#else
+		got = my_pread(fd, buf, COPY_FILE_BUFLEN, off);
+#endif
 		if (got < 0) {
-			retval = errno;
+			err = errno;
 			goto fail;
 		}
-		ptr = buf;
-
-		/* Sparse copy */
-		if (make_holes) {
-			/* Check whether all is zero */
-			cmp = memcmp(ptr, zero_buf, got);
-			if (cmp == 0) {
-				 /* The whole block is zero, make a hole */
-				retval = ext2fs_file_lseek(e2_file, got,
-							   EXT2_SEEK_CUR,
-							   NULL);
-				if (retval)
+		for (bpos = 0, ptr = buf; bpos < got; bpos += fs->blocksize) {
+			blen = fs->blocksize;
+			if (blen > got - bpos)
+				blen = got - bpos;
+			if (memcmp(ptr, zerobuf, blen) == 0) {
+				ptr += blen;
+				continue;
+			}
+			err = ext2fs_file_lseek(e2_file, off + bpos,
+						EXT2_SEEK_SET, NULL);
+			if (err)
+				goto fail;
+			while (blen > 0) {
+				err = ext2fs_file_write(e2_file, ptr, blen,
+							&written);
+				if (err)
+					goto fail;
+				if (written == 0) {
+					err = EIO;
 					goto fail;
-				got = 0;
+				}
+				blen -= written;
+				ptr += written;
 			}
 		}
+	}
+fail:
+	return err;
+}
 
-		/* Normal copy */
-		while (got > 0) {
-			retval = ext2fs_file_write(e2_file, ptr,
-						   got, &written);
-			if (retval)
-				goto fail;
-
-			got -= written;
-			ptr += written;
+static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
+				ext2_file_t e2_file, char *buf, char *zerobuf)
+{
+#if defined(SEEK_DATA) && defined(SEEK_HOLE)
+	off_t data = 0, hole;
+	off_t data_blk, hole_blk;
+	errcode_t err;
+
+	/* Try to use SEEK_DATA and SEEK_HOLE */
+	while (data < statbuf->st_size) {
+		data = lseek(fd, data, SEEK_DATA);
+		if (data < 0) {
+			if (errno == ENXIO)
+				break;
+			return EXT2_ET_UNIMPLEMENTED;
 		}
+		hole = lseek(fd, data, SEEK_HOLE);
+		if (hole < 0)
+			return EXT2_ET_UNIMPLEMENTED;
+
+		data_blk = data & ~(fs->blocksize - 1);
+		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
+		err = copy_file_range(fs, fd, e2_file, data_blk, hole_blk, buf,
+				      zerobuf);
+		if (err)
+			return err;
+
+		data = hole;
 	}
 
-fail:
-	ext2fs_free_mem(&zero_buf);
-out_free_buf:
+	return err;
+#else
+	return EXT2_ET_UNIMPLEMENTED;
+#endif /* SEEK_DATA and SEEK_HOLE */
+}
+
+static errcode_t try_fiemap_copy(ext2_filsys fs, int fd, ext2_file_t e2_file,
+				 char *buf, char *zerobuf)
+{
+#if defined(FS_IOC_FIEMAP)
+#define EXTENT_MAX_COUNT 512
+	struct fiemap *fiemap_buf;
+	struct fiemap_extent *ext_buf, *ext;
+	int ext_buf_size, fie_buf_size;
+	off_t pos = 0;
+	unsigned int i;
+	errcode_t err;
+
+	ext_buf_size = EXTENT_MAX_COUNT * sizeof(struct fiemap_extent);
+	fie_buf_size = sizeof(struct fiemap) + ext_buf_size;
+
+	err = ext2fs_get_memzero(fie_buf_size, &fiemap_buf);
+	if (err)
+		return err;
+
+	ext_buf = fiemap_buf->fm_extents;
+	memset(fiemap_buf, 0, fie_buf_size);
+	fiemap_buf->fm_length = FIEMAP_MAX_OFFSET;
+	fiemap_buf->fm_flags |= FIEMAP_FLAG_SYNC;
+	fiemap_buf->fm_extent_count = EXTENT_MAX_COUNT;
+
+	do {
+		fiemap_buf->fm_start = pos;
+		memset(ext_buf, 0, ext_buf_size);
+		err = ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
+		if (err < 0 && (errno == EOPNOTSUPP || errno == ENOTTY)) {
+			err = EXT2_ET_UNIMPLEMENTED;
+			goto out;
+		} else if (err < 0 || fiemap_buf->fm_mapped_extents == 0) {
+			err = errno;
+			goto out;
+		}
+		for (i = 0, ext = ext_buf; i < fiemap_buf->fm_mapped_extents;
+		     i++, ext++) {
+			err = copy_file_range(fs, fd, e2_file, ext->fe_logical,
+					      ext->fe_logical + ext->fe_length,
+					      buf, zerobuf);
+			if (err)
+				goto out;
+		}
+
+		ext--;
+		/* Record file's logical offset this time */
+		pos = ext->fe_logical + ext->fe_length;
+		/*
+		 * If fm_extents array has been filled and
+		 * there are extents left, continue to cycle.
+		 */
+	} while (fiemap_buf->fm_mapped_extents == EXTENT_MAX_COUNT &&
+		 !(ext->fe_flags & FIEMAP_EXTENT_LAST));
+out:
+	ext2fs_free_mem(&fiemap_buf);
+	return err;
+#else
+	return EXT2_ET_UNIMPLEMENTED;
+#endif /* FS_IOC_FIEMAP */
+}
+
+static errcode_t copy_file(ext2_filsys fs, int fd, struct stat *statbuf,
+			   ext2_ino_t ino)
+{
+	ext2_file_t e2_file;
+	char *buf = NULL, *zerobuf = NULL;
+	errcode_t err, close_err;
+
+	err = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &e2_file);
+	if (err)
+		return err;
+
+	err = ext2fs_get_mem(COPY_FILE_BUFLEN, &buf);
+	if (err)
+		goto out;
+
+	err = ext2fs_get_memzero(fs->blocksize, &zerobuf);
+	if (err)
+		goto out;
+
+	err = try_lseek_copy(fs, fd, statbuf, e2_file, buf, zerobuf);
+	if (err != EXT2_ET_UNIMPLEMENTED)
+		goto out;
+
+	err = try_fiemap_copy(fs, fd, e2_file, buf, zerobuf);
+	if (err != EXT2_ET_UNIMPLEMENTED)
+		goto out;
+
+	err = copy_file_range(fs, fd, e2_file, 0, statbuf->st_size, buf,
+			      zerobuf);
+out:
+	ext2fs_free_mem(&zerobuf);
 	ext2fs_free_mem(&buf);
-out_close:
-	close_ret = ext2fs_file_close(e2_file);
-	if (retval == 0)
-		retval = close_ret;
-	return retval;
+	close_err = ext2fs_file_close(e2_file);
+	if (err == 0)
+		err = close_err;
+	return err;
 }
 
 static int is_hardlink(struct hdlinks_s *hdlinks, dev_t dev, ino_t ino)
@@ -481,8 +603,6 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 	ext2_ino_t	newfile;
 	errcode_t	retval;
 	struct ext2_inode inode;
-	int		bufsize = IO_BUFSIZE;
-	int		make_holes = 0;
 
 	fd = ext2fs_open_file(src, O_RDONLY, 0);
 	if (fd < 0) {
@@ -570,17 +690,9 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 		}
 	}
 	if (LINUX_S_ISREG(inode.i_mode)) {
-		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
-			make_holes = 1;
-			/*
-			 * Use I/O blocksize as buffer size when
-			 * copying sparse files.
-			 */
-			bufsize = statbuf.st_blksize;
-		}
-		retval = copy_file(fs, fd, newfile, bufsize, make_holes);
+		retval = copy_file(fs, fd, &statbuf, newfile);
 		if (retval)
-			com_err("copy_file", retval, 0);
+			com_err("copy_file", retval, _("while copying %s"), src);
 	}
 	close(fd);
 

