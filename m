From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Fri, 20 Aug 2010 16:41:14 -0500
Message-ID: <4C6EF67A.5080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0HTVlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 17:41:21 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7KLfH2P019835
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 17:41:17 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7KLfEKT027369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 17:41:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a device supports discard -and- returns 0s for discarded blocks,
then we can skip the inode table initialization -and- the inode table
zeroing at mkfs time, and skip the lazy init as well since they are
already zeroed out.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..b7a9e12 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -88,7 +88,8 @@ int	force;
 int	noaction;
 int	journal_size;
 int	journal_flags;
-int	lazy_itable_init;
+int	lazy_itable_init;	/* use lazy inode table init */
+int	lazy_itable_zeroed;	/* inode table zeroed by discard */
 char	*bad_blocks_filename;
 __u32	fs_stride;
 
@@ -300,7 +301,7 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 }
 
-static void write_inode_tables(ext2_filsys fs, int lazy_flag)
+static void write_inode_tables(ext2_filsys fs, int lazy_flag, int lazy_zeroed)
 {
 	errcode_t	retval;
 	blk64_t		blk;
@@ -325,6 +326,9 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 				 EXT2_INODE_SIZE(fs->super)) +
 				EXT2_BLOCK_SIZE(fs->super) - 1) /
 			       EXT2_BLOCK_SIZE(fs->super));
+			/* if pre-zeroed by discard, mark as such */
+			if (lazy_zeroed)
+				ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 		} else {
 			/* The kernel doesn't need to zero the itable blocks */
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
@@ -1901,7 +1905,11 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
-static void mke2fs_discard_blocks(ext2_filsys fs)
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12,124)
+#endif
+ 
+static int mke2fs_discard_blocks(ext2_filsys fs)
 {
 	int fd;
 	int ret;
@@ -1917,8 +1925,8 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 	fd = open64(fs->device_name, O_RDWR);
 
 	/*
-	 * We don't care about whether the ioctl succeeds; it's only an
-	 * optmization for SSDs or sparse storage.
+	 * We don't much care about whether the ioctl succeeds; it's only
+	 * an optmization for SSDs or thinly-provisioned storage.
 	 */
 	if (fd > 0) {
 		ret = ioctl(fd, BLKDISCARD, &range);
@@ -1933,9 +1941,26 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
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
@@ -1996,8 +2021,17 @@ int main (int argc, char *argv[])
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
+					 " - enabling lazy_itable_init\n"));
+			lazy_itable_init = 1;
+			lazy_itable_zeroed = 1;
+		}
+	}
 
 	sprintf(tdb_string, "tdb_data_size=%d", fs->blocksize <= 4096 ?
 		32768 : fs->blocksize * 8);
@@ -2147,7 +2181,7 @@ int main (int argc, char *argv[])
 				_("while zeroing block %llu at end of filesystem"),
 				ret_blk);
 		}
-		write_inode_tables(fs, lazy_itable_init);
+		write_inode_tables(fs, lazy_itable_init, lazy_itable_zeroed);
 		create_root_dir(fs);
 		create_lost_and_found(fs);
 		reserve_inodes(fs);

