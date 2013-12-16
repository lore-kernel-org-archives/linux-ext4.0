From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 1/4] e2image: add offset switches
Date: Mon, 16 Dec 2013 11:32:39 -0500
Message-ID: <1387211559-25743-1-git-send-email-psusi@ubuntu.com>
References: <52AF2A8E.8030207@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: ttytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:35651 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPQmK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 11:42:10 -0500
In-Reply-To: <52AF2A8E.8030207@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add -o and -O switches to specify the offset where the source
and destination filesystems start.  This is useful if you have
an image of a partitioned disk or wish to create one.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.8.in | 36 ++++++++++++++++++++++++++++++++++++
 misc/e2image.c    | 30 ++++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 84b9729..86d3dfc 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -10,6 +10,14 @@ e2image \- Save critical ext2/ext3/ext4 filesystem metadata to a file
 [
 .B \-rsIQa
 ]
+[
+.B \-o
+.I source_offset
+]
+[
+.B \-O
+.I dest_offset
+]
 .I device
 .I image-file
 .SH DESCRIPTION
@@ -191,6 +199,34 @@ give an image that is suitable to use to clone the entire FS or
 for backup purposes.  Note that this option only works with the
 raw or QCOW2 formats.
 .PP
+.SH OFFSETS
+Normally a filesystem starts at the beginning of a partition, and
+.B e2image
+is run on the partition.  When working with image files, you don't
+have the option of using the partition device, so you can specify
+the offset where the filesystem starts directly with the
+.B \-o
+option.  Similarly the
+.B \-O
+option specifies the offset that should be seeked to in the destination
+before writing the filesystem.
+.PP
+For example, if you have a
+.B dd
+image of a whole hard drive that contains an ext2 fs in a partition
+starting at 1 MiB, you can clone that fs with:
+.PP
+.br
+\	\fBe2image \-aro 1048576 img /dev/sda1\fR
+.br
+.PP
+Or you can clone a fs into an image file, leaving room in the first
+MiB for a partition table with:
+.PP
+.br
+\	\fBe2image -arO 1048576 /dev/sda1 img\fR
+.br
+.PP
 .SH AUTHOR
 .B e2image
 was written by Theodore Ts'o (tytso@mit.edu).
diff --git a/misc/e2image.c b/misc/e2image.c
index 885a794..f7f2e90 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -55,6 +55,7 @@ char * device_name = NULL;
 char all_data;
 char output_is_blk;
 /* writing to blk device: don't skip zeroed blocks */
+blk64_t source_offset, dest_offset;
 
 static void lseek_error_and_exit(int errnum)
 {
@@ -87,7 +88,7 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-rsIQa] device image_file\n"),
+	fprintf(stderr, _("Usage: %s [-rsIQa] [-o source_offset] [-O dest_offset] device image_file\n"),
 		program_name);
 	exit (1);
 }
@@ -1269,7 +1270,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "rsIQa")) != EOF)
+	while ((c = getopt(argc, argv, "rsIQao:O:")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1290,6 +1291,12 @@ int main (int argc, char ** argv)
 		case 'a':
 			all_data = 1;
 			break;
+		case 'o':
+			source_offset = strtoull(optarg, NULL, 0);
+			break;
+		case 'O':
+			dest_offset = strtoull(optarg, NULL, 0);
+			break;
 		default:
 			usage();
 		}
@@ -1301,7 +1308,11 @@ int main (int argc, char ** argv)
 					 "with raw or QCOW2 images.");
 		exit(1);
 	}
-
+	if ((source_offset || dest_offset) && img_type != E2IMAGE_RAW) {
+		com_err(program_name, 0,
+			"Offsets are only allowed with raw images.");
+		exit(1);
+	}
 	device_name = argv[optind];
 	image_fn = argv[optind+1];
 
@@ -1317,9 +1328,11 @@ int main (int argc, char ** argv)
 			goto skip_device;
 		}
 	}
-
-	retval = ext2fs_open (device_name, open_flag, 0, 0,
-			      unix_io_manager, &fs);
+	char *options;
+	asprintf (&options, "offset=%llu", source_offset);
+	retval = ext2fs_open2 (device_name, options, open_flag, 0, 0,
+			       unix_io_manager, &fs);
+	free (options);
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
@@ -1338,6 +1351,11 @@ skip_device:
 			exit(1);
 		}
 	}
+	if (dest_offset)
+		if (ext2fs_llseek (fd, dest_offset, SEEK_SET) < 0) {
+			perror("ext2fs_llseek");
+			exit(1);
+		}
 
 	if ((img_type & E2IMAGE_QCOW2) && (fd == 1)) {
 		com_err(program_name, 0, "QCOW2 image can not be written to "
-- 
1.8.3.2

