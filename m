From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add allocate and set functionality to the bmap command
Date: Mon, 13 Oct 2014 12:03:29 -0400
Message-ID: <1413216209-5393-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbaJMQDh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 12:03:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This also makes it easier test the ext2fs_bmap2() function.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/debugfs.8.in |  7 +++++--
 debugfs/debugfs.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 7934f13..8f44ced 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -167,11 +167,14 @@ Print the blocks used by the inode
 .I filespec
 to stdout.
 .TP
-.BI bmap " filespec logical_block"
-Print the physical block number corresponding to the logical block number
+.BI bmap " [ -a ] filespec logical_block [physical_block]"
+Print or set the physical block number corresponding to the logical block number
 .I logical_block
 in the inode
 .IR filespec .
+If the
+.I -a
+flag is specified, try to allocate a block if necessary.
 .TP
 .BI block_dump " [-f filespec] block_num"
 Dump the filesystem block given by
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index db85028..fe57366 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1863,28 +1863,64 @@ void do_features(int argc, char *argv[])
 void do_bmap(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	blk64_t		blk, pblk;
-	int		err;
+	blk64_t		blk, pblk = 0;
+	int		c, err, flags = 0, ret_flags = 0;
 	errcode_t	errcode;
 
-	if (common_args_process(argc, argv, 3, 3, argv[0],
-				"<file> logical_blk", 0))
+	if (check_fs_open(argv[0]))
 		return;
 
-	ino = string_to_inode(argv[1]);
+	reset_getopt();
+	while ((c = getopt (argc, argv, "a")) != EOF) {
+		switch (c) {
+		case 'a':
+			flags |= BMAP_ALLOC;
+			break;
+		default:
+			goto print_usage;
+		}
+	}
+
+	if (argc <= optind+1) {
+	print_usage:
+		com_err(0, 0,
+			"Usage: bmap [-a] <file> logical_blk [physical_blk]");
+		return;
+	}
+
+	ino = string_to_inode(argv[optind++]);
 	if (!ino)
 		return;
-	err = strtoblk(argv[0], argv[2], "logical block", &blk);
+	err = strtoblk(argv[0], argv[optind++], "logical block", &blk);
 	if (err)
 		return;
 
-	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
+	if (argc > optind+1)
+		goto print_usage;
+
+	if (argc == optind+1) {
+		err = strtoblk(argv[0], argv[optind++],
+			       "physical block", &pblk);
+		if (err)
+			return;
+		if (flags & BMAP_ALLOC) {
+			com_err(0, 0, "Can't set and allocate a block");
+			return;
+		}
+		flags |= BMAP_SET;
+	}
+
+	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, flags, blk,
+			       &ret_flags, &pblk);
 	if (errcode) {
 		com_err(argv[0], errcode,
 			"while mapping logical block %llu\n", blk);
 		return;
 	}
-	printf("%llu\n", pblk);
+	printf("%llu", pblk);
+	if (ret_flags & BMAP_RET_UNINIT)
+		fputs(" (uninit)", stdout);
+	fputc('\n', stdout);
 }
 
 void do_imap(int argc, char *argv[])
-- 
2.1.0

