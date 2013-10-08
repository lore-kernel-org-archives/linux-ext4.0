From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/4] e2image: perform in-place move
Date: Tue,  8 Oct 2013 11:56:30 -0400
Message-ID: <1381247792-22508-3-git-send-email-psusi@ubuntu.com>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:47917 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3JHP4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Oct 2013 11:56:34 -0400
In-Reply-To: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If given at least one offset and only one file, assume source
and dest are the same, and do an in place move.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.8.in |  3 +++
 misc/e2image.c    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 86d3dfc..3d3aa18 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -227,6 +227,9 @@ MiB for a partition table with:
 \	\fBe2image -arO 1048576 /dev/sda1 img\fR
 .br
 .PP
+If you specify at least one offset, and only one file, an in-place
+move will be performed, allowing you to safely move the filesystem
+from one offset to another.
 .SH AUTHOR
 .B e2image
 was written by Theodore Ts'o (tytso@mit.edu).
diff --git a/misc/e2image.c b/misc/e2image.c
index cf486c0..2557eef 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -56,6 +56,7 @@ char all_data;
 char output_is_blk;
 /* writing to blk device: don't skip zeroed blocks */
 blk64_t source_offset, dest_offset;
+char move_mode;
 
 static void lseek_error_and_exit(int errnum)
 {
@@ -488,6 +489,9 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 	blk64_t		blk;
 	char		*buf, *zero_buf;
 	int		sparse = 0;
+	blk64_t		start = 0;
+	blk64_t		distance = 0;
+	blk64_t		end = ext2fs_blocks_count(fs->super);
 
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval) {
@@ -499,7 +503,19 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 		com_err(program_name, retval, "while allocating buffer");
 		exit(1);
 	}
-	for (blk = 0; blk < ext2fs_blocks_count(fs->super); blk++) {
+	/* when doing an in place move to the right, you can't start
+	   at the beginning or you will overwrite data, so instead
+	   divide the fs up into distance size chunks and write them
+	   in reverse. */
+	if (move_mode && dest_offset > source_offset) {
+		distance = (dest_offset - source_offset) / fs->blocksize;
+		if (distance < ext2fs_blocks_count(fs->super))
+			start = ext2fs_blocks_count(fs->super) - distance;
+	}
+more_blocks:
+	if (distance)
+		ext2fs_llseek (fd, (start * fs->blocksize) + dest_offset, SEEK_SET);
+	for (blk = start; blk < end; blk++) {
 		if ((blk >= fs->super->s_first_data_block) &&
 		    ext2fs_test_block_bitmap2(meta_block_map, blk)) {
 			retval = io_channel_read_blk64(fs->io, blk, 1, buf);
@@ -528,9 +544,31 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 			}
 		}
 	}
+	if (distance && start) {
+		if (start < distance) {
+			end = start;
+			start = 0;
+		} else {
+			end -= distance;
+			start -= distance;
+			if (end < distance) {
+				/* past overlap, do rest in one go */
+				end = start;
+				start = 0;
+			}
+		}
+		sparse = 0;
+		goto more_blocks;
+	}
 #ifdef HAVE_FTRUNCATE64
 	if (sparse) {
-		ext2_loff_t offset = ext2fs_llseek(fd, sparse, SEEK_CUR);
+		ext2_loff_t offset;
+		if (distance)
+			offset = ext2fs_llseek(
+				fd,
+				fs->blocksize * ext2fs_blocks_count(fs->super) + dest_offset,
+				SEEK_SET);
+		else offset = ext2fs_llseek(fd, sparse, SEEK_CUR);
 
 		if (offset < 0)
 			lseek_error_and_exit(errno);
@@ -538,7 +576,7 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 			write_block(fd, zero_buf, -1, 1, -1);
 	}
 #else
-	if (sparse)
+	if (sparse && !distance)
 		write_block(fd, zero_buf, sparse-1, 1, -1);
 #endif
 	ext2fs_free_mem(&zero_buf);
@@ -1300,7 +1338,10 @@ int main (int argc, char ** argv)
 		default:
 			usage();
 		}
-	if (optind != argc - 2 )
+	if (optind == argc - 1 &&
+	    (source_offset || dest_offset))
+		    move_mode = 1;
+	else if (optind != argc - 2 )
 		usage();
 
 	if (all_data && !img_type) {
@@ -1310,7 +1351,9 @@ int main (int argc, char ** argv)
 	}
 
 	device_name = argv[optind];
-	image_fn = argv[optind+1];
+	if (move_mode)
+		image_fn = device_name;
+	else image_fn = argv[optind+1];
 
 	if (flags & E2IMAGE_INSTALL_FLAG) {
 		install_image(device_name, image_fn, img_type);
@@ -1340,10 +1383,10 @@ skip_device:
 	if (strcmp(image_fn, "-") == 0)
 		fd = 1;
 	else {
-		fd = ext2fs_open_file(image_fn, O_CREAT|O_TRUNC|O_WRONLY, 0600);
+		fd = ext2fs_open_file(image_fn, O_CREAT|O_WRONLY, 0600);
 		if (fd < 0) {
 			com_err(program_name, errno,
-				_("while trying to open %s"), argv[optind+1]);
+				_("while trying to open %s"), image_fn);
 			exit(1);
 		}
 	}
-- 
1.8.1.2

