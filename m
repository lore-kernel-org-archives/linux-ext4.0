From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/31] debugfs: Handle 64bit block numbers
Date: Mon, 30 Sep 2013 18:28:24 -0700
Message-ID: <20131001012824.28415.25821.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB23 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:28:29 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

debugfs should use strtoull (and equivalent wrappers) for reading block numbers
from the command line.  "unsigned long" isn't wide enough on 32bit platforms.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c      |   19 ++++++++++---------
 debugfs/extent_inode.c |   24 +++++++++++++-----------
 debugfs/util.c         |    2 +-
 3 files changed, 24 insertions(+), 21 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index da44ce4..60452c9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -167,8 +167,9 @@ void do_open_filesys(int argc, char **argv)
 				return;
 			break;
 		case 's':
-			superblock = parse_ulong(optarg, argv[0],
-						 "superblock number", &err);
+			superblock = parse_ulonglong(optarg, argv[0],
+						     "superblock number",
+						     &err);
 			if (err)
 				return;
 			break;
@@ -269,8 +270,8 @@ void do_init_filesys(int argc, char **argv)
 		return;
 
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	ext2fs_blocks_count_set(&param, parse_ulong(argv[2], argv[0],
-						    "blocks count", &err));
+	ext2fs_blocks_count_set(&param, parse_ulonglong(argv[2], argv[0],
+							"blocks count", &err));
 	if (err)
 		return;
 	retval = ext2fs_initialize(argv[1], 0, &param,
@@ -2050,7 +2051,7 @@ void do_bmap(int argc, char *argv[])
 	ino = string_to_inode(argv[1]);
 	if (!ino)
 		return;
-	blk = parse_ulong(argv[2], argv[0], "logical_block", &err);
+	blk = parse_ulonglong(argv[2], argv[0], "logical_block", &err);
 
 	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
 	if (errcode) {
@@ -2195,9 +2196,9 @@ void do_punch(int argc, char *argv[])
 	ino = string_to_inode(argv[1]);
 	if (!ino)
 		return;
-	start = parse_ulong(argv[2], argv[0], "logical_block", &err);
+	start = parse_ulonglong(argv[2], argv[0], "logical_block", &err);
 	if (argc == 4)
-		end = parse_ulong(argv[3], argv[0], "logical_block", &err);
+		end = parse_ulonglong(argv[3], argv[0], "logical_block", &err);
 	else
 		end = ~0;
 
@@ -2415,8 +2416,8 @@ int main(int argc, char **argv)
 						"block size", 0);
 			break;
 		case 's':
-			superblock = parse_ulong(optarg, argv[0],
-						 "superblock number", 0);
+			superblock = parse_ulonglong(optarg, argv[0],
+						     "superblock number", 0);
 			break;
 		case 'c':
 			catastrophic = 1;
diff --git a/debugfs/extent_inode.c b/debugfs/extent_inode.c
index 0bbc4c5..d5c4721 100644
--- a/debugfs/extent_inode.c
+++ b/debugfs/extent_inode.c
@@ -264,7 +264,8 @@ void do_replace_node(int argc, char *argv[])
 		return;
 	}
 
-	extent.e_lblk = parse_ulong(argv[1], argv[0], "logical block", &err);
+	extent.e_lblk = parse_ulonglong(argv[1], argv[0], "logical block",
+					&err);
 	if (err)
 		return;
 
@@ -272,7 +273,8 @@ void do_replace_node(int argc, char *argv[])
 	if (err)
 		return;
 
-	extent.e_pblk = parse_ulong(argv[3], argv[0], "logical block", &err);
+	extent.e_pblk = parse_ulonglong(argv[3], argv[0], "logical block",
+					&err);
 	if (err)
 		return;
 
@@ -338,8 +340,8 @@ void do_insert_node(int argc, char *argv[])
 		return;
 	}
 
-	extent.e_lblk = parse_ulong(argv[1], cmd,
-				    "logical block", &err);
+	extent.e_lblk = parse_ulonglong(argv[1], cmd,
+					"logical block", &err);
 	if (err)
 		return;
 
@@ -348,8 +350,8 @@ void do_insert_node(int argc, char *argv[])
 	if (err)
 		return;
 
-	extent.e_pblk = parse_ulong(argv[3], cmd,
-				    "pysical block", &err);
+	extent.e_pblk = parse_ulonglong(argv[3], cmd,
+					"physical block", &err);
 	if (err)
 		return;
 
@@ -366,8 +368,8 @@ void do_set_bmap(int argc, char **argv)
 	const char	*usage = "[--uninit] <lblk> <pblk>";
 	struct ext2fs_extent extent;
 	errcode_t	retval;
-	blk_t		logical;
-	blk_t		physical;
+	blk64_t		logical;
+	blk64_t		physical;
 	char		*cmd = argv[0];
 	int		flags = 0;
 	int		err;
@@ -387,18 +389,18 @@ void do_set_bmap(int argc, char **argv)
 		return;
 	}
 
-	logical = parse_ulong(argv[1], cmd,
+	logical = parse_ulonglong(argv[1], cmd,
 				    "logical block", &err);
 	if (err)
 		return;
 
-	physical = parse_ulong(argv[2], cmd,
+	physical = parse_ulonglong(argv[2], cmd,
 				    "physical block", &err);
 	if (err)
 		return;
 
 	retval = ext2fs_extent_set_bmap(current_handle, logical,
-					(blk64_t) physical, flags);
+					physical, flags);
 	if (retval) {
 		com_err(cmd, retval, 0);
 		return;
diff --git a/debugfs/util.c b/debugfs/util.c
index cf3a6c6..245d556 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -377,7 +377,7 @@ int common_block_args_process(int argc, char *argv[],
 	}
 
 	if (argc > 2) {
-		*count = parse_ulong(argv[2], argv[0], "count", &err);
+		*count = parse_ulonglong(argv[2], argv[0], "count", &err);
 		if (err)
 			return 1;
 	}

