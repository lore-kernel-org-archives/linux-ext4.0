From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 2/5] Add missing information to e2fsck man pages and usage text.
Date: Wed, 13 Dec 2017 23:13:10 -0800
Message-ID: <1c3542de90186d1e70d064ca9928b02c30331f95.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33664 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNHOg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:36 -0500
Received: by mail-pg0-f65.google.com with SMTP id g7so2882097pgs.0
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:36 -0800 (PST)
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add environment variable and defaults stanza information.
Also, update a couple of descriptions.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 e2fsck/e2fsck.8.in      | 25 +++++++++++++++----------
 e2fsck/e2fsck.conf.5.in | 21 ++++++++++++++++++++-
 e2fsck/unix.c           |  1 +
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 4c29943..1a3bd46 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -101,21 +101,21 @@ Instead of using the normal superblock, use an alternative superblock
 specified by
 .IR superblock .
 This option is normally used when the primary superblock has been
-corrupted.  The location of the backup superblock is dependent on the
-filesystem's blocksize.  For filesystems with 1k blocksizes, a backup
-superblock can be found at block 8193; for filesystems with 2k
-blocksizes, at block 16384; and for 4k blocksizes, at block 32768.
+corrupted.  The location of backup superblocks is dependent on the
+filesystem's blocksize, the number of blocks per group, and features
+such as
+.BR sparse_super .
 .IP
 Additional backup superblocks can be determined by using the
 .B mke2fs
 program using the
 .B \-n
-option to print out where the superblocks were created.   The
-.B \-b
-option to
-.BR mke2fs ,
-which specifies blocksize of the filesystem must be specified in order
-for the superblock locations that are printed out to be accurate.
+option to print out where the superblocks exist, supposing
+.B mke2fs
+is supplied with arguments that are consistent with the filesystem's layout
+(e.g. blocksize, blocks per group,
+.BR sparse_super ,
+etc.).
 .IP
 If an alternative superblock is specified and
 the filesystem is not opened read-only, e2fsck will make sure that the
@@ -472,6 +472,11 @@ man page for more details.
 Always include the full version string which
 .B e2fsck
 displays when it is run, so I know which version you are running.
+.SH ENVIRONMENT
+.TP
+.BI E2FSCK_CONFIG
+Determines the location of the configuration file (see
+.BR e2fsck.conf (5)).
 .SH AUTHOR
 This version of
 .B e2fsck
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index a727932..708e213 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -69,6 +69,12 @@ This stanza contains general configuration parameters for
 .BR e2fsck 's
 behavior.
 .TP
+.I [defaults]
+Contains relations which define the default parameters used by
+.BR e2fsck (8).
+In general, these defaults may be overridden by command-line options
+provided by the user.
+.TP
 .I [problems]
 This stanza allows the administrator to reconfigure how e2fsck handles
 various filesystem inconsistencies.
@@ -250,6 +256,19 @@ If this boolean relation is true, e2fsck will run as if the option
 .B -v
 is always specified.  This will cause e2fsck to print some additional
 information at the end of each full file system check.
+.SH THE [defaults] STANZA
+The following relations are defined in the
+.I [defaults]
+stanza.
+.TP
+.I undo_dir
+This relation specifies the directory where the undo file should be
+stored.  It can be overridden via the
+.B E2FSPROGS_UNDO_DIR
+environment variable.  If the directory location is set to the value
+.IR none ,
+.B e2fsck
+will not create an undo file.
 .SH THE [problems] STANZA
 Each tag in the
 .I [problems]
@@ -336,7 +355,7 @@ data structure, such as pruning an extent tree.
 @TDB_MAN_COMMENT@.TP
 @TDB_MAN_COMMENT@.I numdirs_threshold
 @TDB_MAN_COMMENT@If this relation is set, then in-memory data structures
-@TDB_MAN_COMMENT@be used if the number of directories in the filesystem
+@TDB_MAN_COMMENT@will be used if the number of directories in the filesystem
 @TDB_MAN_COMMENT@are fewer than amount specified.
 @TDB_MAN_COMMENT@.TP
 @TDB_MAN_COMMENT@.I dirinfo
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2e9be8b..faf5af9 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -759,6 +759,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		fputs("\tno_inode_count_fullmap\n", stderr);
 		fputs(_("\treadahead_kb=<buffer size>\n"), stderr);
 		fputs("\tbmap2extent\n", stderr);
+		fputs("\tfixes_only\n", stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
-- 
2.7.4
