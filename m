From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/35] tune2fs: optionally create undo file
Date: Wed, 01 Apr 2015 19:35:58 -0700
Message-ID: <20150402023558.25243.59131.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbDBCgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:36:02 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide the user with an option to create an undo file so that they
can roll back a failed tuning operation.  Previously, one would be
created for inode resize if a bunch of (undocumented) conditions were
met.

v2: Enable re-opening of undo files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.8.in |   14 ++++++++++++++
 misc/tune2fs.c    |   30 ++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)


diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 9d1df82..4373fc4 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -88,6 +88,10 @@ tune2fs \- adjust tunable filesystem parameters on ext2/ext3/ext4 filesystems
 .B \-U
 .I UUID
 ]
+[
+.B \-z
+.I undo_file
+]
 device
 .SH DESCRIPTION
 .BI tune2fs
@@ -687,6 +691,16 @@ or
 .IR /dev/urandom ,
 .B tune2fs
 will automatically use a time-based UUID instead of a randomly-generated UUID.
+.TP
+.BI \-z " undo_file"
+Before overwriting a file system block, write the old contents of the block to
+an undo file.  This undo file can be used with e2undo(8) to restore the old
+contents of the file system should something go wrong.  If the empty string is
+passed as the undo_file argument, the undo file will be written to a file named
+tune2fs-\fIdevice\fR.e2undo in the directory specified via the
+\fIE2FSPROGS_UNDO_DIR\fR environment variable.
+
+WARNING: The undo file cannot be used to recover from a power or system crash.
 .SH BUGS
 We haven't found any bugs yet.  That doesn't mean there aren't any...
 .SH AUTHOR
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 550932d..ddaad59 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -99,6 +99,7 @@ static int usrquota, grpquota;
 static int rewrite_checksums;
 static int feature_64bit;
 static int fsck_requested;
+static char *undo_file;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -136,7 +137,8 @@ static void usage(void)
 		  "\t[-Q quota_options]\n"
 #endif
 		  "\t[-E extended-option[,...]] [-T last_check_time] "
-		  "[-U UUID]\n\t[ -I new_inode_size ] device\n"), program_name);
+		  "[-U UUID]\n\t[-I new_inode_size] [-z undo_file] device\n"),
+		program_name);
 	exit(1);
 }
 
@@ -465,6 +467,8 @@ static void convert_64bit(ext2_filsys fs, int direction)
 		fprintf(stderr, _("Please run `resize2fs %s %s"),
 			direction > 0 ? "-b" : "-s", fs->device_name);
 
+	if (undo_file)
+		fprintf(stderr, _(" -z \"%s\""), undo_file);
 	if (direction > 0)
 		fprintf(stderr, _("' to enable 64-bit mode.\n"));
 	else
@@ -1563,7 +1567,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	char *tmp;
 	struct group *gr;
 	struct passwd *pw;
-	char optstring[100] = "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:";
+	char optstring[100] = "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:z:";
 
 #ifdef CONFIG_QUOTA
 	strcat(optstring, "Q:");
@@ -1797,6 +1801,9 @@ static void parse_tune2fs_options(int argc, char **argv)
 			open_flag = EXT2_FLAG_RW;
 			I_flag = 1;
 			break;
+		case 'z':
+			undo_file = optarg;
+			break;
 		default:
 			usage();
 		}
@@ -2517,6 +2524,17 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	char *tdb_file;
 	char *dev_name, *tmp_name;
 
+	/* (re)open a specific undo file */
+	if (undo_file && undo_file[0] != 0) {
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		set_undo_io_backup_file(undo_file);
+		printf(_("To undo the tune2fs operation please run "
+			 "the command\n    e2undo %s %s\n\n"),
+			 undo_file, name);
+		return retval;
+	}
+
 #if 0 /* FIXME!! */
 	/*
 	 * Configuration via a conf file would be
@@ -2712,7 +2730,7 @@ retry_open:
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 
-	if (I_flag && !io_ptr_orig) {
+	if (I_flag) {
 		/*
 		 * Check the inode size is right so we can issue an
 		 * error message and bail before setting up the tdb
@@ -2736,11 +2754,15 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		}
