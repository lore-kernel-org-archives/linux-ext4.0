From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 38/54] mke2fs: optionally create undo file
Date: Mon, 26 Jan 2015 23:39:41 -0800
Message-ID: <20150127073941.13308.6969.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47253 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbbA0Hjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:39:49 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide the user with an option to create an undo file so that they
can roll back a failed tuning operation.  Previously, one would be
created if force_undo was set in the configuration file and a bunch of
(undocumented) conditions were met.

v2: Support reopening undo files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.8.in |   15 +++++++++++++++
 misc/mke2fs.c    |   25 ++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 3 deletions(-)


diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index aeb5caf..3230f65 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -117,6 +117,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .B \-e
 .I errors-behavior
 ]
+[
+.B \-z
+.I undo_file
+]
 .I device
 [
 .I fs-size
@@ -738,6 +742,17 @@ Verbose execution.
 Print the version number of
 .B mke2fs
 and exit.
+.TP
+.BI \-z " undo_file"
+Before overwriting a file system block, write the old contents of the block to
+an undo file.  This undo file can be used with e2undo(8) to restore the old
+contents of the file system should something go wrong.  If the empty string is
+passed as the undo_file argument, the undo file will be written to a file named
+mke2fs-\fIdevice\fR.e2undo in the directory specified via the
+\fIE2FSPROGS_UNDO_DIR\fR environment variable or the \fIundo_dir\fR directive
+in the configuration file.
+
+WARNING: The undo file cannot be used to recover from a power or system crash.
 .SH ENVIRONMENT
 .TP
 .BI MKE2FS_SYNC
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aeb852f..47b0b29 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -110,6 +110,7 @@ char *journal_device;
 static int sync_kludge;	/* Set using the MKE2FS_SYNC env. option */
 char **fs_types;
 const char *root_dir;  /* Copy files from the specified directory */
+static char *undo_file;
 
 static profile_t	profile;
 
@@ -129,7 +130,8 @@ static void usage(void)
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
 	"[-r fs-revision] [-E extended-option[,...]]\n"
 	"\t[-t fs-type] [-T usage-type ] [-U UUID] [-e errors_behavior]"
-	"[-jnqvDFKSV] device [blocks-count]\n"),
+	"[-z undo_file]\n"
+	"\t[-jnqvDFKSV] device [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
@@ -1551,7 +1553,7 @@ profile_error:
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:ce:g:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
+		    "b:ce:g:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:Vz:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = parse_num_blocks2(optarg, -1);
@@ -1774,6 +1776,9 @@ profile_error:
 			/* Print version number and exit */
 			show_version_only++;
 			break;
+		case 'z':
+			undo_file = optarg;
+			break;
 		default:
 			usage();
 		}
@@ -2492,6 +2497,19 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	char *dev_name, *tmp_name;
 	int free_tdb_dir = 0;
 
+	/* (re)open a specific undo file */
+	if (undo_file && undo_file[0] != 0) {
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		retval = set_undo_io_backup_file(undo_file);
+		if (retval)
+			goto err;
+		printf(_("Overwriting existing filesystem; this can be undone "
+			 "using the command:\n"
+			 "    e2undo %s %s\n\n"), undo_file, name);
+		return 0;
+	}
+
 	/*
 	 * Configuration via a conf file would be
 	 * nice
@@ -2546,6 +2564,7 @@ errout:
 	if (free_tdb_dir)
 		free(tdb_dir);
 	free(tdb_file);
+err:
 	com_err(program_name, retval, "%s",
 		_("while trying to setup undo file\n"));
 	return retval;
@@ -2717,7 +2736,7 @@ int main (int argc, char *argv[])
 #endif
 		io_ptr = unix_io_manager;
 
-	if (should_do_undo(device_name)) {
+	if (undo_file != NULL || should_do_undo(device_name)) {
 		retval = mke2fs_setup_tdb(device_name, &io_ptr);
 		if (retval)
 			exit(1);

