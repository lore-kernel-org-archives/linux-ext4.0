Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02342E8CA
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213793; cv=none; b=s3BUqWHQrlKFZEW77iOFv3DyY05ciYJ7jvsu8MaW3ji8sZ0uzEPBNy5XMFFm/XD40M85rvINi9S+k8nUohaqaDTNQeVN5bjy0xDGqm5bsm1uJLGusJMVtTHxh7ZWbZMD47gbRThbknnMQvOuUtUtIPKp3OO31aSrudgMBYJ0PFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213793; c=relaxed/simple;
	bh=+94Oy6r7XyjEXaUjr52gQfBz59gHpcpLo/HFEAnP968=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gem8w8LN6Y5qyCCWWc+zE55CYWNKvWH5ZLBzdPokNlayggYkTPkL7wtxg99NnYXUJB/94WXDwc18B0tWAh5sITHpkE23w3ANxtMXQcbAoDTVgAXQmunigQIB4wjrq8Df4z++p7PThFmQXm1QukDPlG4LWi6DpU3/asZPQvkXlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EF753E42;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66105779AD;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MnjrGAXxWGr7XQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8216DA09FE; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 09/21] ext2: Fix data integrity writeout issues
Date: Thu, 16 Jul 2026 16:55:31 +0200
Message-ID: <20260716145527.3580300-30-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5866; i=jack@suse.cz; h=from:subject; bh=+94Oy6r7XyjEXaUjr52gQfBz59gHpcpLo/HFEAnP968=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDmMAYmZHyoHpceZrxYTHfi+lLEQ+eeP7zuJ CwDI8xzDaeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw5gAKCRCcnaoHP2RA 2Z/RB/99VyGiWxdxzLjXtT4bVs85mPSMdkX5YNS9Hc457wLk23rvZFyjsVjxQh7X8oA5UaifqRX 2B3pnqKufhRjSNlRSaKoTYkc9pq8lMvow3ahdMBp0qdaGt8AnIS8sdq6NCWxdIxLVrnKUbAOn3K y27EbCPzk5gjR+J16UR5j9WZtgbbpqV0qEBeMTUkOnednjPuHJxW2aTldSF8kCmGh6Lb/3wOEei BYkLfmg4raFcr9IrKp6Ys4nR+GYj7Ic5jcaHZQtAM3Td9G86t+e7fsB7ZzCsfIdQ949Mb+Daqcq lmR7LtoSrVF8BCQB+GiinwFifgVeuDvFcfH5HzMNs7KocWtr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 6EF753E42
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]

Ext2 could fail to properly write out inode on fsync(2) due to races
with WB_SYNC_NONE writeback. Several racing fsyncs could also result in
some fsync returning earlier than all metadata buffers were properly
persisted. Finally DIRSYNC handling was not properly persisting all
inode related metadata.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c   |  2 +-
 fs/ext2/ext2.h  |  3 +--
 fs/ext2/file.c  | 17 +----------------
 fs/ext2/inode.c | 43 +++++++++++++++++++++++++------------------
 fs/ext2/super.c |  1 +
 5 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 278d4be8ecbe..e17bbc7598c1 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -734,6 +734,6 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= ext2_fsync,
+	.fsync		= simple_fsync,
 	.setlease	= generic_setlease,
 };
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 79f7b395258c..5642451bf191 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -735,6 +735,7 @@ extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 /* inode.c */
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, struct writeback_control *);
+extern int ext2_sync_inode_metadata(struct inode *, struct writeback_control *);
 extern void ext2_evict_inode(struct inode *);
 void ext2_write_failed(struct address_space *mapping, loff_t to);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
@@ -772,8 +773,6 @@ extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
-extern int ext2_fsync(struct file *file, loff_t start, loff_t end,
-		      int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 8dca9ec4cacd..b9020df7d89e 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -47,21 +47,6 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
-int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	int ret;
-	struct inode *inode = file->f_mapping->host;
-	struct super_block *sb = inode->i_sb;
-
-	ret = mmb_fsync(file, &EXT2_I(inode)->i_metadata_bhs,
-			start, end, datasync);
-	if (ret == -EIO)
-		/* We don't really know where the IO error happened... */
-		ext2_error(sb, __func__,
-			   "detected IO error when writing metadata buffers");
-	return ret;
-}
-
 static ssize_t ext2_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -213,7 +198,7 @@ const struct file_operations ext2_file_operations = {
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= ext2_file_open,
 	.release	= ext2_release_file,
-	.fsync		= ext2_fsync,
+	.fsync		= simple_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 904e70f3140e..99acd79a4af2 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -81,16 +81,11 @@ void ext2_evict_inode(struct inode * inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	if (want_delete) {
-		struct writeback_control wbc = {
-			.sync_mode = inode_needs_sync(inode) ? WB_SYNC_ALL :
-							       WB_SYNC_NONE,
-		};
-
 		sb_start_intwrite(inode->i_sb);
 		/* set dtime */
 		EXT2_I(inode)->i_dtime	= ktime_get_real_seconds();
 		mark_inode_dirty(inode);
-		ext2_write_inode(inode, &wbc);
+		sync_inode_metadata(inode, inode_needs_sync(inode));
 		/* truncate to 0 */
 		inode->i_size = 0;
 		if (inode->i_blocks)
@@ -1560,20 +1555,32 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	/*
-	 * For sync(2) the generic code will call sync_blockdev() to write
-	 * all metadata more efficiently.
-	 */
-	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
-				sb->s_id, (unsigned long) ino);
-			err = -EIO;
-		}
-	}
 	ei->i_state &= ~EXT2_STATE_NEW;
 	brelse (bh);
+	set_inode_metadata_writeback(inode);
+	return err;
+}
+
+int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
+{
+	struct buffer_head *bh;
+	struct ext2_inode *raw_inode = ext2_get_inode(inode->i_sb, inode->i_ino,
+						      &bh);
+	int err = 0;
+
+	if (IS_ERR(raw_inode))
+		return -EIO;
+	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
+	if (err)
+		goto out;
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		printk("IO error syncing ext2 inode [%s:%08lx]\n",
+		       inode->i_sb->s_id, (unsigned long)inode->i_ino);
+		err = -EIO;
+	}
+out:
+	brelse(bh);
 	return err;
 }
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3999f8f3b156..a40f530872a4 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -362,6 +362,7 @@ static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.free_inode	= ext2_free_in_core_inode,
 	.write_inode	= ext2_write_inode,
+	.sync_inode_metadata = ext2_sync_inode_metadata,
 	.evict_inode	= ext2_evict_inode,
 	.put_super	= ext2_put_super,
 	.sync_fs	= ext2_sync_fs,
-- 
2.51.0

