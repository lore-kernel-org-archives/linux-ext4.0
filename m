From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 3/3] debugfs: Add symlink command
Date: Wed, 19 Dec 2012 18:49:23 -0800
Message-ID: <2eeb3f8e9ee2dd77b6a9cb9774b0834c990799e9.1355971726.git.dvhart@infradead.org>
References: <1355971763-2348-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com,
	Darren Hart <dvhart@infradead.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35996
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2LTCtm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Dec 2012 21:49:42 -0500
In-Reply-To: <1355971763-2348-1-git-send-email-dvhart@infradead.org>
In-Reply-To: <ff54dc35c816ae53f149f2f032c12147deac8508.1355971726.git.dvhart@infradead.org>
References: <ff54dc35c816ae53f149f2f032c12147deac8508.1355971726.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add support for symbolic links using a new symlink command.
Modeled after the do_mkdir() command.

Very long target paths fail as the command parsing appears to truncate the
input to somewhere around 256 bytes. Independent testing of the
ext2fs_symlink() command demonstrates it works with multi-block-length
pathes.

Signed-off-by: Darren Hart <dvhart@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debug_cmds.ct |  3 +++
 debugfs/debugfs.8.in  |  3 +++
 debugfs/debugfs.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 debugfs/debugfs.h     |  1 +
 debugfs/dump.c        |  2 +-
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index a799dd7..338192f 100644
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
index aec61ab..6c4c1b1 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2204,6 +2204,49 @@ void do_punch(int argc, char *argv[])
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
index 994577c..434dbf0 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -133,6 +133,7 @@ extern void do_imap(int argc, char **argv);
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

