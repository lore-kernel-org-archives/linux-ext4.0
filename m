From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/31] resize2fs: optionally create undo file
Date: Sat, 20 Dec 2014 13:18:50 -0800
Message-ID: <20141220211850.25563.30486.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLTVSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:18:55 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide the user with an option to create an undo file so that they
can roll back a failed resize operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/main.c         |   97 +++++++++++++++++++++++++++++++++++++++++++++++--
 resize/resize2fs.8.in |   14 +++++++
 2 files changed, 108 insertions(+), 3 deletions(-)


diff --git a/resize/main.c b/resize/main.c
index c25de61..ea9a91b 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -29,6 +29,7 @@ extern int optind;
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <libgen.h>
 
 #include "e2p/e2p.h"
 
@@ -42,7 +43,8 @@ static char *device_name, *io_options;
 static void usage (char *prog)
 {
 	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
-			   "[-p] device [-b|-s|new_size]\n\n"), prog);
+			   "[-p] device [-b|-s|new_size] [-z undo_file]\n\n"),
+		 prog);
 
 	exit (1);
 }
@@ -162,6 +164,86 @@ static void bigalloc_check(ext2_filsys fs, int force)
 	}
 }
 
+static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
+			       io_manager *io_ptr)
+{
+	errcode_t retval = ENOMEM;
+	char *tdb_dir = NULL, *tdb_file = NULL;
+	char *dev_name, *tmp_name;
+	int free_tdb_dir = 0;
+
+	if (undo_file && undo_file[0] != 0) {
+		if ((unlink(undo_file) < 0) && (errno != ENOENT)) {
+			retval = errno;
+			goto err;
+		}
+
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		retval = set_undo_io_backup_file(undo_file);
+		if (retval)
+			goto err;
+		printf(_("Overwriting existing filesystem; this can be undone "
+			 "using the command:\n"
+			 "    e2undo %s %s\n\n"),
+			undo_file, device_name);
+		return 0;
+	}
+
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+
+	if (tdb_dir == NULL || !strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
+	    access(tdb_dir, W_OK)) {
+		if (free_tdb_dir)
+			free(tdb_dir);
+		return 0;
+	}
+
+	tmp_name = strdup(device_name);
+	if (!tmp_name)
+		goto errout;
+	dev_name = basename(tmp_name);
+	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
+	if (!tdb_file) {
+		free(tmp_name);
+		goto errout;
+	}
+	sprintf(tdb_file, "%s/resize2fs-%s.e2undo", tdb_dir, dev_name);
+	free(tmp_name);
+
+	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
+		retval = errno;
+		goto errout;
+	}
+
+	set_undo_io_backing_manager(*io_ptr);
+	*io_ptr = undo_io_manager;
+	retval = set_undo_io_backup_file(tdb_file);
+	if (retval)
+		goto errout;
+	printf(_("Overwriting existing filesystem; this can be undone "
+		 "using the command:\n"
+		 "    e2undo %s %s\n\n"), tdb_file, device_name);
+
+	if (free_tdb_dir)
+		free(tdb_dir);
+	free(tdb_file);
+	return 0;
+
+errout:
+	if (free_tdb_dir)
+		free(tdb_dir);
+	free(tdb_file);
+err:
+	com_err(program_name, retval, "%s",
+		_("while trying to setup undo file\n"));
+	return retval;
+}
+
 int main (int argc, char ** argv)
 {
 	errcode_t	retval;
@@ -186,7 +268,7 @@ int main (int argc, char ** argv)
 	unsigned int	blocksize;
 	long		sysval;
 	int		len, mount_flags;
-	char		*mtpt;
+	char		*mtpt, *undo_file = NULL;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -203,7 +285,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
+	while ((c = getopt(argc, argv, "d:fFhMPpS:bsz:")) != EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -235,6 +317,9 @@ int main (int argc, char ** argv)
 		case 's':
 			flags |= RESIZE_DISABLE_64BIT;
 			break;
+		case 'z':
+			undo_file = optarg;
+			break;
 		default:
 			usage(program_name);
 		}
@@ -319,6 +404,12 @@ int main (int argc, char ** argv)
 
 	io_flags |= EXT2_FLAG_64BITS;
 
+	if (undo_file) {
+		retval = resize2fs_setup_tdb(device_name, undo_file, &io_ptr);
+		if (retval)
+			exit(1);
+	}
+
 	retval = ext2fs_open2(device_name, io_options, io_flags,
 			      0, 0, io_ptr, &fs);
 	if (retval) {
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 0129bfc..d2738e9 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -18,6 +18,10 @@ resize2fs \- ext2/ext3/ext4 file system resizer
 .B \-S
 .I RAID-stride
 ]
+[
+.B \-z
+.I undo_file
+]
 .I device
 [
 .I size
@@ -149,6 +153,16 @@ The
 program will heuristically determine the RAID stride that was specified
 when the filesystem was created.  This option allows the user to
 explicitly specify a RAID stride setting to be used by resize2fs instead.
+.TP
+.BI \-z " undo_file"
+Before overwriting a file system block, write the old contents of the block to
+an undo file.  This undo file can be used with e2undo(8) to restore the old
+contents of the file system should something go wrong.  If the empty string is
+passed as the undo_file argument, the undo file will be written to a file named
+resize2fs-\fIdevice\fR.e2undo in the directory specified via the
+\fIE2FSPROGS_UNDO_DIR\fR environment variable.
+
+WARNING: The undo file cannot be used to recover from a power or system crash.
 .SH KNOWN BUGS
 The minimum size of the filesystem as estimated by resize2fs may be
 incorrect, especially for filesystems with 1k and 2k blocksizes.

