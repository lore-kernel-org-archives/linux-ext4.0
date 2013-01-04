From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 2/3] debugfs: Add symlink command
Date: Fri,  4 Jan 2013 12:00:59 -0800
Message-ID: <1c3b3a0283f5fea2b20511aac118c80cffa48fce.1357329054.git.dvhart@infradead.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com, Darren Hart <dvhart@infradead.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3ADUBX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 15:01:23 -0500
In-Reply-To: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
In-Reply-To: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
References: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add support for symbolic links using a new symlink command.
Modeled after the do_mkdir() command.

Testing demonstrates both fastlinks and slowlinks work correctly. Very
long target paths fail as the command parsing appears to truncate the
input to somewhere around 256 bytes.

Signed-off-by: Darren Hart <dvhart@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>
---
 debugfs/debug_cmds.ct |  3 +++
 debugfs/debugfs.8.in  |  3 +++
 debugfs/debugfs.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 debugfs/debugfs.h     |  1 +
 debugfs/dump.c        |  2 +-
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 520933a..95d32df 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -160,6 +160,9 @@ request do_bmap, "Calculate the logical->physical block mapping for an inode",
 request do_punch, "Punch (or truncate) blocks from an inode by deallocating them",
 	punch, truncate;
 
+request do_symlink, "Create a symbolic link",
+	symlink;
+
 request do_imap, "Calculate the location of an inode",
 	imap;
 
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index bfcb1a8..c3b49f9 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -469,6 +469,9 @@ is, all of the blocks starting at
 .I start_blk
 through to the end of the file will be deallocated.
 .TP
+.I symlink filespec target
+Make a symbolic link.
+.TP
 .I pwd
 Print the current working directory.
 .TP
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 341edfa..aa9a5f0 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2202,6 +2202,49 @@ void do_punch(int argc, char *argv[])
 }
 #endif /* READ_ONLY */
 
+void do_symlink(int argc, char *argv[])
+{
+	char		*cp;
+	ext2_ino_t	parent;
+	char		*name, *target;
+	errcode_t	retval;
+
+	if (common_args_process(argc, argv, 3, 3, "symlink",
+				"<filename> <target>", CHECK_FS_RW))
+		return;
+
+	cp = strrchr(argv[1], '/');
+	if (cp) {
+		*cp = 0;
+		parent = string_to_inode(argv[1]);
+		if (!parent) {
+			com_err(argv[1], ENOENT, 0);
+			return;
+		}
+		name = cp+1;
+	} else {
+		parent = cwd;
+		name = argv[1];
+	}
+	target = argv[2];
+
+try_again:
+	retval = ext2fs_symlink(current_fs, parent, 0, name, target);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, parent);
+		if (retval) {
+			com_err(argv[0], retval, "while expanding directory");
+			return;
+		}
+		goto try_again;
+	}
+	if (retval) {
+		com_err("ext2fs_symlink", retval, 0);
+		return;
+	}
+
+}
+
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
 #if CONFIG_MMP
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index efd8d12..bbefdf3 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -136,6 +136,7 @@ extern void do_imap(int argc, char **argv);
 extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
+extern void do_symlink(int argc, char **argv);
 
 extern void do_dump_mmp(int argc, char **argv);
 extern void do_set_mmp_value(int argc, char **argv);
diff --git a/debugfs/dump.c b/debugfs/dump.c
index a15a0b7..2d830c9 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -285,7 +285,7 @@ static void rdump_inode(ext2_ino_t ino, struct ext2_inode *inode,
 
 		fix_perms("rdump", inode, -1, fullname);
 	}
-	/* else do nothing (don't dump device files, sockets, fifos, etc.) */
+	/* else do nothing (don't dump device files, sockets, fifos, symlinks, etc.) */
 
 errout:
 	free(fullname);
-- 
1.7.11.7

