From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] e2fsprogs: Make mke2fs use undo I/O manager.
Date: Wed,  1 Aug 2007 07:34:08 +0530
Message-ID: <11859338623488-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11859338491592-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859338581413-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:59525 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbXHACE1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2007 22:04:27 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7126Xae2109534
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:06:33 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7123cXZ243676
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:03:38 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7124PIP008701
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:04:25 +1000
In-Reply-To: <11859338581413-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <70b3f394cda275d59094d52f60d1ee76492033fc.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
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
 misc/mke2fs.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0c6d4f3..5e02b2e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1521,6 +1521,92 @@ static void PRS(int argc, char *argv[])
 						fs_param.s_blocks_count);
 }
 
+static int fileystem_exist(const char *name)
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
+	char *tdb_dir, tdb_file[PATH_MAX];
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+					"directory", 0, 0,
+					&tdb_dir);
+#endif
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
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	}
+
+	/* FIXME!! Should we generate Unique file name ?? */
+	sprintf(tdb_file, "%s/mke2fs-XXXXXX", tdb_dir);
+
+	if (!access(tdb_file, F_OK)) {
+		fprintf(stderr,
+			_("File exist %s\n"), tdb_file);
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+
+	set_undo_io_backup_file(tdb_file);
+	printf(_("previous filesystem detected; to undo "
+		 "the mke2fs operation, please run the "
+		 "command \n'undoe2fs %s %s' in order to recover\n\n"),
+		  tdb_file, name);
+	return 0;
+}
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1543,7 +1629,17 @@ int main (int argc, char *argv[])
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	io_ptr = unix_io_manager;
+	if (fileystem_exist(device_name)) {
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
