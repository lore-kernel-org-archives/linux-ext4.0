From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 2/13] Miscellaneous Cleanups
Date: Tue, 24 Jul 2007 16:34:41 +0530
Message-ID: <1185275081.3789.67.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40550 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765525AbXGXLDw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:03:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Miscellaneous cleanups.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>

Index: e2fsprogs-1.40.1/Makefile.in
===================================================================
--- e2fsprogs-1.40.1.orig/Makefile.in
+++ e2fsprogs-1.40.1/Makefile.in
@@ -10,7 +10,7 @@ INSTALL = @INSTALL@
 @RESIZER_CMT@RESIZE_DIR= resize
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
 
-LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/ext2fs lib/uuid lib/blkid intl
+LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/uuid lib/ext2fs lib/blkid intl
 PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
Index: e2fsprogs-1.40.1/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.40.1.orig/debugfs/set_fields.c
+++ e2fsprogs-1.40.1/debugfs/set_fields.c
@@ -22,6 +22,9 @@
 #ifdef HAVE_ERRNO_H
 #include <errno.h>
 #endif
+#if HAVE_STRINGS_H
+# include <strings.h>
+#endif
 #include <fcntl.h>
 #include <utime.h>
 
Index: e2fsprogs-1.40.1/lib/blkid/getsize.c
===================================================================
--- e2fsprogs-1.40.1.orig/lib/blkid/getsize.c
+++ e2fsprogs-1.40.1/lib/blkid/getsize.c
@@ -186,7 +186,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
 #ifdef TEST_PROGRAM
 int main(int argc, char **argv)
 {
-	blkid_loff_t bytes;
+	long long bytes;
 	int	fd;
 
 	if (argc < 2) {
