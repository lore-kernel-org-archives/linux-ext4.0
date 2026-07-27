Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739CF3F9A0D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149439; cv=none; b=hLqLzNUqRAGybUc+5l22un4ezyeKY1MDGG5lWNiYuHCBLMEFUILXMqM/QPjIVAH60LqHjuqF0DPv92V6uRKUgdybTpli8gRPoudEH/xoiOlXfdcgdoAG+DganlskGWnejHQBKhbRCj7ww/6RIq0q5ZT2RO8RXcE2u36WtqAojN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149439; c=relaxed/simple;
	bh=JoZ/xG2l3rVPxCaE4BHjJTfvnkkiuUvmhvDs+cTmZsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9pNCQlXe78buG7B0srwWl/9W0wLBHx1AEEfJKZZrb76VG7uRIJy98z++fbrWM8142odnXrUyShmIQgNJ8IjxrAtMSDLRAHPp3Q/9GBlIwAHnDP0NVa6Q8LSE1HNOCAMipovNx1SJjgKxusba1lTd890vKocF37Q83yrm1s/+vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a/VtOBPU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+1I48hxo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NtIy7fcR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A68yo9ye; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a/VtOBPU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+1I48hxo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NtIy7fcR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A68yo9ye"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F39A7DACE;
	Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9qFK1APQdrYT4LrC3apmEgzwa3Vnuqq2qRjFJEcgY=;
	b=a/VtOBPUwALiZ0+A8il+/7DKmJ0uDHRb5sFn/h6GC6q/uwG2W44qT7VG10x2oorZjBniOZ
	HYqSlHPX9H/457lzhf3581iuyXSmkTlXi4uBfkm2p09JsIeO9f7FUdYJX+7ByN568DUywZ
	4i/gKTWTP/qX8hiWDIQnivsPUvGdrKQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9qFK1APQdrYT4LrC3apmEgzwa3Vnuqq2qRjFJEcgY=;
	b=+1I48hxos3XDlRARrLErXx9yImr7zfGvmp/wrIgn0CL0aB/atYrzzsjhqonG2/ncK2lWe9
	vvSwEpOpfkRVeLDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9qFK1APQdrYT4LrC3apmEgzwa3Vnuqq2qRjFJEcgY=;
	b=NtIy7fcRlA76FoQdu6kLOYaPO7zKF44hxrDvYu9gE616BDBrdvThqBjxgqLz3Pou/HVmT3
	IHlYijWhEt+IxbT1Atrxw+G41BE40WNCJGFI0q8g8PEZCYUZoaJ3tgdAsDWms9ZvfXuWez
	e63ERddNZZm1pWqgaitkAJQNsH6Xb0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9qFK1APQdrYT4LrC3apmEgzwa3Vnuqq2qRjFJEcgY=;
	b=A68yo9yeCVH7ymtK2GeViMppvLR/wv7BsDh0Qu9dcBjgTYUcE+JzjNFSO+sHhrCBNE/VCT
	4rWXHH1hTSnkDLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83CC1779E7;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GJwWIMw3Z2osawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7E66CA133D; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 17/20] ext4: Fix data integrity writeout issues in nojournal mode
Date: Mon, 27 Jul 2026 12:49:35 +0200
Message-ID: <20260727104923.3828017-37-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8203; i=jack@suse.cz; h=from:subject; bh=JoZ/xG2l3rVPxCaE4BHjJTfvnkkiuUvmhvDs+cTmZsE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzfBc/8XJGgFZ63rgizdFNmFXmhU1O9qICJDa T4glp2BUgOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3wQAKCRCcnaoHP2RA 2fzHB/4vLuKM2GYyiQfWqH5BDARZ3zNfL3nj+Jqz2J3VhvbEiNUsRQQm7xWcRdzfUuEhBYtNl5+ NnhrOo2OodptwWv3i6O6a4zy+vKQ9IuWeMnXMjGJKmvwweFF/xwpxZm4Sd6tk+mnMrsheHYRqpM RJdDhUlQDTHQM8iFSo2rN8M5xDO8XgLudbUFGXGRg+imoVNQ4WVovBzKuvyBGqznaIfg47sKgnI kISeM8SAHnQcCeO4I68gCrZcWoJK73mFoXq+b+uykKco6UgWpG2uOVXzRDygONhpBHwizupwKpe D2+tu358ZOUd0fgT4XK9JUXK/Zo3ieokVONoeDoUwHahD9WO
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,iloc.bh:url,suse.cz:email,suse.cz:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo,iloc.bh:url];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

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
 fs/ext4/fsync.c | 28 +++------------
 fs/ext4/inode.c | 90 ++++++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c |  7 +++-
 4 files changed, 72 insertions(+), 54 deletions(-)

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
index e6acef486ee1..7a1f961cd11c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5799,6 +5799,10 @@ static int ext4_do_update_inode(handle_t *handle,
  * ext4_mark_inode_dirty().  This is a correctness thing for WB_SYNC_ALL
  * writeback.
  *
+ * For nojournal mode all the work is done in ext4_sync_inode_metadata()
+ * because inode content is already copied into raw inode buffer and inode
+ * is marked with I_METADATA_WRITEBACK.
+ *
  * Note that we are absolutely dependent upon all inode dirtiers doing the
  * right thing: they *must* call mark_inode_dirty() after dirtying info in
  * which we are interested.
@@ -5824,42 +5828,54 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (unlikely(err))
 		return err;
 
-	if (EXT4_SB(inode->i_sb)->s_journal) {
-		if (ext4_journal_current_handle()) {
-			ext4_debug("called recursively, non-PF_MEMALLOC!\n");
-			dump_stack();
-			return -EIO;
-		}
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		return 0;
 
-		/*
-		 * No need to force transaction in WB_SYNC_NONE mode. Also
-		 * ext4_sync_fs() will force the commit after everything is
-		 * written.
-		 */
-		if (wbc->sync_mode != WB_SYNC_ALL || wbc->for_sync)
-			return 0;
+	if (ext4_journal_current_handle()) {
+		ext4_debug("called recursively, non-PF_MEMALLOC!\n");
+		dump_stack();
+		return -EIO;
+	}
+
+	/*
+	 * No need to force transaction in WB_SYNC_NONE mode. Also
+	 * ext4_sync_fs() will force the commit after everything is
+	 * written.
+	 */
+	if (wbc->sync_mode != WB_SYNC_ALL || wbc->for_sync)
+		return 0;
 
-		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
+	return ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 						EXT4_I(inode)->i_sync_tid);
-	} else {
-		struct ext4_iloc iloc;
+}
+
+int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
+{
+	struct ext4_iloc iloc;
+	struct mapping_metadata_bhs *mmb;
+	int err;
 
-		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
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
 	}
+	sync_dirty_buffer(iloc.bh);
+	if (buffer_write_io_error(iloc.bh)) {
+		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
+				       "IO error syncing inode");
+		err = -EIO;
+	}
+out:
+	brelse(iloc.bh);
 	return err;
 }
 
@@ -6407,6 +6423,20 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
 	err = ext4_do_update_inode(handle, inode, iloc);
 	put_bh(iloc->bh);
+	/*
+	 * Mark that there's metadata writeout pending for the inode so that it
+	 * gets properly flushed on fsync(2) and similar.
+	 */
+	if (!EXT4_SB(inode->i_sb)->s_journal) {
+		/*
+		 * Inode didn't need to go through dirtying, make sure it is
+		 * attached to wb so that writeback can handle it.
+		 */
+		spin_lock(&inode->i_lock);
+		inode_attach_wb(inode, NULL);
+		spin_unlock(&inode->i_lock);
+		set_inode_metadata_writeback(inode);
+	}
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

