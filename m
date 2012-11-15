From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] debugfs: dump a sparse file as a new sparse file
Date: Thu, 15 Nov 2012 22:46:13 +0800
Message-ID: <20121115144613.GA11706@gmail.com>
References: <20121114040757.16656.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46989 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767923Ab2KOOdx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 09:33:53 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1185806pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 06:33:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121114040757.16656.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 13, 2012 at 11:07:57PM -0500, George Spelvin wrote:
> When dumping a file with some messed-up block pointers, I discovered
> that I had a huge, and fully allocated destination file.  (ls -s on the
> dump displayed some very large number, even though the original file
> only had about 8 blocks allocated.)
> 
> It wouldprobably make more sense to seek over the gaps to create a
> sparse file.

Hi George,

Would you like to try this patch?

Thanks,
                                                - Zheng

Subject: [PATCH] debugfs: dump a sparse file as a new sparse file

From: Zheng Liu <wenqing.lz@taobao.com>

For dumping a sparse file ext2fs_file_read2() is defined to expand the
interface.  It returns the size of hole and we can call lseek64(2) to skip it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c      | 16 ++++++++++++++--
 lib/ext2fs/ext2fs.h |  3 +++
 lib/ext2fs/fileio.c | 48 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index a15a0b7..013c0c8 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -105,10 +105,11 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 {
 	errcode_t retval;
 	struct ext2_inode	inode;
-	char 		buf[8192];
+	char 		buf[current_fs->blocksize];
 	ext2_file_t	e2_file;
 	int		nbytes;
 	unsigned int	got;
+	ext2_off64_t	seek;
 
 	if (debugfs_read_inode(ino, &inode, cmdname))
 		return;
@@ -119,11 +120,22 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 		return;
 	}
 	while (1) {
-		retval = ext2fs_file_read(e2_file, buf, sizeof(buf), &got);
+		if (fd == 1)
+			retval = ext2fs_file_read(e2_file, buf, sizeof(buf),
+						  &got);
+		else
+			retval = ext2fs_file_read2(e2_file, buf, sizeof(buf),
+						   &got, &seek);
 		if (retval)
 			com_err(cmdname, retval, "while reading ext2 file");
 		if (got == 0)
 			break;
+		if (fd != 1) {
+			nbytes = lseek64(fd, current_fs->blocksize * seek,
+					 SEEK_CUR);
+			if (nbytes < 0)
+				com_err(cmdname, errno, "while lseeking file");
+		}
 		nbytes = write(fd, buf, got);
 		if ((unsigned) nbytes != got)
 			com_err(cmdname, errno, "while writing file");
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9148d4e..8576b1e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1171,6 +1171,9 @@ extern errcode_t ext2fs_file_close(ext2_file_t file);
 extern errcode_t ext2fs_file_flush(ext2_file_t file);
 extern errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 				  unsigned int wanted, unsigned int *got);
+extern errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
+				  unsigned int wanted, unsigned int *got,
+				  ext2_off64_t *seek);
 extern errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
 				   unsigned int nbytes, unsigned int *written);
 extern errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..d25ebb4 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -176,23 +176,26 @@ static errcode_t sync_buffer_position(ext2_file_t file)
  * This function loads the file's block buffer with valid data from
  * the disk as necessary.
  *
- * If dontfill is true, then skip initializing the buffer since we're
+ * If flags is true, then skip initializing the buffer since we're
  * going to be replacing its entire contents anyway.  If set, then the
  * function basically only sets file->physblock and EXT2_FILE_BUF_VALID
  */
 #define DONTFILL 1
-static errcode_t load_buffer(ext2_file_t file, int dontfill)
+#define SEEK	 2
+static errcode_t load_buffer(ext2_file_t file, int flags)
 {
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
+	int		ret_flags;
+	int		valid = 1;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno, 0,
+				     BMAP_BUFFER, 0, file->blockno, &ret_flags,
 				     &file->physblock);
 		if (retval)
 			return retval;
-		if (!dontfill) {
+		if (flags != DONTFILL) {
 			if (file->physblock) {
 				retval = io_channel_read_blk(fs->io,
 							     file->physblock,
@@ -202,7 +205,11 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 			} else
 				memset(file->buf, 0, fs->blocksize);
 		}
-		file->flags |= EXT2_FILE_BUF_VALID;
+		if (flags == SEEK && ((ret_flags & BMAP_RET_UNINIT) ||
+		    file->physblock == 0))
+			valid = 0;
+		if (valid)
+			file->flags |= EXT2_FILE_BUF_VALID;
 	}
 	return 0;
 }
@@ -227,20 +234,33 @@ errcode_t ext2fs_file_close(ext2_file_t file)
 errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 			   unsigned int wanted, unsigned int *got)
 {
+	return ext2fs_file_read2(file, buf, wanted, got, 0);
+}
+
+
+errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
+			    unsigned int wanted, unsigned int *got,
+			    ext2_off64_t *seek)
+{
 	ext2_filsys	fs;
 	errcode_t	retval = 0;
 	unsigned int	start, c, count = 0;
 	__u64		left;
 	char		*ptr = (char *) buf;
+	int		seek_cnt = 0;
+	int		flags = 0;
 
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 	fs = file->fs;
 
+	if (seek)
+		flags = SEEK;
+
 	while ((file->pos < EXT2_I_SIZE(&file->inode)) && (wanted > 0)) {
 		retval = sync_buffer_position(file);
 		if (retval)
 			goto fail;
-		retval = load_buffer(file, 0);
+		retval = load_buffer(file, flags);
 		if (retval)
 			goto fail;
 
@@ -248,20 +268,26 @@ errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 		c = fs->blocksize - start;
 		if (c > wanted)
 			c = wanted;
-		left = EXT2_I_SIZE(&file->inode) - file->pos ;
+		left = EXT2_I_SIZE(&file->inode) - file->pos;
 		if (c > left)
 			c = left;
 
-		memcpy(ptr, file->buf+start, c);
 		file->pos += c;
-		ptr += c;
-		count += c;
-		wanted -= c;
+		if (file->flags & EXT2_FILE_BUF_VALID) {
+			memcpy(ptr, file->buf+start, c);
+			ptr += c;
+			count += c;
+			wanted -= c;
+		} else {
+			seek_cnt++;
+		}
 	}
 
 fail:
 	if (got)
 		*got = count;
+	if (seek)
+		*seek = seek_cnt;
 	return retval;
 }
 
-- 
1.7.12.rc2.18.g61b472e

