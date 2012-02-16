From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/2] e2image: add -a switch to include all data
Date: Thu, 16 Feb 2012 16:35:12 -0500
Message-ID: <1329428112-8911-2-git-send-email-psusi@ubuntu.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:50780 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2BPVnD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 16:43:03 -0500
In-Reply-To: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Normally the raw and QCOW2 images only contain fs metadata.
Add a new switch ( -a ) to include all data.  This makes it
possible to use e2image to clone a whole filesystem.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.8.in |   21 ++++++++++++++++++++-
 misc/e2image.c    |   12 ++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 74d2a0b..b76dbe8 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -8,7 +8,7 @@ e2image \- Save critical ext2/ext3/ext4 filesystem metadata to a file
 .SH SYNOPSIS
 .B e2image
 [
-.B \-rsI
+.B \-rsIQa
 ]
 .I device
 .I image-file
@@ -171,6 +171,25 @@ is regular QCOW2 image and can be processed by tools aware of QCOW2 format
 such as for example
 .BR qemu-img .
 .PP
+You can convert a qcow2 image into a raw image with:
+.PP
+.br
+\	\fBe2image \-r hda1.qcow2 hda1.raw\fR
+.br
+.PP
+This can be useful to write a qcow2 image containing all data to a
+sparse image file where it can be loop mounted, or to a disk partition
+.PP
+.SH INCLUDING DATA
+Normally
+.B e2image
+only includes fs metadata, not regular file data.  The 
+.B \-a
+option can be specified to include all data.  This will
+give an image that is suitible to use to clone the entire FS or
+for backup purposes.  Note that this option only works with the
+raw or QCOW2 formats.
+.PP
 .SH AUTHOR
 .B e2image 
 was written by Theodore Ts'o (tytso@mit.edu).
diff --git a/misc/e2image.c b/misc/e2image.c
index 722737c..b8f10a1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -52,6 +52,7 @@ extern int optind;
 
 const char * program_name = "e2image";
 char * device_name = NULL;
+char all_data;
 
 static void lseek_error_and_exit(int errnum)
 {
@@ -84,7 +85,7 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-rsIQ] device image_file\n"),
+	fprintf(stderr, _("Usage: %s [-rsIQa] device image_file\n"),
 		program_name);
 	exit (1);
 }
@@ -309,7 +310,7 @@ static int process_file_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 			      int ref_offset EXT2FS_ATTR((unused)),
 			      void *priv_data EXT2FS_ATTR((unused)))
 {
-	if (blockcnt < 0) {
+	if (blockcnt < 0 || all_data) {
 		ext2fs_mark_block_bitmap2(meta_block_map, *block_nr);
 		meta_blocks_count++;
 	}
@@ -1114,7 +1115,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 			if ((inode.i_flags & EXT4_EXTENTS_FL) ||
 			    inode.i_block[EXT2_IND_BLOCK] ||
 			    inode.i_block[EXT2_DIND_BLOCK] ||
-			    inode.i_block[EXT2_TIND_BLOCK]) {
+			    inode.i_block[EXT2_TIND_BLOCK] || all_data) {
 				retval = ext2fs_block_iterate3(fs,
 				       ino, BLOCK_FLAG_READ_ONLY, block_buf,
 				       process_file_block, &pb);
@@ -1242,7 +1243,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "rsIQ")) != EOF)
+	while ((c = getopt(argc, argv, "rsIQa")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1260,6 +1261,9 @@ int main (int argc, char ** argv)
 		case 's':
 			flags |= E2IMAGE_SCRAMBLE_FLAG;
 			break;
+		case 'a':
+			all_data = 1;
+			break;
 		default:
 			usage();
 		}
-- 
1.7.5.4

