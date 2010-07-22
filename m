From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/7] debugfs: Add new debugfs command punch (aka truncate)
Date: Thu, 22 Jul 2010 10:03:16 -0400
Message-ID: <1279807398-13680-6-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34073 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This uses the newly added ext2fs_punch() function.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debug_cmds.ct |    3 +++
 debugfs/debugfs.8.in  |   12 ++++++++++++
 debugfs/debugfs.c     |   31 +++++++++++++++++++++++++++++++
 debugfs/debugfs.h     |    1 +
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 95dea0d..9b6c985 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -148,6 +148,9 @@ request do_dirsearch, "Search a directory for a particular filename",
 request do_bmap, "Calculate the logical->physical block mapping for an inode",
 	bmap;
 
+request do_punch, "Punch (or truncate) blocks from an inode by deallocating them",
+	punch, truncate;
+
 request do_imap, "Calculate the location of an inode",
 	imap;
 
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 9012a56..faa23eb 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -376,6 +376,18 @@ flag causes the filesystem to be opened in exclusive mode.  The
 options behave the same as the command-line options to 
 .BR debugfs .
 .TP
+.I punch filespec start_blk [end_blk]
+Delete the blocks in the inode ranging from
+.I start_blk
+to
+.IR end_blk .
+If
+.I end_blk
+is omitted then this command will function as a truncate command; that
+is, all of the blocks starting at
+.I start_blk
+through to the end of the file will be deallocated.
+.TP
 .I pwd
 Print the current working directory.
 .TP
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8e0dc55..260c38d 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2102,6 +2102,37 @@ void do_supported_features(int argc, char *argv[])
 	}
 }
 
+void do_punch(int argc, char *argv[])
+{
+	ext2_ino_t	ino;
+	blk64_t		start, end;
+	int		err;
+	errcode_t	errcode;
+
+	if (common_args_process(argc, argv, 3, 4, argv[0],
+				"<file> start_blk [end_blk]",
+				CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+	start = parse_ulong(argv[2], argv[0], "logical_block", &err);
+	if (argc == 4)
+		end = parse_ulong(argv[3], argv[0], "logical_block", &err);
+	else
+		end = ~0;
+
+	errcode = ext2fs_punch(current_fs, ino, 0, 0, start, end);
+
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while truncating inode %u from %llu to %llu\n", ino,
+			(unsigned long long) start, (unsigned long long) end);
+		return;
+	}
+}
+
 static int source_file(const char *cmd_file, int sci_idx)
 {
 	FILE		*f;
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index deaa56f..4cc8a1f 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -127,4 +127,5 @@ extern void do_bmap(int argc, char **argv);
 extern void do_imap(int argc, char **argv);
 extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
+extern void do_punch(int argc, char **argv);
 
-- 
1.7.0.4

