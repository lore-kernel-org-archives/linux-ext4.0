From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] e2fsck: display recorded error messages
Date: Tue, 15 Mar 2011 15:00:42 +0200
Message-ID: <AANLkTin2bZHrzhnJcKHa0NEMQ+su3SzPi2b4wbJoNA_j@mail.gmail.com>
References: <AANLkTinOEvBgmThmUGRL8Eo934_GH9phN6ZgQ-cCow=1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50497 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab1CONAn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 09:00:43 -0400
Received: by qwk3 with SMTP id 3so399820qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 06:00:42 -0700 (PDT)
In-Reply-To: <AANLkTinOEvBgmThmUGRL8Eo934_GH9phN6ZgQ-cCow=1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Here is another version/ping for that patch.

v2->v3:
- clear message buffer only if fsck has fixed the errors

v1->v2:
- clarify code with MSGBUF macros

v1:
- display error messages recorded by ext4 on fsck start

Amir.





Ext4 error messages are recorded in a message buffer after the
journal super block.  After journal recovery, the journal message buffer
is copied to the file system message buffer.  On fsck, if the message
buffer is not empty, the recorded messages are printed to stdout.
When fsck clears the error_fs flag, the message buffer is cleared.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>


---
 e2fsck/e2fsck.h     |    1 +
 e2fsck/journal.c    |   16 ++++++++++++
 e2fsck/super.c      |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c       |    1 +
 lib/ext2fs/ext2fs.h |    6 ++++
 5 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 4e7fc72..9914901 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -476,6 +476,7 @@ void e2fsck_rehash_directories(e2fsck_t ctx);
 void check_super_block(e2fsck_t ctx);
 int check_backup_super_block(e2fsck_t ctx);
 void check_resize_inode(e2fsck_t ctx);
+void e2fsck_clear_message_buffer(e2fsck_t ctx);

 /* util.c */
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index b741eb9..8d9afa1 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -837,6 +837,22 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)


 	if (journal->j_superblock->s_errno) {
+		/* journal message buffer at journal super block + 1K */
+		char *buf = ((char *) journal->j_superblock) +
+			SUPERBLOCK_OFFSET;
+		int n, len = ctx->fs->blocksize - MSGBUF_OFFSET;
+
+		if (len >= MSGBUF_OFFSET && *buf) {
+			/* keep it simple - write in MSGBUF_OFFSET blocksize */
+			io_channel_set_blksize(ctx->fs->io, MSGBUF_OFFSET);
+			n = len / MSGBUF_OFFSET;
+			/* write journal message buffer to super block + 2K */
+			retval = io_channel_write_blk(ctx->fs->io, 1, n, buf);
+			io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+			/* clear journal message buffer */
+			memset(buf, 0, len);
+		}
+
 		ctx->fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(ctx->fs);
 		journal->j_superblock->s_errno = 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 82c07b2..3606b89 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -450,6 +450,70 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
 	}
 }

+/*
+ * This function prints the message buffer at the end of super block.
+ */
+static void e2fsck_print_message_buffer(e2fsck_t ctx)
+{
+	char *buf;
+	int n, len = ctx->fs->blocksize - MSGBUF_OFFSET;
+	unsigned offset = 0;
+	int retval;
+
+	if (len < MSGBUF_OFFSET)
+		/* 1K or 2K fs->blocksize */
+		return;
+
+	buf = (char *) e2fsck_allocate_memory(ctx, len, "message buffer");
+
+	/* keep it simple - write in MSGBUF_OFFSET blocksize */
+	io_channel_set_blksize(ctx->fs->io, MSGBUF_OFFSET);
+	n = len / MSGBUF_OFFSET;
+	/* read message buffer from super block + 2K */
+	retval = io_channel_read_blk(ctx->fs->io, 1, n, buf);
+	if (retval || !*buf)
+		goto out;
+
+	/* print messages in buffer */
+	puts("Error messages recorded in message buffer:");
+	while (offset < len && buf[offset]) {
+		puts(buf+offset);
+		offset += MSGBUF_RECLEN;
+	}
+	puts("End of message buffer.");
+out:
+	io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+	ext2fs_free_mem(&buf);
+}
+
+/*
+ * This function clears the message buffer at the end of super block.
+ * It is called before clearing the EXT2_ERROR_FS flag from super block.
+ */
+void e2fsck_clear_message_buffer(e2fsck_t ctx)
+{
+	char *buf;
+	int n, len = ctx->fs->blocksize - MSGBUF_OFFSET;
+	unsigned offset = 0;
+	int retval;
+
+	if (len < MSGBUF_OFFSET)
+		/* 1K or 2K fs->blocksize */
+		return;
+
+	buf = (char *) e2fsck_allocate_memory(ctx, len, "message buffer");
+
+	/* keep it simple - write in MSGBUF_OFFSET blocksize */
+	io_channel_set_blksize(ctx->fs->io, MSGBUF_OFFSET);
+	n = len / MSGBUF_OFFSET;
+
+	/* clear message buffer at super block + 2K */
+	memset(buf, 0, len);
+	io_channel_write_blk(ctx->fs->io, 1, n, buf);
+	io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+	ext2fs_free_mem(&buf);
+}
+

 void check_super_block(e2fsck_t ctx)
 {
@@ -862,6 +926,11 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	e2fsck_fix_dirhash_hint(ctx);

+	/*
+	 * Print message buffer if necessary
+	 */
+	e2fsck_print_message_buffer(ctx);
+
 	return;
 }

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 624e11b..dd8275c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1465,6 +1465,7 @@ no_journal:
 				sb->s_lastcheck = ctx->now;
 			memset(((char *) sb) + EXT4_S_ERR_START, 0,
 			       EXT4_S_ERR_LEN);
+			e2fsck_clear_message_buffer(ctx);
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 516eb1a..b751e2c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -38,6 +38,12 @@ extern "C" {
  */
 #define SUPERBLOCK_OFFSET	1024
 #define SUPERBLOCK_SIZE 	1024
+/*
+ * When blocksize > 2K, the space after the superblock is used as
+ * a buffer to record error messages (in 256 bytes records).
+ */
+#define MSGBUF_OFFSET 		(SUPERBLOCK_OFFSET+SUPERBLOCK_SIZE)
+#define MSGBUF_RECLEN		256

 /*
  * The last ext2fs revision level that this version of the library is
-- 
1.7.0.4
