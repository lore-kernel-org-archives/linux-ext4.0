From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] e2fsprogs: Make mke2fs use undo I/O manager.
Date: Wed,  1 Aug 2007 21:04:10 +0530
Message-ID: <11859825351217-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859824581652-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859825032637-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:52601 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXHAPhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 11:37:11 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l71FdlaP5312708
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:39:48 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l71FZ3Ol080858
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:35:04 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l71FZopE014549
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:35:51 +1000
In-Reply-To: <11859825032637-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <54cb90cb47293e41d0b1dd1b36b1edead8960563.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
References: <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When running mke2fs, if a file system is detected
on the device, we use Undo I/O manager as the io manager.
This helps in reverting the changes made to the filesystem
in case we wrongly selected the device.

The environment variable MKE2FS_SCRATCH_DIR
is used to indicate the  directory within which the tdb
file need to be created. The file will be named mke2fs-XXXXXX
If MKE2FS_SCRATCH_DIR is not set /var/lib/e2fsprogs is used


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/mke2fs.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0c6d4f3..3ff4b90 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -44,6 +44,7 @@ extern int optind;
 #endif
 #include <sys/ioctl.h>
 #include <sys/types.h>
+#include <libgen.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "et/com_err.h"
@@ -1521,6 +1522,102 @@ static void PRS(int argc, char *argv[])
 						fs_param.s_blocks_count);
 }
 
+static int filesystem_exist(const char *name)
+{
+	errcode_t retval;
+	io_channel channel;
+	__u16	s_magic;
+	struct ext2_super_block super;
+	io_manager manager = unix_io_manager;
+
+	retval = manager->open(name, IO_FLAG_EXCLUSIVE,  &channel);
+	if (retval) {
+		/*
+		 * We don't handle error cases instead we
+		 * declare that the file system doesn't exist
+		 * and let the rest of mke2fs take care of
+		 * error
+		 */
+		retval = 0;
+		goto open_err_out;
+	}
+
+	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
+	retval = io_channel_read_blk(channel, 1, -SUPERBLOCK_SIZE, &super);
+	if (retval) {
+		retval = 0;
+		goto err_out;
+	}
+
+#if defined(WORDS_BIGENDIAN)
+	s_magic = ext2fs_swab16(super.s_magic);
+#else
+	s_magic = super.s_magic;
+#endif
+
+	if (s_magic == EXT2_SUPER_MAGIC)
+		retval = 1;
+
+err_out:
+	io_channel_close(channel);
+
+open_err_out:
+
+	return retval;
+}
+
+static int mke2fs_setup_tdb(const char *name)
+{
+	errcode_t retval = 0;
+	char *tdb_dir, tdb_file[PATH_MAX];
+	char *device_name, *tmp_name;
+
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+			"directory", 0, 0,
+			&tdb_dir);
+#endif
+	tmp_name = strdup(name);
+	device_name = basename(tmp_name);
+
+	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
+	if (!tdb_dir) {
+		printf(_("MKE2FS_SCRATCH_DIR not configured\n"));
+		printf(_("Using /var/lib/e2fsprogs\n"));
+		tdb_dir="/var/lib/e2fsprogs";
+	}
+	if (access(tdb_dir, W_OK)) {
+		fprintf(stderr,
+			_("Cannot create file under %s\n"),
+			tdb_dir);
+		retval = EXT2_ET_INVALID_ARGUMENT;
+		goto err_out;
+
+	}
+
+	sprintf(tdb_file, "%s/mke2fs-%s", tdb_dir, device_name);
+
+	if (!access(tdb_file, F_OK)) {
+		fprintf(stderr,
+			_("File exist %s\n"), tdb_file);
+		retval = EXT2_ET_INVALID_ARGUMENT;
+		goto err_out;
+	}
+
+	set_undo_io_backup_file(tdb_file);
+	printf(_("previous filesystem detected; to undo "
+		"the mke2fs operation, please run the "
+		"command \n'undoe2fs %s %s' in order to recover\n\n"),
+		tdb_file, name);
+err_out:
+	free(tmp_name);
+	return retval;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1543,7 +1640,17 @@ int main (int argc, char *argv[])
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	io_ptr = unix_io_manager;
+	if (filesystem_exist(device_name)) {
+
+		io_ptr = undo_io_manager;
+		set_undo_io_backing_manager(unix_io_manager);
+		retval = mke2fs_setup_tdb(device_name);
+		if (retval)
+			exit(1);
+
+	} else {
+		io_ptr = unix_io_manager;
+	}
 #endif
 
 	/*
-- 
1.5.3.rc2.22.g69a9b-dirty
