From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/54] e2fsck: optionally create an undo file
Date: Mon, 26 Jan 2015 23:39:22 -0800
Message-ID: <20150127073922.13308.42287.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47065 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbbA0Hj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:39:26 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide the user with an option to create an undo file so that they
can roll back a failed repair operation.

v2: Support reopening undo files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.8.in |   10 +++++
 e2fsck/e2fsck.h    |    3 ++
 e2fsck/unix.c      |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 2 deletions(-)


diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 6e6a2cd..364c7f1 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -334,6 +334,16 @@ may not be specified at the same time as the
 or
 .B \-p
 options.
+.TP
+.BI \-z " undo_file"
+Before overwriting a file system block, write the old contents of the block to
+an undo file.  This undo file can be used with e2undo(8) to restore the old
+contents of the file system should something go wrong.  If the empty string is
+passed as the undo_file argument, the undo file will be written to a file named
+e2fsck-\fIdevice\fR.e2undo in the directory specified via the
+\fIE2FSPROGS_UNDO_DIR\fR environment variable.
+
+WARNING: The undo file cannot be used to recover from a power or system crash.
 .SH EXIT CODE
 The exit code returned by
 .B e2fsck
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 15d968e..04f7bac 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -388,6 +388,9 @@ struct e2fsck_struct {
 	 * Inodes to rebuild extent trees
 	 */
 	ext2fs_inode_bitmap inodes_to_rebuild;
+
+	/* Undo file */
+	char *undo_file;
 };
 
 /* Data structures to evaluate whether an extent tree needs rebuilding. */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b84bffe..d2ef50f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -45,6 +45,7 @@ extern int optind;
 #ifdef HAVE_DIRENT_H
 #include <dirent.h>
 #endif
+#include <libgen.h>
 
 #include "e2p/e2p.h"
 #include "et/com_err.h"
@@ -75,7 +76,7 @@ static void usage(e2fsck_t ctx)
 		_("Usage: %s [-panyrcdfvtDFV] [-b superblock] [-B blocksize]\n"
 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
-		"\t\t[-E extended-options] device\n"),
+		"\t\t[-E extended-options] [-z undo_file] device\n"),
 		ctx->program_name);
 
 	fprintf(stderr, "%s", _("\nEmergency help:\n"
@@ -91,6 +92,7 @@ static void usage(e2fsck_t ctx)
 		" -j external_journal  Set location of the external journal\n"
 		" -l bad_blocks_file   Add to badblocks list\n"
 		" -L bad_blocks_file   Set badblocks list\n"
+		" -z undo_file         Create an undo file\n"
 		));
 
 	exit(FSCK_USAGE);
@@ -795,7 +797,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 
 	phys_mem_kb = get_memory_size() / 1024;
 	ctx->readahead_kb = ~0ULL;
-	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+	while ((c = getopt(argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDkz:")) != EOF)
 		switch (c) {
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
@@ -927,6 +929,9 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'k':
 			keep_bad_blocks++;
 			break;
+		case 'z':
+			ctx->undo_file = optarg;
+			break;
 		default:
 			usage(ctx);
 		}
@@ -1205,6 +1210,87 @@ check_error:
 	return retval;
 }
 
+static int e2fsck_setup_tdb(e2fsck_t ctx, io_manager *io_ptr)
+{
+	errcode_t retval = ENOMEM;
+	char *tdb_dir = NULL, *tdb_file = NULL;
+	char *dev_name, *tmp_name;
+	int free_tdb_dir = 0;
+
+	/* (re)open a specific undo file */
+	if (ctx->undo_file && ctx->undo_file[0] != 0) {
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		retval = set_undo_io_backup_file(ctx->undo_file);
+		if (retval)
+			goto err;
+		printf(_("Overwriting existing filesystem; this can be undone "
+			 "using the command:\n"
+			 "    e2undo %s %s\n\n"),
+			ctx->undo_file, ctx->filesystem_name);
+		return 0;
+	}
+
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+	if (!tdb_dir) {
+		profile_get_string(ctx->profile, "defaults",
+				   "undo_dir", 0, "/var/lib/e2fsprogs",
+				   &tdb_dir);
+		free_tdb_dir = 1;
+	}
+
+	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
+	    access(tdb_dir, W_OK)) {
+		if (free_tdb_dir)
+			free(tdb_dir);
+		return 0;
+	}
+
+	tmp_name = strdup(ctx->filesystem_name);
+	if (!tmp_name)
+		goto errout;
+	dev_name = basename(tmp_name);
+	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
+	if (!tdb_file) {
+		free(tmp_name);
+		goto errout;
+	}
+	sprintf(tdb_file, "%s/e2fsck-%s.e2undo", tdb_dir, dev_name);
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
+		 "    e2undo %s %s\n\n"), tdb_file, ctx->filesystem_name);
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
+	com_err(ctx->program_name, retval, "%s",
+		_("while trying to setup undo file\n"));
+	return retval;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1315,6 +1401,12 @@ restart:
 	} else
 		flags |= EXT2_FLAG_SOFTSUPP_FEATURES;
 
+	if (ctx->undo_file) {
+		retval = e2fsck_setup_tdb(ctx, &io_ptr);
+		if (retval)
+			exit(FSCK_ERROR);
+	}
+
 	ctx->openfs_flags = flags;
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
 

