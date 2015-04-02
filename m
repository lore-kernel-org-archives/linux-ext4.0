From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/35] debugfs: optionally create undo file
Date: Wed, 01 Apr 2015 19:36:11 -0700
Message-ID: <20150402023611.25243.74612.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbbDBCgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:36:15 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide the user with an option to create an undo file so that they
can roll back a failed debugfs expedition.

v2: Support reopening undo files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.8.in |   16 +++++++-
 debugfs/debugfs.c    |  105 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 8 deletions(-)


diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index ab6adc4..9a09cbf 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -31,6 +31,10 @@ request
 data_source_device
 ]
 [
+.B \-z
+.I undo_file
+]
+[
 device
 ]
 .SH DESCRIPTION
@@ -130,6 +134,16 @@ and then exit.
 print the version number of
 .B debugfs
 and exit.
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
 .SH SPECIFYING FILES
 Many
 .B debugfs
@@ -535,7 +549,7 @@ to those inodes.  The
 flag will enable checking the file type information in the directory
 entry to make sure it matches the inode's type.
 .TP
-.BI open " [-weficD] [-b blocksize] [-s superblock] device"
+.BI open " [-weficD] [-b blocksize] [-s superblock] [-z undo_file] device"
 Open a filesystem for editing.  The
 .I -f
 flag forces the filesystem to be opened even if there are some unknown
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index fe57366..4b88f73 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -15,6 +15,7 @@
 #include <ctype.h>
 #include <string.h>
 #include <time.h>
+#include <libgen.h>
 #ifdef HAVE_GETOPT_H
 #include <getopt.h>
 #else
@@ -48,12 +49,88 @@ ext2_filsys	current_fs;
 quota_ctx_t	current_qctx;
 ext2_ino_t	root, cwd;
 
+static int debugfs_setup_tdb(const char *device_name, char *undo_file,
+			     io_manager *io_ptr)
+{
+	errcode_t retval = ENOMEM;
+	char *tdb_dir = NULL, *tdb_file = NULL;
+	char *dev_name, *tmp_name;
+	int free_tdb_dir = 0;
+
+	/* (re)open a specific undo file */
+	if (undo_file && undo_file[0] != 0) {
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		retval = set_undo_io_backup_file(undo_file);
+		if (retval)
+			goto err;
+		printf("Overwriting existing filesystem; this can be undone "
+			"using the command:\n"
+			"    e2undo %s %s\n\n",
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
+	sprintf(tdb_file, "%s/debugfs-%s.e2undo", tdb_dir, dev_name);
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
+	printf("Overwriting existing filesystem; this can be undone "
+		"using the command:\n"
+		"    e2undo %s %s\n\n", tdb_file, device_name);
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
+	com_err("debugfs", retval, "while trying to setup undo file\n");
+	return retval;
+}
+
 static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			    blk64_t blocksize, int catastrophic,
-			    char *data_filename)
+			    char *data_filename, char *undo_file)
 {
 	int	retval;
 	io_channel data_io = 0;
+	io_manager io_ptr = unix_io_manager;
 
 	if (superblock != 0 && blocksize == 0) {
 		com_err(device, 0, "if you specify the superblock, you must also specify the block size");
@@ -84,8 +161,14 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 	if (catastrophic)
 		open_flags |= EXT2_FLAG_SKIP_MMP;
 
+	if (undo_file) {
+		retval = debugfs_setup_tdb(device, undo_file, &io_ptr);
+		if (retval)
+			exit(1);
+	}
+
 	retval = ext2fs_open(device, open_flags, superblock, blocksize,
-			     unix_io_manager, &current_fs);
+			     io_ptr, &current_fs);
 	if (retval) {
 		com_err(device, retval, "while opening filesystem");
 		if (retval == EXT2_ET_BAD_MAGIC)
@@ -136,9 +219,10 @@ void do_open_filesys(int argc, char **argv)
 	blk64_t	blocksize = 0;
 	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS; 
 	char	*data_filename = 0;
+	char	*undo_file = NULL;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "iwfecb:s:d:D")) != EOF) {
+	while ((c = getopt(argc, argv, "iwfecb:s:d:Dz:")) != EOF) {
 		switch (c) {
 		case 'i':
 			open_flags |= EXT2_FLAG_IMAGE_FILE;
@@ -177,6 +261,9 @@ void do_open_filesys(int argc, char **argv)
 			if (err)
 				return;
 			break;
+		case 'z':
+			undo_file = optarg;
+			break;
 		default:
 			goto print_usage;
 		}
@@ -188,7 +275,7 @@ void do_open_filesys(int argc, char **argv)
 		return;
 	open_filesystem(argv[optind], open_flags,
 			superblock, blocksize, catastrophic,
-			data_filename);
+			data_filename, undo_file);
 	return;
 
 print_usage:
@@ -2219,7 +2306,7 @@ int main(int argc, char **argv)
 		"Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] "
 		"[-R request] [-V] ["
 #ifndef READ_ONLY
-		"[-w] "
+		"[-w] [-z undo_file] "
 #endif
 		"[-c] device]";
 	int		c;
@@ -2234,7 +2321,8 @@ int main(int argc, char **argv)
 #ifdef READ_ONLY
 	const char	*opt_string = "nicR:f:b:s:Vd:D";
 #else
-	const char	*opt_string = "niwcR:f:b:s:Vd:D";
+	const char	*opt_string = "niwcR:f:b:s:Vd:Dz:";
+	char		*undo_file = NULL;
 #endif
 
 	if (debug_prog_name == 0)
@@ -2291,6 +2379,9 @@ int main(int argc, char **argv)
 			fprintf(stderr, "\tUsing %s\n",
 				error_message(EXT2_ET_BASE));
 			exit(0);
+		case 'z':
+			undo_file = optarg;
+			break;
 		default:
 			com_err(argv[0], 0, usage, debug_prog_name);
 			return 1;
@@ -2299,7 +2390,7 @@ int main(int argc, char **argv)
 	if (optind < argc)
 		open_filesystem(argv[optind], open_flags,
 				superblock, blocksize, catastrophic,
-				data_filename);
+				data_filename, undo_file);
 
 	sci_idx = ss_create_invocation(debug_prog_name, "0.0", (char *) NULL,
 				       &debug_cmds, &retval);

