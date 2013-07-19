From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 2/2] debugfs.c: do sparse copy when src is a sparse file
Date: Fri, 19 Jul 2013 10:17:37 +0800
Message-ID: <1374200257-2873-3-git-send-email-liezhi.yang@windriver.com>
References: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:51281 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638Ab3GSCTT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jul 2013 22:19:19 -0400
In-Reply-To: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let debugfs do sparse copy when src is a sparse file, just like
"cp --sparse=auto"

* For the
  #define IO_BUFSIZE 32*1024

  This is from coreutils-8.13/src/ioblksize.h (GPL V3):
/* As of Mar 2009, 32KiB is determined to be the minimium
   blksize to best minimize system call overhead.
   This can be tested with this script with the results
   shown for a 1.7GHz pentium-m with 2GB of 400MHz DDR2 RAM:

   for i in $(seq 0 10); do
     size=$((8*1024**3)) #ensure this is big enough
     bs=$((1024*2**$i))
     printf "%7s=" $bs
     dd bs=$bs if=/dev/zero of=/dev/null count=$(($size/$bs)) 2>&1 |
     sed -n 's/.* \([0-9.]* [GM]B\/s\)/\1/p'
   done

      1024=734 MB/s
      2048=1.3 GB/s
      4096=2.4 GB/s
      8192=3.5 GB/s
     16384=3.9 GB/s
     32768=5.2 GB/s
     65536=5.3 GB/s
    131072=5.5 GB/s
    262144=5.7 GB/s
    524288=5.7 GB/s
   1048576=5.8 GB/s

   Note that this is to minimize system call overhead.
   Other values may be appropriate to minimize file system
   or disk overhead.  For example on my current GNU/Linux system
   the readahead setting is 128KiB which was read using:

   file="."
   device=$(df -P --local "$file" | tail -n1 | cut -d' ' -f1)
   echo $(( $(blockdev --getra $device) * 512 ))

   However there isn't a portable way to get the above.
   In the future we could use the above method if available
   and default to io_blksize() if not.
 */
enum { IO_BUFSIZE = 32*1024 };

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
---
 debugfs/debugfs.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index b77d0b5..e443703 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -37,6 +37,16 @@ extern char *optarg;
 #include "../version.h"
 #include "jfs_user.h"
 
+/* 32KiB is the minimium blksize to best minimize system call overhead. */
+#ifndef IO_BUFSIZE
+#define IO_BUFSIZE 32*1024
+#endif
+
+/* Block size for `st_blocks' */
+#ifndef S_BLKSIZE
+#define S_BLKSIZE 512
+#endif
+
 ss_request_table *extra_cmds;
 const char *debug_prog_name;
 int sci_idx;
@@ -1571,14 +1581,17 @@ void do_find_free_inode(int argc, char *argv[])
 }
 
 #ifndef READ_ONLY
-static errcode_t copy_file(int fd, ext2_ino_t newfile)
+static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
+			int make_holes, int *zero_written)
 {
 	ext2_file_t	e2_file;
 	errcode_t	retval;
 	int		got;
 	unsigned int	written;
-	char		buf[8192];
+	char		buf[bufsize];
 	char		*ptr;
+	char		*cp;
+	int		count;
 
 	retval = ext2fs_file_open(current_fs, newfile,
 				  EXT2_FILE_WRITE, &e2_file);
@@ -1594,14 +1607,30 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile)
 			goto fail;
 		}
 		ptr = buf;
+		cp = ptr;
+		count = got;
 		while (got > 0) {
-			retval = ext2fs_file_write(e2_file, ptr,
-						   got, &written);
-			if (retval)
-				goto fail;
-
-			got -= written;
-			ptr += written;
+			if (make_holes) {
+				/* Check whether all is zero */
+				while (count-- && *cp++ == 0)
+					continue;
+				if (count < 0) {
+					 /* The whole block is zero, make a hole */
+					retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
+					if (retval)
+						goto fail;
+					got = 0;
+				}
+			}
+			/* Normal copy */
+			if (got > 0) {
+				*zero_written = 0;
+				retval = ext2fs_file_write(e2_file, ptr, got, &written);
+				if (retval)
+					goto fail;
+				got -= written;
+				ptr += written;
+			}
 		}
 	}
 	retval = ext2fs_file_close(e2_file);
@@ -1620,6 +1649,9 @@ void do_write(int argc, char *argv[])
 	ext2_ino_t	newfile;
 	errcode_t	retval;
 	struct ext2_inode inode;
+	int		bufsize = IO_BUFSIZE;
+	int		make_holes = 0;
+	int 		zero_written = 1;
 
 	if (common_args_process(argc, argv, 3, 3, "write",
 				"<native file> <new file>", CHECK_FS_RW))
@@ -1684,9 +1716,27 @@ void do_write(int argc, char *argv[])
 		return;
 	}
 	if (LINUX_S_ISREG(inode.i_mode)) {
-		retval = copy_file(fd, newfile);
+		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
+			make_holes = 1;
+			/*
+			 * Use I/O blocksize as buffer size when
+			 * copying sparse files.
+			 */
+			bufsize = statbuf.st_blksize;
+		}
+		retval = copy_file(fd, newfile, bufsize, make_holes, &zero_written);
 		if (retval)
 			com_err("copy_file", retval, 0);
+
+		if ((inode.i_flags & EXT4_EXTENTS_FL) && zero_written) {
+			/*
+			 * If no data is copied which indicateds that no write
+			 * happens, we need to turn off the EXT4_EXTENTS_FL.
+			 */
+			inode.i_flags &= ~EXT4_EXTENTS_FL;
+			if (debugfs_write_inode(newfile, &inode, argv[0]))
+				close(fd);
+		}
 	}
 	close(fd);
 }
-- 
1.8.1.2

