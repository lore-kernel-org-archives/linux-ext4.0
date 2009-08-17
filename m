From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Large volume ll_ver_fs results (w/ short read/write patch).
Date: Mon, 17 Aug 2009 10:55:12 -0400
Message-ID: <20654.1250520912@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173013pub.verizon.net ([206.46.173.13]:37163 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZHQPzs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Aug 2009 11:55:48 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173013.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KOJ006VM03LWU26@vms173013.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Mon, 17 Aug 2009 09:55:03 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Here are some results of running ll_ver_fs on an ext4 fs created on a
96TB volume. The test was run in full mode: it created 725 directories
each with 32 4GB files and then read everything back with
verification.In summary,

  mkfs: about 30mins
  ll_ver_fs: about 100 hours
  fsck: about 40mins

(a more detailed log is attached).

There were two disk errors encountered that resulted in short reads, but
the patched ll_ver_fs continued on (patch attached). So two chunks (1MB
each) were not completely verified (only the part that was read
successfully was), but the rest of the fs checked out OK. Luckily, the
fsck did not find any errors: both disk errors were in file data.
We have replaced the disks but are not planning to repeat the test: it's
not clear that it would tells us anything more at this point.

Thanks,
Nick


--=-=-=
Content-Disposition: attachment; filename=results.log
Content-Description: More detailed log

# time mke2fs -q -t ext4 -O ^resize_inode -E stride=32,stripe-width=1536 /dev/mapper/bigvg-bigvol
-- 0:bash -- time-stamp -- Aug/06/09 20:03:13 --
-- 0:bash -- time-stamp -- Aug/06/09 20:29:51 --
140.30user 1570.22system 28:33.63elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
344inputs+2148162944outputs (1major+893979minor)pagefaults 0swaps

# mount /dev/mapper/bigvg-bigvol /mnt

# time ~/src/tools/lustre/liverfs -v -v -l -r -w /mnt
Timestamp: 1249605008

...

write File name: /mnt/dir00725/file007          -- 0:bash -- time-stamp -- Aug/08/09 18:45:30 --
write File name: /mnt/dir00725/file008          -- 0:bash -- time-stamp -- Aug/08/09 18:47:40 --
write File name: /mnt/dir00725/file009          -- 0:bash -- time-stamp -- Aug/08/09 18:50:50 --
-- 0:bash -- time-stamp -- Aug/08/09 18:53:05 --
write File name: /mnt/dir00725/file010          -- 0:bash -- time-stamp -- Aug/08/09 18:55:00 --
-- 0:bash -- time-stamp -- Aug/08/09 18:57:18 --
write File name: /mnt/dir00725/file011          -- 0:bash -- time-stamp -- Aug/08/09 18:59:11 --
short write
write File name: /mnt/dir00725/file011          
write complete

...

read File name: /mnt/dir00460/file017          -- 0:bash -- time-stamp -- Aug/09/09 21:42:01 --
short read

...
read File name: /mnt/dir00534/file003          -- 0:bash -- time-stamp -- Aug/10/09 12:41:05 --
short read

...

read File name: /mnt/dir00725/file010          
read complete
1079.45user 283006.51system 99:24:30elapsed 79%CPU (0avgtext+0avgdata 0maxresident)k
194716365096inputs+195537745440outputs (1major+410minor)pagefaults 0swaps

# umount /dev/mapper/bigvg-bigvol

# time e2fsck  -t -t -F -y -f /dev/mapper/bigvg-bigvol
e2fsck 1.41.8 (20-Jul-2009)
Pass 1: Checking inodes, blocks, and sizes
-- 0:bash -- time-stamp -- Aug/10/09 23:57:09 --
-- 0:bash -- time-stamp -- Aug/11/09  0:13:02 --
Pass 1: Memory used: 284k/1630436k (132k/153k), time: 1070.35/876.01/ 5.85
Pass 1: I/O read: 190MB, write: 1MB, rate: 0.18MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 284k/18014398508112064k (95k/190k), time:  2.29/ 0.93/ 0.94
Pass 2: I/O read: 3MB, write: 0MB, rate: 1.31MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 284k/18014398508635724k (95k/190k), time: 1082.09/884.06/ 9.05
Pass 3A: Memory used: 284k/18014398508635724k (95k/190k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 284k/18014398508112064k (86k/199k), time:  0.58/ 0.26/ 0.32
Pass 3: I/O read: 1MB, write: 0MB, rate: 1.71MB/s
Pass 4: Checking reference counts
-- 0:bash -- time-stamp -- Aug/11/09  0:15:00 --
Pass 4: Memory used: 284k/18014398509394812k (86k/199k), time: 147.57/147.27/ 0.28
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
-- 0:bash -- time-stamp -- Aug/11/09  0:17:30 --
-- 0:bash -- time-stamp -- Aug/11/09  0:34:08 --
Pass 5: Memory used: 336k/18014398508871152k (86k/251k), time: 1116.22/701.57/17.46
Pass 5: I/O read: 2934MB, write: 0MB, rate: 2.63MB/s
/dev/mapper/bigvg-bigvol: 23950/4289791968 files (0.0% non-contiguous), 24609217743/24609226752 blocks
Memory used: 336k/18014398508871152k (86k/251k), time: 2346.25/1733.22/26.84
I/O read: 3173MB, write: 1MB, rate: 1.35MB/s
1733.31user 30.84system 39:10.40elapsed 75%CPU (0avgtext+0avgdata 0maxresident)k
32607624inputs+93896outputs (5major+4403055minor)pagefaults 0swaps
-- 0:bash -- time-stamp -- Aug/11/09  0:36:11 --


--=-=-=
Content-Disposition: attachment; filename=llverfs.patch
Content-Description: ll_ver_fs patch to deal with short reads/writes.

diff --git a/liverfs.c b/liverfs.c
index cf0de5a..e400066 100644
--- a/liverfs.c
+++ b/liverfs.c
@@ -35,23 +35,28 @@
  *
  * lustre/utils/llverfs.c
  *
- * ext3 Filesystem Verification Tool.
- * This program tests the correct operation of ext3 filesystem.
- * This tool have two working modes
+ * ext3/4 Filesystem Verification Tool.
+ *
+ * This program tests some correctness aspects of ext3/4 filesystem
+ * operation.
+ *
+ * This tool has two working modes
  * 1. full mode
  * 2. fast mode
- *	The full mode is basic mode in which program creates a subdirectory
- * in the test fileysytem, writes n(files_in_dir, default=16) large(4GB) files
- * to the directory with the test pattern at the start of each 4kb block.
- * The test pattern contains timestamp, relative file offset and per file
- * unique idenfifier(inode number). this continues until whole filesystem is
- * full and then this tooll verifies that the data in all of the test files
- * is correct.
- *	In the fast mode the tool creates a test directories with
- * EXT3_TOPDIR_FL flag set. the number of directories equals to the number
- * of block groups in the filesystem(e.g. 65536 directories for 8TB filesystem)
- * and then writes a single 1MB file in each directory. The tool then verifies
- * that the data in each file is correct.
+ *
+ *	In full mode, the program creates a subdirectory in the test
+ * fileysytem, writes n(files_in_dir, default=32) large(4GB) files to
+ * the directory with the test pattern at the start of each 4kb block.
+ * The test pattern contains timestamp, relative file offset and per
+ * file unique identifier(inode number). This continues until the
+ * whole filesystem is full and then the tool verifies that the data
+ * in all of the test files is correct.
+ *	In fast mode, the tool creates test directories with the
+ * EXT3_TOPDIR_FL flag set. The number of directories equals the
+ * number of block groups in the filesystem (e.g. 65536 directories
+ * for an 8TB filesystem) and then writes a single 1MB file in each
+ * directory. The tool then verifies that the data in each file is
+ * correct.
  */
 
 #ifndef _GNU_SOURCE
@@ -178,7 +183,7 @@ static int open_file(const char *file, int flag)
  * Verify_chunk: Verifies test pattern in each 4kB (BLOCKSIZE) is correct.
  * Returns 0 if test offset and timestamp is correct otherwise 1.
  */
-int verify_chunk(char *chunk_buf, size_t chunksize,unsigned long long chunk_off,
+int verify_chunk(char *chunk_buf, size_t chunksize, unsigned long long chunk_off,
 		 unsigned long long time_st, unsigned long long inode_st,
 		 char *file)
 {
@@ -231,6 +236,7 @@ int write_chunks(int fd, unsigned long long offset,unsigned long long write_end,
 		 ino_t inode_st, const char *file)
 {
 	unsigned long long stride;
+        ssize_t nwritten;
 
 	stride = full ? chunksize : (ONE_GB - chunksize);
 	for (offset = offset & ~(chunksize - 1); offset < write_end;
@@ -245,7 +251,7 @@ int write_chunks(int fd, unsigned long long offset,unsigned long long write_end,
 		if (!full && offset > chunksize) {
 			fill_chunk(chunk_buf, chunksize, offset, time_st,
 				    inode_st);
-			if (write(fd, chunk_buf, chunksize) < 0) {
+			if ((nwritten = write(fd, chunk_buf, chunksize)) < 0) {
 				if (errno == ENOSPC) {
 					errno_local = errno;
 					return 0;
@@ -255,12 +261,14 @@ int write_chunks(int fd, unsigned long long offset,unsigned long long write_end,
 					progname, file, offset,strerror(errno));
 				return errno;
 			}
-			offset += chunksize;
+                        if (nwritten < chunksize)
+                                fprintf(stderr, "short write: offset=%llu, requested=%ld, written=%ld\n", offset, chunksize, nwritten);
+			offset += nwritten;
 			if (offset + chunksize > write_end)
 				chunksize = write_end - offset;
 		}
 		fill_chunk(chunk_buf, chunksize, offset, time_st, inode_st);
-		if (write(fd, (char *) chunk_buf, chunksize) < 0) {
+		if ((nwritten = write(fd, (char *) chunk_buf, chunksize)) < 0) {
 			if (errno == ENOSPC) {
 				errno_local = errno;
 				return 0;
@@ -269,6 +277,8 @@ int write_chunks(int fd, unsigned long long offset,unsigned long long write_end,
 				progname, file, offset, strerror(errno));
 			return 1;
 		}
+                if (nwritten < chunksize)
+                        fprintf(stderr, "short write: offset=%llu, requested=%ld, written=%ld\n", offset, chunksize, nwritten);
 	}
 	return 0;
 }
@@ -282,6 +292,7 @@ int read_chunks(int fd, unsigned long long offset, unsigned long long read_end,
 		ino_t inode_st, char *file)
 {
 	unsigned long long stride;
+        ssize_t nread;
 
 	stride = full ? chunksize : (ONE_GB - chunksize);
 	for (offset = offset & ~(chunksize - 1); offset < read_end;
@@ -294,25 +305,29 @@ int read_chunks(int fd, unsigned long long offset, unsigned long long read_end,
 		if (offset + chunksize > read_end)
 			chunksize = read_end - offset;
 		if (!full && offset > chunksize) {
-			if (read(fd, chunk_buf, chunksize) < 0) {
+			if ((nread = read(fd, chunk_buf, chunksize)) < 0) {
 				fprintf(stderr,
 					"\n%s: read %s+%llu failed: %s\n",
 					progname, file, offset,strerror(errno));
 				return 1;
 			}
-			if (verify_chunk(chunk_buf, chunksize, offset,
+                        if (nread < chunksize)
+                                fprintf(stderr, "short read: offset=%llu, requested=%ld, read=%ld\n", offset, chunksize, nread);
+			if (verify_chunk(chunk_buf, nread, offset,
 					 time_st, inode_st, file) != 0)
 				return 1;
-			offset += chunksize;
+			offset += nread;
 			if (offset + chunksize >= read_end)
 				chunksize = read_end - offset;
 		}
-		if (read(fd, chunk_buf, chunksize) < 0) {
+		if ((nread = read(fd, chunk_buf, chunksize)) < 0) {
 			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
 				progname, file, offset, strerror(errno));
 			return 1;
 		}
-		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
+                if (nread < chunksize)
+                        fprintf(stderr, "short read: offset=%llu, requested=%ld, read=%ld\n", offset, chunksize, nread);
+		if (verify_chunk(chunk_buf, nread, offset, time_st,
 				 inode_st, file) != 0)
 			return 1;
 	}

--=-=-=--
