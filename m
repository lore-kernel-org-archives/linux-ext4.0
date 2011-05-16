From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3 v2] e2image: Support for conversion QCOW2 image into raw
Date: Mon, 16 May 2011 17:43:23 +0200
Message-ID: <1305560604-31877-3-git-send-email-lczerner@redhat.com>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab1EPPnj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:43:39 -0400
In-Reply-To: <1305560604-31877-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds support for converting QCOW2 image created previously
with e2image into raw image. The QCOW2 image is detected automatically,
so there is not new option. Just use following command:

  e2image -r image.qcow image.raw

No that this tool is aimed to quickly convert qcow2 image created with
e2image into raw image. In order to improve speed we are doing some
assumption I believe might not be true for regular qcow2 images. So it
was not tested with regular QCOW2 images and it might not work with
them. The intention of this tool is only convert images previously
created by e2image.

Note that there is nothing special with QCOW2 images created by e2images
and it can be used with tools like qemu-img, or qemu-nbd without any
problems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/qcow2.c |    3 ++-
 misc/e2image.8.in  |    4 ++++
 misc/e2image.c     |   43 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
index 17eab38..9ac050b 100644
--- a/lib/ext2fs/qcow2.c
+++ b/lib/ext2fs/qcow2.c
@@ -209,9 +209,10 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
 	}
 
 	/* Resize the output image to the filesystem size */
-	if (lseek(raw_fd, img.image_size, SEEK_SET) < 0)
+	if (lseek(raw_fd, img.image_size - 1, SEEK_SET) < 0)
 		return errno;
 
+	memset(copy_buf, 0, 1);
 	size = write(raw_fd, copy_buf, 1);
 	if (size != 1)
 		return errno;
diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 4a28580..6f31dd1 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -131,6 +131,10 @@ the
 option will prevent analysis of problems related to hash-tree indexed
 directories.
 .PP
+Note that this will work even if you substitute "/dev/hda1" for another raw
+disk image, or QCOW2 image previously created by
+.BR e2image .
+.PP
 .SH QCOW2 IMAGE FILES
 The 
 .B \-Q
diff --git a/misc/e2image.c b/misc/e2image.c
index 6dc78d3..d749981 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1229,16 +1229,33 @@ static void install_image(char *device, char *image_fn, int type)
 	exit (0);
 }
 
+static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
+{
+
+#ifdef HAVE_OPEN64
+	*fd = open64(name, O_RDONLY, 0600);
+#else
+	*fd = open(name, O_RDONLY, 0600);
+#endif
+	if (*fd < 0)
+		return NULL;
+
+	return qcow2_read_header(*fd, name);
+}
+
 int main (int argc, char ** argv)
 {
 	int c;
 	errcode_t retval;
 	ext2_filsys fs;
 	char *image_fn;
+	struct ext2_qcow2_hdr *header = NULL;
 	int open_flag = EXT2_FLAG_64BITS;
 	int img_type = 0;
 	int flags = 0;
+	int qcow2_fd = 0;
 	int fd = 0;
+	int ret = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1282,6 +1299,14 @@ int main (int argc, char ** argv)
 		exit (0);
 	}
 
+	if (img_type & IMAGE_RAW) {
+		header = check_qcow2_image(&qcow2_fd, device_name);
+		if (header) {
+			flags |= IS_QCOW2_FLAG;
+			goto skip_device;
+		}
+	}
+
 	retval = ext2fs_open (device_name, open_flag, 0, 0,
 			      unix_io_manager, &fs);
         if (retval) {
@@ -1291,6 +1316,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
+skip_device:
 	if (strcmp(image_fn, "-") == 0)
 		fd = 1;
 	else {
@@ -1306,6 +1332,16 @@ int main (int argc, char ** argv)
 		}
 	}
 
+	if (flags & IS_QCOW2_FLAG) {
+		ret = qcow2_write_raw_image(qcow2_fd, fd, header);
+		if (ret)
+			com_err(program_name, errno,
+				_("while trying to convert qcow2 image"
+				  " (%s) into raw image (%s)"),
+				  device_name, image_fn);
+		goto out;
+	}
+
 	if ((img_type & IMAGE_QCOW2) && (fd == 1)) {
 		com_err(program_name, 0, "QCOW2 image can not be written to "
 					 "the stdout!\n");
@@ -1318,6 +1354,11 @@ int main (int argc, char ** argv)
 		write_image_file(fs, fd);
 
 	ext2fs_close (fs);
+out:
+	if (header)
+		free(header);
+	if (qcow2_fd)
+		close(qcow2_fd);
 	remove_error_table(&et_ext2_error_table);
-	exit (0);
+	return ret;
 }
-- 
1.7.4.4

