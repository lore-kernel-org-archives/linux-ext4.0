From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 3/4] e2image: add progress indicator
Date: Tue,  8 Oct 2013 11:56:31 -0400
Message-ID: <1381247792-22508-4-git-send-email-psusi@ubuntu.com>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:47919 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3JHP4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Oct 2013 11:56:34 -0400
In-Reply-To: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When given the -p switch, print progress information, including
block counts, percentage complete, estimated time remaining, and
throughput.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.8.in |  6 +++--
 misc/e2image.c    | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 3d3aa18..e5f2f04 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -8,7 +8,7 @@ e2image \- Save critical ext2/ext3/ext4 filesystem metadata to a file
 .SH SYNOPSIS
 .B e2image
 [
-.B \-rsIQa
+.B \-rsIQap
 ]
 [
 .B \-o
@@ -197,7 +197,9 @@ only includes fs metadata, not regular file data.  The
 option can be specified to include all data.  This will
 give an image that is suitable to use to clone the entire FS or
 for backup purposes.  Note that this option only works with the
-raw or QCOW2 formats.
+raw or QCOW2 formats.  The
+.B \-p
+switch may be given to show progress.
 .PP
 .SH OFFSETS
 Normally a filesystem starts at the beginning of a partition, and
diff --git a/misc/e2image.c b/misc/e2image.c
index 2557eef..27be2b1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -57,6 +57,7 @@ char output_is_blk;
 /* writing to blk device: don't skip zeroed blocks */
 blk64_t source_offset, dest_offset;
 char move_mode;
+char show_progress;
 
 static void lseek_error_and_exit(int errnum)
 {
@@ -89,7 +90,7 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-rsIQa] [-o source_offset] [-O dest_offset] device image_file\n"),
+	fprintf(stderr, _("Usage: %s [-rsIQap] [-o source_offset] [-O dest_offset] device image_file\n"),
 		program_name);
 	exit (1);
 }
@@ -492,6 +493,10 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 	blk64_t		start = 0;
 	blk64_t		distance = 0;
 	blk64_t		end = ext2fs_blocks_count(fs->super);
+	time_t		last_update;
+	time_t		start_time;
+	blk64_t		total_written = 0;
+	int		bscount;
 
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval) {
@@ -503,6 +508,16 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 		com_err(program_name, retval, "while allocating buffer");
 		exit(1);
 	}
+	if (show_progress) {
+		printf("Copying ");
+		bscount = printf("%llu / %llu blocks (%llu%%)",
+				 total_written,
+				 meta_blocks_count,
+				 (total_written + 50) / ((meta_blocks_count + 50) / 100));
+		fflush(stdout);
+		last_update = time(NULL);
+		start_time = time(NULL);
+	}
 	/* when doing an in place move to the right, you can't start
 	   at the beginning or you will overwrite data, so instead
 	   divide the fs up into distance size chunks and write them
@@ -516,6 +531,30 @@ more_blocks:
 	if (distance)
 		ext2fs_llseek (fd, (start * fs->blocksize) + dest_offset, SEEK_SET);
 	for (blk = start; blk < end; blk++) {
+		if (show_progress && last_update != time(NULL)) {
+			last_update = time(NULL);
+			while (bscount--)
+				printf("\b");
+			bscount = printf("%llu / %llu blocks (%llu%%)",
+					 total_written,
+					 meta_blocks_count,
+					 (total_written + 50) /
+					 ((meta_blocks_count + 50) / 100));
+			time_t duration = time(NULL) - start_time;
+			if (duration > 5) {
+				time_t est = (duration *
+					      meta_blocks_count / total_written) -
+					(duration);
+				char buff[30];
+				strftime(buff, 30, "%T", gmtime(&est));
+				bscount += printf(" %s remaining at %.2f MB/s",
+						  buff,
+						  ((float)total_written /
+						   ((1024 * 1024) / fs->blocksize)) /
+						  duration);
+			}
+			fflush (stdout);
+		}
 		if ((blk >= fs->super->s_first_data_block) &&
 		    ext2fs_test_block_bitmap2(meta_block_map, blk)) {
 			retval = io_channel_read_blk64(fs->io, blk, 1, buf);
@@ -523,6 +562,7 @@ more_blocks:
 				com_err(program_name, retval,
 					"error reading block %llu", blk);
 			}
+			total_written++;
 			if (scramble_block_map &&
 			    ext2fs_test_block_bitmap2(scramble_block_map, blk))
 				scramble_dir_block(fs, blk, buf);
@@ -560,6 +600,23 @@ more_blocks:
 		sparse = 0;
 		goto more_blocks;
 	}
+	if (show_progress) {
+		while (bscount--)
+			printf("\b");
+		time_t duration = time(NULL) - start_time;
+		char buff[30];
+		strftime(buff, 30, "%T", gmtime(&duration));
+		printf("\b\b\b\b\b\b\b\bCopied %llu / %llu blocks (%llu%%) in "
+		       "%s at %.2f MB/s       \n",
+		       total_written,
+		       meta_blocks_count,
+		       (total_written + 50) / ((meta_blocks_count + 50) / 100),
+		       buff,
+		       ((float)total_written /
+			((1024 * 1024) / fs->blocksize)) /
+		       duration);
+
+	}
 #ifdef HAVE_FTRUNCATE64
 	if (sparse) {
 		ext2_loff_t offset;
@@ -1124,6 +1181,8 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 	}
 
 	mark_table_blocks(fs);
+	if (show_progress)
+		printf("Scanning inodes...\n");
 
 	retval = ext2fs_open_inode_scan(fs, 0, &scan);
 	if (retval) {
@@ -1308,7 +1367,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "rsIQao:O:")) != EOF)
+	while ((c = getopt(argc, argv, "rsIQao:O:p")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1335,6 +1394,9 @@ int main (int argc, char ** argv)
 		case 'O':
 			dest_offset = strtoull(optarg, NULL, 0);
 			break;
+		case 'p':
+			show_progress = 1;
+			break;
 		default:
 			usage();
 		}
-- 
1.8.1.2

