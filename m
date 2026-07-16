Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F542FCDA
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213811; cv=none; b=G9zEang5NGMNo5kj48CfVv+AlNuTkjANS+X3nCyrOWB7kQupCHG5endlFKg8zKNpZq6Tk2EgVMuollv9c74we0Mif3PNwNVP71VebBpu8nynIENtSpK2FmWP08tTHRqcZqTVcEZtV2kYhoKOYGN1GrV5uQ9hHa3cmP6VE0aPe9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213811; c=relaxed/simple;
	bh=mTaILrAfobXhcPocfuLsOOLlSIpfjVN1LfnTVAF9Cp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/U0ZaEGPFiuPJvi1U8l89gESiuHL/cfsCZQiOhpE2PuzTQgnnU8sNZky8dwmhsbA9d0tkg8dEVnD/eo6Gqc8rykJxfSdqj20aOBS6f0zmYJT3j7StxzurJ5NT6zQFnKkQ0i9Lh4uChxwA1P4Gg9/4K+o3G8FQlxFSIJXRhNjJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA9D83E4A;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1B39779AE;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2k5ILwXxWGoWXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A9543A12F2; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 17/21] ext4: Fix data integrity writeout issues in nojournal mode
Date: Thu, 16 Jul 2026 16:55:39 +0200
Message-ID: <20260716145527.3580300-38-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6095; i=jack@suse.cz; h=from:subject; bh=mTaILrAfobXhcPocfuLsOOLlSIpfjVN1LfnTVAF9Cp0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDtv6vVRyYZjIqm/dpbqCC1T6MFpno1tJHTg 6IdofZXi9WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw7QAKCRCcnaoHP2RA 2WTqB/4iEs+LzpH5ALcxNHOhe9UC/gATSUob2bfghaLQmGECABrGx6yahLxLi3BP3K48tlu8w/c vzNBmeglc6w8ZtRygUCZFUl+o2NeZitfOTLaG0+w+nxJ2mwCspQBoZqBeziW5IJxKVcJZypx6Ff qUuAyOPYnsgQLKrKxakxl9pzX43vzy16z1qJ0nxzhWUKqcUVw9XfUtxHWSilAtrJBx/Y41spHOq mKXStHCcSvj8BfZyXGRt00Q0gkRUhnj+UGf1ySK/Xwfn/zOMVgOLxzHHLg6oRU+PNoNXUFLCG5i Lu0wmun6L80TzZyovibMSJrutNhPi8PPsK4vlSbW3+XFUX3H
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: CA9D83E4A
X-Rspamd-Action: no action

Several racing fsyncs on ext4 in nojournal mode could result in some
fsync returning earlier than all metadata buffers were properly
persisted. Also ext4_fsync() in nojournal mode was somewhat inefficient
because it was always writing out the inode regardless whether it was
dirty or not.

Fix these issues by using new .sync_inode_metadata method which makes
sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback in nojournal mode. This also somewhat simplifies
the nojournal mode fsync handling.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/fsync.c | 28 +++++-----------------------
 fs/ext4/inode.c | 44 +++++++++++++++++++++++++++++---------------
 fs/ext4/super.c |  7 ++++++-
 4 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 64f8f63f4415..0f06155a35a6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3166,6 +3166,7 @@ extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	__ext4_iget((sb), (ino), (flags), __func__, __LINE__)
 
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
+extern int  ext4_sync_inode_metadata(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct mnt_idmap *, struct dentry *,
 			 struct iattr *);
 extern u32  ext4_dio_alignment(struct inode *inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index b7ea4433f4be..2999c2cc8fcf 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -46,7 +46,6 @@
 static int ext4_sync_parent(struct inode *inode)
 {
 	struct dentry *dentry, *next;
-	struct mapping_metadata_bhs *mmb;
 	int ret = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
@@ -69,12 +68,6 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		mmb = ext4_i_metadata_bhs(inode);
-		if (mmb) {
-			ret = mmb_sync(mmb);
-			if (ret)
-				break;
-		}
 		ret = sync_inode_metadata(inode, 1);
 		if (ret)
 			break;
@@ -87,22 +80,11 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 				int datasync, bool *needs_barrier)
 {
 	struct inode *inode = file->f_inode;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = 0,
-	};
 	int ret;
 
-	ret = mmb_fsync_noflush(file, ext4_i_metadata_bhs(inode),
-				start, end, datasync);
+	ret = sync_inode_metadata(inode, 1);
 	if (ret)
 		return ret;
-
-	/* Force writeout of inode table buffer to disk */
-	ret = ext4_write_inode(inode, &wbc);
-	if (ret)
-		return ret;
-
 	ret = ext4_sync_parent(inode);
 
 	if (test_opt(inode->i_sb, BARRIER))
@@ -160,6 +142,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (sb_rdonly(inode->i_sb))
 		goto out;
 
+	ret = file_write_and_wait_range(file, start, end);
+	if (ret)
+		goto out;
+
 	if (!EXT4_SB(inode->i_sb)->s_journal) {
 		ret = ext4_fsync_nojournal(file, start, end, datasync,
 					   &needs_barrier);
@@ -168,10 +154,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = file_write_and_wait_range(file, start, end);
-	if (ret)
-		goto out;
-
 	/*
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
 	 *  Metadata is in the journal, we wait for proper transaction to
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e6acef486ee1..0c220b535590 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5842,24 +5842,38 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 						EXT4_I(inode)->i_sync_tid);
 	} else {
-		struct ext4_iloc iloc;
+		set_inode_metadata_writeback(inode);
+	}
+	return err;
+}
 
-		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
+int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
+{
+	struct ext4_iloc iloc;
+	struct mapping_metadata_bhs *mmb;
+	int err;
+
+	/* We should only get here in nojournal mode */
+	if (WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal))
+		return -EFSCORRUPTED;
+
+	err = __ext4_get_inode_loc_noinmem(inode, &iloc);
+	if (err)
+		return err;
+	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
+	if (mmb) {
+		err = mmb_sync(mmb);
 		if (err)
-			return err;
-		/*
-		 * sync(2) will flush the whole buffer cache. No need to do
-		 * it here separately for each inode.
-		 */
-		if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
-			sync_dirty_buffer(iloc.bh);
-		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
-			ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
-					       "IO error syncing inode");
-			err = -EIO;
-		}
-		brelse(iloc.bh);
+			goto out;
+	}
+	sync_dirty_buffer(iloc.bh);
+	if (buffer_write_io_error(iloc.bh)) {
+		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
+				       "IO error syncing inode");
+		err = -EIO;
 	}
+out:
+	brelse(iloc.bh);
 	return err;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8671fa1209dd..ae33f5bcb133 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1608,9 +1608,13 @@ static int ext4_nfs_commit_metadata(struct inode *inode)
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL
 	};
+	int ret;
 
 	trace_ext4_nfs_commit_metadata(inode);
-	return ext4_write_inode(inode, &wbc);
+	ret = ext4_write_inode(inode, &wbc);
+	if (!ret && inode_state_read_once(inode) & I_METADATA_WRITEBACK)
+		ret = ext4_sync_inode_metadata(inode, &wbc);
+	return ret;
 }
 
 #ifdef CONFIG_QUOTA
@@ -1667,6 +1671,7 @@ static const struct super_operations ext4_sops = {
 	.free_inode	= ext4_free_in_core_inode,
 	.destroy_inode	= ext4_destroy_inode,
 	.write_inode	= ext4_write_inode,
+	.sync_inode_metadata = ext4_sync_inode_metadata,
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
-- 
2.51.0

