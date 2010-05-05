From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCH 8/8] e2fsprogs: Dump Next3 message buffer on fsck.
Date: Wed, 05 May 2010 21:28:56 +0300
Message-ID: <1273084136-6286-9-git-send-email-amir73il@users.sf.net>
References: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab0EESwU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:52:20 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:30:02 +0300 (IDT)
In-reply-to: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 error messages are recorded in a 2K message buffer after the
journal super block.  On journal recovery, the journal message buffer
is copied to the file system message buffer.  On fsck, if the message
buffer is not empty, the recorded messages are printed to stdout and
the buffer is cleared.
Next3 supports only block size of 4K, so there is always 2K of free
space for the message buffer after the 1K super block.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/journal.c |   14 ++++++++++++++
 e2fsck/super.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 57783eb..72d2ea0 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -836,6 +836,20 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)
 
 
 	if (journal->j_superblock->s_errno) {
+		/* journal message buffer at journal super block + 1K */
+		char *buf = ((char *) journal->j_superblock) +
+			SUPERBLOCK_OFFSET;
+		int len = ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;
+
+		if (len >= 2*SUPERBLOCK_OFFSET && *buf) {
+			/* write journal message buffer to super block + 2K */
+			io_channel_set_blksize(ctx->fs->io, SUPERBLOCK_OFFSET);
+			retval = io_channel_write_blk(ctx->fs->io, 2, 2, buf);
+			io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+			/* clear journal message buffer */
+			memset(buf, 0, len);
+		}
+
 		ctx->fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(ctx->fs);
 		journal->j_superblock->s_errno = 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index f66ce9d..4a830bc 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -584,6 +584,43 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
 	}
 }
 
+/*
+ * This function prints the message buffer at the end of super block.
+ */
+static void e2fsck_print_message_buffer(e2fsck_t ctx)
+{
+	char *buf;
+	int len = ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;
+	unsigned offset = 0;
+	int retval;
+#define MSGLEN 256
+
+	if (len < 2*SUPERBLOCK_OFFSET)
+		return;
+
+	buf = (char *) e2fsck_allocate_memory(ctx, len, "message buffer");
+
+	io_channel_set_blksize(ctx->fs->io, SUPERBLOCK_OFFSET);
+	/* read message buffer from super block + 2K */
+	retval = io_channel_read_blk(ctx->fs->io, 2, 2, buf);
+	if (retval || !*buf)
+		goto out;
+
+	/* print messages in buffer */
+	puts("Error messages recorded in message buffer:");
+	while (offset < len && buf[offset]) {
+		printf(buf+offset);
+		offset += MSGLEN;
+	}
+	/* clear message buffer */
+	memset(buf, 0, len);
+	retval = io_channel_write_blk(ctx->fs->io, 2, 2, buf);
+	puts("End of message buffer.");
+out:
+	io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+	ext2fs_free_mem(&buf);
+}
+
 
 void check_super_block(e2fsck_t ctx)
 {
@@ -998,6 +1035,11 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	e2fsck_fix_dirhash_hint(ctx);
 
+	/*
+	 * Print message buffer if necessary
+	 */
+	e2fsck_print_message_buffer(ctx);
+
 	return;
 }
 
-- 
1.6.6

