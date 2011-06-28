From: amir73il@users.sourceforge.net
Subject: [PATCH] ext4: Record error messages in super block
Date: Tue, 28 Jun 2011 10:41:24 +0300
Message-ID: <1309246884-7539-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38419 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab1F1Hlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 03:41:45 -0400
Received: by wwe5 with SMTP id 5so5491910wwe.1
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 00:41:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

This patch adds a message buffer facility, utilizing the free space
after the super block in a filesystem where block size >= 4K.

The message buffer can be used for post mortem analysis of filesystem
errors, in the case where the system log files are not available.

The message buffer follows the ERROR_FS flag from the journal super block
to the filesystem super block and cleared when e2fsck clears the flag:

1. Ext4 error messages are recorded in a message buffer on the free space
   after the journal super block.
2. On journal recovery, the message buffer is copied to the free space
   after the filesystem super block.
3. The message buffer will be displayed by e2fsck and cleared after the
   errors were fixed.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/super.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cc5c157..056da19 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -326,10 +326,52 @@ int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle)
 	return err;
 }
 
+/* record error messages after journal super block */
+static void ext4_record_journal_err(struct super_block *sb, const char *where,
+		const char *function, const char *fmt, va_list args)
+{
+#define MSGLEN 256
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+	char *buf;
+	unsigned long offset;
+	int len;
+	if (!journal)
+		return;
+
+	buf = (char *)journal->j_superblock;
+	offset = (unsigned long)buf % sb->s_blocksize;
+	buf += sizeof(journal_superblock_t);
+	offset += sizeof(journal_superblock_t);
+
+	/* seek to end of message buffer */
+	while (offset < sb->s_blocksize && *buf) {
+		buf += MSGLEN;
+		offset += MSGLEN;
+	}
+
+	if (offset+MSGLEN > sb->s_blocksize)
+		/* no space left in message buffer */
+		return;
+
+	len = snprintf(buf, MSGLEN, "%s: %s: ", where, function);
+	len += vsnprintf(buf + len, MSGLEN - len, fmt, args);
+}
+
+static void ext4_record_journal_errstr(struct super_block *sb,
+		const char *where, const char *function, ...)
+{
+	va_list args;
+
+	va_start(args, function);
+	ext4_record_journal_err(sb, where, function, "%s\n", args);
+	va_end(args);
+}
+
 void ext4_journal_abort_handle(const char *caller, unsigned int line,
 			       const char *err_fn, struct buffer_head *bh,
 			       handle_t *handle, int err)
 {
+	struct super_block *sb = handle->h_transaction->t_journal->j_private;
 	char nbuf[16];
 	const char *errstr = ext4_decode_error(NULL, err, nbuf);
 
@@ -347,6 +389,8 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 	printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
 	       caller, line, errstr, err_fn);
 
+	/* record error message in journal super block */
+	ext4_record_journal_errstr(sb, caller, err_fn, errstr);
 	jbd2_journal_abort_handle(handle);
 }
 
@@ -434,6 +478,11 @@ void __ext4_error(struct super_block *sb, const char *function,
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
 
+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(sb);
 }
 
@@ -458,6 +507,11 @@ void ext4_error_inode(struct inode *inode, const char *function,
 	printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
 	va_end(args);
 
+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(inode->i_sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(inode->i_sb);
 }
 
@@ -488,6 +542,11 @@ void ext4_error_file(struct file *file, const char *function,
 	printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, path, &vaf);
 	va_end(args);
 
+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(inode->i_sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(inode->i_sb);
 }
 
@@ -546,6 +605,9 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 	       sb->s_id, function, line, errstr);
 	save_error_info(sb, function, line);
 
+	/* record error message in journal super block */
+	ext4_record_journal_errstr(sb, __func__, function, errstr);
+
 	ext4_handle_error(sb);
 }
 
@@ -572,6 +634,11 @@ void __ext4_abort(struct super_block *sb, const char *function,
 	printk("\n");
 	va_end(args);
 
+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	if ((sb->s_flags & MS_RDONLY) == 0) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		sb->s_flags |= MS_RDONLY;
@@ -638,6 +705,11 @@ __acquires(bitlock)
 	printk(KERN_CONT "%pV\n", &vaf);
 	va_end(args);
 
+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	if (test_opt(sb, ERRORS_CONT)) {
 		ext4_commit_super(sb, 0);
 		return;
@@ -4141,11 +4213,34 @@ static void ext4_clear_journal_err(struct super_block *sb,
 	if (j_errno) {
 		char nbuf[16];
 
+		char *buf1, *buf2;
+		unsigned long offset1, offset2;
+		int len1, len2;
+
+		/* copy message buffer from journal to super block */
+		buf1 = (char *)journal->j_superblock;
+		offset1 = (unsigned long)buf1 % sb->s_blocksize;
+		buf1 += sizeof(journal_superblock_t);
+		offset1 += sizeof(journal_superblock_t);
+		len1 = sb->s_blocksize - offset1;
+		buf2 = (char *)EXT4_SB(sb)->s_es;
+		offset2 = (unsigned long)buf2 % sb->s_blocksize;
+		buf2 += sizeof(struct ext4_super_block);
+		offset2 += sizeof(struct ext4_super_block);
+		len2 = sb->s_blocksize - offset2;
+		if (len2 > len1)
+			len2 = len1;
+		if (len2 > 0 && *buf1)
+			memcpy(buf2, buf1, len2);
 		errstr = ext4_decode_error(sb, j_errno, nbuf);
 		ext4_warning(sb, "Filesystem error recorded "
 			     "from previous mount: %s", errstr);
 		ext4_warning(sb, "Marking fs in need of filesystem check.");
 
+		/* clear journal message buffer */
+		if (len1 > 0)
+			memset(buf1, 0, len1);
+
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
 		ext4_commit_super(sb, 1);
-- 
1.7.4.1

