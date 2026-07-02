Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240003A6EF0
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016502; cv=none; b=L1Bs9RVde2To/ZjwbbLiEh0cJFVwcMA9GE7D/DrLCKiR2H9R0gMH5U9TOWjko4pidu9wXRqWQfeFGvxIHigQaOZtOczoJQN+4ti7fTb+GPqLar/vQcuNHprnD8t8kLvLoYu0kwsL+Nv7MafJyquwEV3DvlskOBWY6Uwqmdo9XEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016502; c=relaxed/simple;
	bh=NSguWTTZfQo8gidaU1DEhTm87XaDKrLOufqW+rKOP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMtX5vucL8ibhfrnW8HW4AA08g9OPFaLLUfrK3h9DwsIiLnrak/9ctLlV//CO/2jK80gePI9tDIbPeEuCp+04+yvaeslNgVKBwLT9sTNbnHq9b5P6gXxee2iog2Mik52gmSj9bsFjilIYXOTVPFIaE4oU/MhIKGLkrq8l1QgiFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D8EA74360;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57DDD779AD;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ut13FSGsRmoKGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 546A5A10B1; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 15/19] ext4: Fix data integrity writeout issues in nojournal mode
Date: Thu,  2 Jul 2026 20:21:12 +0200
Message-ID: <20260702182057.2832980-34-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6060; i=jack@suse.cz; h=from:subject; bh=NSguWTTZfQo8gidaU1DEhTm87XaDKrLOufqW+rKOP24=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLLc1oge68oWZ11g2npTRHBiU8Q5z5bimlsBBxqnl/q+u WcbErG0k9GYhYGRg0FWTJFldeRF7WvzjLq2hmrIwAxiZQKZwsDFKQATifnI/k/d/P9md+6sxGlP FDYqlXqH8pfKsevssnaaEW18vrTJ/Ff296Y3er3st6qmd7xkeJqiLXH+xLu2sE3f8v6WbTH/WiV ZOmd5usXi69syq40yk7qmRoTNn5L/y7RxymYLRWnXffNFtZ2Z39RtiZ7nYFfUfFfW9Lj1woV5uf 5ai04tjjr+SfWgiZt/9YuDS2eVXYw7eMDJMs6/5Wnu+wSdXVGG9XuDXOx8XSfu/6t5yoQ5wfxG7 rON11euCFieEb3nzmRpFjWluD/z9Vesfs54JLY27CKvZob6nX2hBb0ZfTYiCQu3x7O2X5VfVMys dUl3TbbanSv/YvRyebIr2x22MzTwyn9Mir214+xp06rVAA==
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
X-Rspamd-Queue-Id: 6D8EA74360
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
 fs/ext4/inode.c | 44 ++++++++++++++++++++++++++++----------------
 fs/ext4/super.c |  7 ++++++-
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 36edde1bd031..8f388e158dae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3155,6 +3155,7 @@ extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	__ext4_iget((sb), (ino), (flags), __func__, __LINE__)
 
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
+extern int  ext4_sync_inode_metadata(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct mnt_idmap *, struct dentry *,
 			 struct iattr *);
 extern u32  ext4_dio_alignment(struct inode *inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c104f55a0242..2999c2cc8fcf 100644
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
-		mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
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
 
-	ret = mmb_fsync_noflush(file, READ_ONCE(EXT4_I(inode)->i_metadata_bhs),
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
index 363396b728f2..b61ee75ecbdf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5839,24 +5839,36 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 						EXT4_I(inode)->i_sync_tid);
 	} else {
-		struct ext4_iloc iloc;
+		set_inode_metadata_writeback(inode);
+	}
+	return err;
+}
 
-		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
-		if (err)
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
+	sync_dirty_buffer(iloc.bh);
+	if (buffer_write_io_error(iloc.bh)) {
+		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
+				       "IO error syncing inode");
+		err = -EIO;
+		goto out;
 	}
+	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
+	if (mmb)
+		err = mmb_sync(mmb);
+out:
+	brelse(iloc.bh);
 	return err;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 79c73219e9c6..90d6d6b88673 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1606,9 +1606,13 @@ static int ext4_nfs_commit_metadata(struct inode *inode)
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL
 	};
+	int ret;
 
 	trace_ext4_nfs_commit_metadata(inode);
-	return ext4_write_inode(inode, &wbc);
+	ret = ext4_write_inode(inode, &wbc);
+	if (!ret)
+		ret = ext4_sync_inode_metadata(inode, &wbc);
+	return ret;
 }
 
 #ifdef CONFIG_QUOTA
@@ -1665,6 +1669,7 @@ static const struct super_operations ext4_sops = {
 	.free_inode	= ext4_free_in_core_inode,
 	.destroy_inode	= ext4_destroy_inode,
 	.write_inode	= ext4_write_inode,
+	.sync_inode_metadata = ext4_sync_inode_metadata,
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
-- 
2.51.0

