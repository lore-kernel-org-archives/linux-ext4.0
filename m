From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able
 devices
Date: Mon, 20 Sep 2010 09:23:24 -0400
Message-ID: <20100920132324.GE3554@thunk.org>
References: <4C6EF67A.5080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab0ITNX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Sep 2010 09:23:26 -0400
Content-Disposition: inline
In-Reply-To: <4C6EF67A.5080502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 20, 2010 at 04:41:14PM -0500, Eric Sandeen wrote:
> If a device supports discard -and- returns 0s for discarded blocks,
> then we can skip the inode table initialization -and- the inode table
> zeroing at mkfs time, and skip the lazy init as well since they are
> already zeroed out.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, with some minor changes so it can apply against the "maint"
branch, and to eliminate a global variable.

					- Ted

commit 6fcd6f84c235f4bf2bd9770f172837da9982eb6e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Aug 20 16:41:14 2010 -0500

    mke2fs: use lazy inode init on some discard-able devices
    
    If a device supports discard -and- returns 0s for discarded blocks,
    then we can skip the inode table initialization -and- the inode table
    zeroing at mkfs time, and skip the lazy init as well since they are
    already zeroed out.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e725cd1..7c337a0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -85,7 +85,7 @@ int	force;
 int	noaction;
 int	journal_size;
 int	journal_flags;
-int	lazy_itable_init;
+int	lazy_itable_init;	/* use lazy inode table init */
 char	*bad_blocks_filename;
 __u32	fs_stride;
 
@@ -350,7 +350,7 @@ static void progress_close(struct progress_struct *progress)
 	fputs(_("done                            \n"), stdout);
 }
 
-static void write_inode_tables(ext2_filsys fs, int lazy_flag)
+static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 {
 	errcode_t	retval;
 	blk_t		blk;
@@ -377,7 +377,8 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 				 EXT2_INODE_SIZE(fs->super)) +
 				EXT2_BLOCK_SIZE(fs->super) - 1) /
 			       EXT2_BLOCK_SIZE(fs->super));
-		} else {
+		}
+		if (!lazy_flag || itable_zeroed) {
 			/* The kernel doesn't need to zero the itable blocks */
 			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 			ext2fs_group_desc_csum_set(fs, i);
@@ -1943,7 +1944,14 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
-static void mke2fs_discard_blocks(ext2_filsys fs)
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12,124)
+#endif
+
+/*
+ * Return zero if the discard succeeds, and -1 if the discard fails.
+ */
+static int mke2fs_discard_blocks(ext2_filsys fs)
 {
 	int fd;
 	int ret;
@@ -1958,10 +1966,6 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 
 	fd = open64(fs->device_name, O_RDWR);
 
-	/*
-	 * We don't care about whether the ioctl succeeds; it's only an
-	 * optmization for SSDs or sparse storage.
-	 */
 	if (fd > 0) {
 		ret = ioctl(fd, BLKDISCARD, &range);
 		if (verbose) {
@@ -1975,9 +1979,26 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 		}
 		close(fd);
 	}
+	return ret;
+}
+
+static int mke2fs_discard_zeroes_data(ext2_filsys fs)
+{
+	int fd;
+	int ret;
+	int discard_zeroes_data = 0;
+
+	fd = open64(fs->device_name, O_RDWR);
+
+	if (fd > 0) {
+		ioctl(fd, BLKDISCARDZEROES, &discard_zeroes_data);
+		close(fd);
+	}
+	return discard_zeroes_data;
 }
 #else
-#define mke2fs_discard_blocks(fs)
+#define mke2fs_discard_blocks(fs)	1
+#define mke2fs_discard_zeroes_data(fs)	0
 #endif
 
 int main (int argc, char *argv[])
@@ -1991,6 +2012,7 @@ int main (int argc, char *argv[])
 	io_manager	io_ptr;
 	char		tdb_string[40];
 	char		*hash_alg_str;
+	int		itable_zeroed = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -2025,8 +2047,17 @@ int main (int argc, char *argv[])
 	}
 
 	/* Can't undo discard ... */
-	if (discard && (io_ptr != undo_io_manager))
-		mke2fs_discard_blocks(fs);
+	if (discard && (io_ptr != undo_io_manager)) {
+		retval = mke2fs_discard_blocks(fs);
+
+		if (!retval && mke2fs_discard_zeroes_data(fs)) {
+			if (verbose)
+				printf(_("Discard succeeded and will return 0s "
+					 " - skipping inode table wipe\n"));
+			lazy_itable_init = 1;
+			itable_zeroed = 1;
+		}
+	}
 
 	sprintf(tdb_string, "tdb_data_size=%d", fs->blocksize <= 4096 ?
 		32768 : fs->blocksize * 8);
@@ -2172,7 +2203,7 @@ int main (int argc, char *argv[])
 				_("while zeroing block %u at end of filesystem"),
 				ret_blk);
 		}
-		write_inode_tables(fs, lazy_itable_init);
+		write_inode_tables(fs, lazy_itable_init, itable_zeroed);
 		create_root_dir(fs);
 		create_lost_and_found(fs);
 		reserve_inodes(fs);
