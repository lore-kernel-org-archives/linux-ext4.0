From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 2/4] e2image: add -b option to use supperblock backup
Date: Mon, 26 Jun 2017 19:58:44 +0300
Message-ID: <1498496326-76684-3-git-send-email-artem.blagodarenko@gmail.com>
References: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: alexey.lyashkov@gmail.com, artem.blagodarenko@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36195 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbdGDM2N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jul 2017 08:28:13 -0400
Received: by mail-lf0-f68.google.com with SMTP id f28so17636430lfi.3
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jul 2017 05:28:13 -0700 (PDT)
In-Reply-To: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

e2image has no ability to use superblock backup to copy metadata.
This feature can be useful if someone wants to make partition
image and fix it using e2fsck utility.

New -b option allows to pass superblock number, like e2fsck utility do.
e2image doesn't change primary superblock and store is as is, so
it can be fixed using e2fsck latter.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 misc/e2image.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index e0c3188..acc27d1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -103,7 +103,8 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -fr ] device image-file\n"),
+	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -b superblock ] "
+			  "[ -fr ] device image-file\n"),
 		program_name);
 	fprintf(stderr, _("       %s -I device image-file\n"), program_name);
 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] "
@@ -1255,7 +1256,7 @@ static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 	free_qcow2_image(img);
 }
 
-static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
+static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags, blk64_t superblock)
 {
 	struct process_block_struct	pb;
 	struct ext2_inode		inode;
@@ -1283,6 +1284,22 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
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
@@ -1462,6 +1479,7 @@ int main (int argc, char ** argv)
 	int ignore_rw_mount = 0;
 	int check = 0;
 	struct stat st;
+	blk64_t superblock = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1475,7 +1493,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "nrsIQafo:O:pc")) != EOF)
+	while ((c = getopt(argc, argv, "nrsIQafo:O:pcb:")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1514,6 +1532,9 @@ int main (int argc, char ** argv)
 		case 'c':
 			check = 1;
 			break;
+		case 'b':
+			superblock = strtoull(optarg, NULL, 0);
+			break;
 		default:
 			usage();
 		}
@@ -1528,6 +1549,11 @@ int main (int argc, char ** argv)
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
@@ -1578,8 +1604,8 @@ int main (int argc, char ** argv)
 		}
 	}
 	sprintf(offset_opt, "offset=%llu", source_offset);
-	retval = ext2fs_open2(device_name, offset_opt, open_flag, 0, 0,
-			      unix_io_manager, &fs);
+	retval = ext2fs_try_open_fs(device_name, offset_opt, superblock, 0,
+				    open_flag, unix_io_manager, &fs);
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
@@ -1664,7 +1690,7 @@ skip_device:
 		exit(1);
 	}
 	if (img_type)
-		write_raw_image_file(fs, fd, img_type, flags);
+		write_raw_image_file(fs, fd, img_type, flags, superblock);
 	else
 		write_image_file(fs, fd);
 
-- 
1.7.1
