From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 2/4] e2image: add -b option to use supperblock backup
Date: Thu, 16 Nov 2017 16:55:44 +0300
Message-ID: <20171116135546.9991-3-artem.blagodarenko@gmail.com>
References: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:46718 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758978AbdKPNzz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Nov 2017 08:55:55 -0500
Received: by mail-lf0-f65.google.com with SMTP id k66so18212165lfg.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2017 05:55:54 -0800 (PST)
In-Reply-To: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

e2image has no ability to use superblock backup to copy metadata.
This feature can be useful if someone wants to make partition
image and fix it using e2fsck utility.

New -b option allows to pass superblock number, like e2fsck utility do.
e2image doesn't change primary superblock and store is as is, so
it can be fixed using e2fsck latter.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 lib/ext2fs/ext2fs.h |  4 ----
 misc/e2image.c      | 44 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c394ec80..6774e32c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1588,10 +1588,6 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock,
 			      unsigned int block_size, io_manager manager,
 			      ext2_filsys *ret_fs);
-extern errcode_t ext2fs_try_open_fs(char *filesystem_name, char *io_options,
-			     blk64_t superblock, int blocksize, int flags,
-			     io_manager io_ptr, ext2_filsys *ret_fs);
-
 /*
  * The dgrp_t argument to these two functions is not actually a group number
  * but a block number offset within a group table!  Convert with the formula
diff --git a/misc/e2image.c b/misc/e2image.c
index be001f0f..756a1dbc 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -104,7 +104,8 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -fr ] device image-file\n"),
+	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -b superblock ] [ -B blocksize]"
+			  "[ -fr ] device image-file\n"),
 		program_name);
 	fprintf(stderr, _("       %s -I device image-file\n"), program_name);
 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] "
@@ -1256,7 +1257,8 @@ static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 	free_qcow2_image(img);
 }
 
-static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
+static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags,
+				 blk64_t superblock)
 {
 	struct process_block_struct	pb;
 	struct ext2_inode		inode;
@@ -1284,6 +1286,22 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 		}
 	}
 
+	if (superblock) {
+		int j;
+
+		ext2fs_mark_block_bitmap2(meta_block_map, superblock);
+		meta_blocks_count++;
+
+		/*
+		 * Mark the backup superblock descriptors
+		 */
+		for (j = 0; j < fs->desc_blocks; j++) {
+			ext2fs_mark_block_bitmap2(meta_block_map,
+			ext2fs_descriptor_block_loc2(fs, superblock, j));
+		}
+		meta_blocks_count += fs->desc_blocks;
+	}
+
 	mark_table_blocks(fs);
 	if (show_progress)
 		fprintf(stderr, "%s", _("Scanning inodes...\n"));
@@ -1463,6 +1481,8 @@ int main (int argc, char ** argv)
 	int ignore_rw_mount = 0;
 	int check = 0;
 	struct stat st;
+	blk64_t superblock = 0;
+	int blocksize = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1476,7 +1496,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "nrsIQafo:O:pc")) != EOF)
+	while ((c = getopt(argc, argv, "nrsIQafo:O:pcb:B:")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1515,6 +1535,12 @@ int main (int argc, char ** argv)
 		case 'c':
 			check = 1;
 			break;
+		case 'b':
+			superblock = strtoull(optarg, NULL, 0);
+			break;
+		case 'B':
+			blocksize = strtoul(optarg, NULL, 0);
+			break;
 		default:
 			usage();
 		}
@@ -1529,6 +1555,11 @@ int main (int argc, char ** argv)
 						 "with raw or QCOW2 images."));
 		exit(1);
 	}
+	if (superblock && !img_type) {
+		com_err(program_name, 0, "%s", _("-b option can only be used "
+						 "with raw or QCOW2 images."));
+		exit(1);
+	}
 	if ((source_offset || dest_offset) && img_type != E2IMAGE_RAW) {
 		com_err(program_name, 0, "%s",
 			_("Offsets are only allowed with raw images."));
@@ -1579,8 +1610,9 @@ int main (int argc, char ** argv)
 		}
 	}
 	sprintf(offset_opt, "offset=%llu", source_offset);
-	retval = ext2fs_open2(device_name, offset_opt, open_flag, 0, 0,
-			      unix_io_manager, &fs);
+	retval = ext2fs_open2(device_name, offset_opt, open_flag,
+				    superblock, blocksize, unix_io_manager,
+				    &fs);
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
@@ -1665,7 +1697,7 @@ skip_device:
 		exit(1);
 	}
 	if (img_type)
-		write_raw_image_file(fs, fd, img_type, flags);
+		write_raw_image_file(fs, fd, img_type, flags, superblock);
 	else
 		write_image_file(fs, fd);
 
-- 
2.13.6 (Apple Git-96)
