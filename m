From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] e2image: Print a warning if running over a mounted filesystem
Date: Thu, 26 Sep 2013 18:00:04 -0300
Message-ID: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3IZVmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Sep 2013 17:42:04 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8QLg3PT011837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Sep 2013 17:42:03 -0400
Received: from orion.redhat.com (ovpn-113-161.phx2.redhat.com [10.3.113.161])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8QL08fW028697
	for <linux-ext4@vger.kernel.org>; Thu, 26 Sep 2013 17:00:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several users use to run e2image over a mounted filesystem, providing
inconsistent, useless e2images.
This patch adds a warning in such cases, notifying the user and also adds a
force option making e2image able to run over Read-only filesystems.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 misc/Makefile.in |  2 +-
 misc/e2image.c   | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 8a69855..2e20b25 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -49,7 +49,7 @@ UUIDGEN_OBJS=	uuidgen.o
 UUIDD_OBJS=	uuidd.o
 DUMPE2FS_OBJS=	dumpe2fs.o
 BADBLOCKS_OBJS=	badblocks.o
-E2IMAGE_OBJS=	e2image.o
+E2IMAGE_OBJS=	e2image.o ismounted.o
 FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
diff --git a/misc/e2image.c b/misc/e2image.c
index 885a794..6f6329a 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -49,6 +49,8 @@ extern int optind;
 
 #define QCOW_OFLAG_COPIED     (1LL << 63)
 
+/* ismounted.h */
+extern int is_mounted(const char *file);
 
 const char * program_name = "e2image";
 char * device_name = NULL;
@@ -87,7 +89,7 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-rsIQa] device image_file\n"),
+	fprintf(stderr, _("Usage: %s [-rsIQaf] device image_file\n"),
 		program_name);
 	exit (1);
 }
@@ -1255,6 +1257,7 @@ int main (int argc, char ** argv)
 	int qcow2_fd = 0;
 	int fd = 0;
 	int ret = 0;
+	int ignore_mounted = 0;
 	struct stat st;
 
 #ifdef ENABLE_NLS
@@ -1269,7 +1272,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "rsIQa")) != EOF)
+	while ((c = getopt(argc, argv, "rsIQaf")) != EOF)
 		switch (c) {
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
@@ -1290,6 +1293,9 @@ int main (int argc, char ** argv)
 		case 'a':
 			all_data = 1;
 			break;
+		case 'f':
+			ignore_mounted = 1;
+			break;
 		default:
 			usage();
 		}
@@ -1305,6 +1311,14 @@ int main (int argc, char ** argv)
 	device_name = argv[optind];
 	image_fn = argv[optind+1];
 
+	if (is_mounted(device_name) && !ignore_mounted) {
+		fprintf(stderr, "\nWarning: Running e2image on a mounted "
+				"filesystem can result in an inconsistent "
+				"image which will not be useful. Use -f "
+				"option if you really want to do that.\n");
+		exit(1);
+	}
+
 	if (flags & E2IMAGE_INSTALL_FLAG) {
 		install_image(device_name, image_fn, img_type);
 		exit (0);
-- 
1.8.1.4

