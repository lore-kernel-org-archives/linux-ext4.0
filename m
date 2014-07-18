From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/24] debugfs: create idump command to dump an inode in hex
Date: Fri, 18 Jul 2014 15:52:36 -0700
Message-ID: <20140718225236.31374.97509.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762724AbaGRWwl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:41 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a command that will dump an entire inode's space in hex.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debug_cmds.ct |    4 ++++
 debugfs/debugfs.c     |   33 +++++++++++++++++++++++++++++++++
 debugfs/debugfs.h     |    1 +
 debugfs/zap.c         |   33 +++++++++++++++++++--------------
 4 files changed, 57 insertions(+), 14 deletions(-)


diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 814fd52..9a66494 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -208,5 +208,9 @@ request do_list_quota, "List quota",
 request do_get_quota, "Get quota",
 	get_quota, gq;
 
+request do_idump, "Dump inode",
+	idump;
+
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 5eecabe..8078a02 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1888,6 +1888,39 @@ void do_imap(int argc, char *argv[])
 
 }
 
+void do_idump(int argc, char *argv[])
+{
+	ext2_ino_t	ino;
+	char		*buf;
+	errcode_t	err;
+	int		isize;
+
+	if (common_args_process(argc, argv, 2, 2, argv[0],
+				"<file>", 0))
+		return;
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+
+	isize = EXT2_INODE_SIZE(current_fs->super);
+	err = ext2fs_get_mem(isize, &buf);
+	if (err) {
+		com_err(argv[0], err, "while allocating memory");
+		return;
+	}
+
+	err = ext2fs_read_inode_full(current_fs, ino,
+				     (struct ext2_inode *)buf, isize);
+	if (err) {
+		com_err(argv[0], err, "while reading inode %d", ino);
+		goto err;
+	}
+
+	do_byte_hexdump(stdout, buf, isize);
+err:
+	ext2fs_free_mem(&buf);
+}
+
 #ifndef READ_ONLY
 void do_set_current_time(int argc, char *argv[])
 {
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index df51aa0..6eb5732 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -191,3 +191,4 @@ void do_list_xattr(int argc, char **argv);
 /* zap.c */
 extern void do_zap_block(int argc, char **argv);
 extern void do_block_dump(int argc, char **argv);
+extern void do_byte_hexdump(FILE *fp, unsigned char *buf, size_t bufsize);
diff --git a/debugfs/zap.c b/debugfs/zap.c
index 8109209..917bddf 100644
--- a/debugfs/zap.c
+++ b/debugfs/zap.c
@@ -176,7 +176,6 @@ void do_block_dump(int argc, char *argv[])
 	char		*file = NULL;
 	unsigned int	i, j;
 	int		c, err;
-	int		suppress = -1;
 
 	if (check_fs_open(argv[0]))
 		return;
@@ -229,11 +228,21 @@ void do_block_dump(int argc, char *argv[])
 		goto errout;
 	}
 
-	for (i=0; i < current_fs->blocksize; i += 16) {
+	do_byte_hexdump(stdout, buf, current_fs->blocksize);
+errout:
+	free(buf);
+}
+
+void do_byte_hexdump(FILE *fp, unsigned char *buf, size_t bufsize)
+{
+	size_t		i, j;
+	int		suppress = -1;
+
+	for (i = 0; i < bufsize; i += 16) {
 		if (suppress < 0) {
 			if (i && memcmp(buf + i, buf + i - 16, 16) == 0) {
 				suppress = i;
-				printf("*\n");
+				fprintf(fp, "*\n");
 				continue;
 			}
 		} else {
@@ -241,20 +250,16 @@ void do_block_dump(int argc, char *argv[])
 				continue;
 			suppress = -1;
 		}
-		printf("%04o  ", i);
+		fprintf(fp, "%04o  ", (unsigned int)i);
 		for (j = 0; j < 16; j++) {
-			printf("%02x", buf[i+j]);
+			fprintf(fp, "%02x", buf[i+j]);
 			if ((j % 2) == 1)
-				putchar(' ');
+				fprintf(fp, " ");
 		}
-		putchar(' ');
+		fprintf(fp, " ");
 		for (j = 0; j < 16; j++)
-			printf("%c", isprint(buf[i+j]) ? buf[i+j] : '.');
-		putchar('\n');
+			fprintf(fp, "%c", isprint(buf[i+j]) ? buf[i+j] : '.');
+		fprintf(fp, "\n");
 	}
-	putchar('\n');
