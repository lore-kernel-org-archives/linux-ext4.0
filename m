From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] debugfs: clean up read_journal_block() to avoid Coverity complaint
Date: Fri,  3 Jan 2014 18:12:27 -0500
Message-ID: <1388790748-18973-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45735 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaACXMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 18:12:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The read_journal_block() function was needlessly complicated, which
made it harder to read/maintain, and it also tripped up Coverity.
Cleaning it up also avoided some signed/unsigned casts, and allows us
to avoid passing got back to the caller, since it wasn't needed.

Addresses-Coverty-Bug: #709539

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/logdump.c | 48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 66a5428..d2c3b30 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -273,42 +273,43 @@ print_usage:
 
 
 static int read_journal_block(const char *cmd, struct journal_source *source,
-			      off_t offset, char *buf, int size,
-			      unsigned int *got)
+			      off_t offset, char *buf, unsigned int size)
 {
 	int retval;
+	unsigned int got;
 
 	if (source->where == JOURNAL_IS_EXTERNAL) {
 		if (lseek(source->fd, offset, SEEK_SET) < 0) {
 			retval = errno;
-			com_err(cmd, retval, "while seeking in reading journal");
-			return retval;
+			goto seek_err;
 		}
 		retval = read(source->fd, buf, size);
-		if (retval >= 0) {
-			*got = retval;
-			retval = 0;
-		} else
+		if (retval < 0) {
 			retval = errno;
+			goto read_err;
+		}
+		got = retval;
+		retval = 0;
 	} else {
 		retval = ext2fs_file_lseek(source->file, offset,
 					   EXT2_SEEK_SET, NULL);
 		if (retval) {
+		seek_err:
 			com_err(cmd, retval, "while seeking in reading journal");
 			return retval;
 		}
-
-		retval = ext2fs_file_read(source->file, buf, size, got);
+		retval = ext2fs_file_read(source->file, buf, size, &got);
+		if (retval) {
+		read_err:
+			com_err(cmd, retval, "while reading journal");
+			return retval;
+		}
 	}
-
-	if (retval)
-		com_err(cmd, retval, "while reading journal");
-	else if (*got != (unsigned int) size) {
-		com_err(cmd, 0, "short read (read %d, expected %d) "
-			"while reading journal", *got, size);
+	if (got != size) {
+		com_err(cmd, 0, "short read (read %u, expected %u) "
+			"while reading journal", got, size);
 		retval = -1;
 	}
-
 	return retval;
 }
 
@@ -338,7 +339,6 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	char			buf[8192];
 	journal_superblock_t	*jsb;
 	unsigned int		blocksize = 1024;
-	unsigned int		got;
 	int			retval;
 	__u32			magic, sequence, blocktype;
 	journal_header_t	*header;
@@ -347,8 +347,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	unsigned int		blocknr = 0;
 
 	/* First, check to see if there's an ext2 superblock header */
-	retval = read_journal_block(cmdname, source, 0,
-				    buf, 2048, &got);
+	retval = read_journal_block(cmdname, source, 0, buf, 2048);
 	if (retval)
 		return;
 
@@ -377,7 +376,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	/* Next, read the journal superblock */
 
 	retval = read_journal_block(cmdname, source, blocknr*blocksize,
-				    jsb_buffer, 1024, &got);
+				    jsb_buffer, 1024);
 	if (retval)
 		return;
 
@@ -401,8 +400,8 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	while (1) {
 		retval = read_journal_block(cmdname, source,
 					    blocknr*blocksize, buf,
-					    blocksize, &got);
-		if (retval || got != blocksize)
+					    blocksize);
+		if (retval)
 			return;
 
 		header = (journal_header_t *) buf;
@@ -576,7 +575,6 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 				int blocksize,
 				tid_t transaction)
 {
-	unsigned int 	got;
 	int		retval;
 	char 		buf[8192];
 
@@ -612,7 +610,7 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 
 	retval = read_journal_block("logdump", source,
 				    blocksize * log_blocknr,
-				    buf, blocksize, &got);
+				    buf, blocksize);
 	if (retval)
 		return;
 
-- 
1.8.5.rc3.362.gdf10213

