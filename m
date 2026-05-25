Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24073E0248
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699516; cv=none; b=Nl902smSY9AjEkDI2vyujT9Zzs/MQV3RcxeTnJKyyUcnR27mSgza6a9GyqAVr2B3ox3AOA0uSReDGbQKyhHc/OWLphGXHniaUWrtM+J8wekzjCjWdcMdMm/raigqeSz3irYMtTeelEZs8EhZq8/Beluuwxn8mlQdBGKJdAV2RZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699516; c=relaxed/simple;
	bh=QZm13v1x9lSEtFStoVxLSS8Jd26aNM7OsyC54YBbm9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a38ZbIw1Zy2Uv9QnsC1zMgUHB9C/DrehW8PEgGGC1h+dg+LgLDvNPGrwUTcXAolXgbGY0MNtNc6J5nsBjl0GqJp72F9rIsCacEj2Q2kVveuJLKfDMx1pMPQvVhWWy2MBfs7r7S5mI5xQ+m1R/3ly+f27vsZmgOwZoW6GmwwdfEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5692A6B2D5;
	Mon, 25 May 2026 08:58:33 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 443E959B71;
	Mon, 25 May 2026 08:58:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KUyoEDkPFGq6bQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3E40A08D7; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 02/10] ext4: Allocate mapping_metadata_bhs struct on demand
Date: Mon, 25 May 2026 10:58:08 +0200
Message-ID: <20260525085821.769119-12-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5971; i=jack@suse.cz; h=from:subject; bh=QZm13v1x9lSEtFStoVxLSS8Jd26aNM7OsyC54YBbm9k=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8u/UBI1EELMquRTUu1ujZcgKzOgGTtF7LCU tyN6RGlWvmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPLgAKCRCcnaoHP2RA 2b6FB/9Aid0EdBBjFKRqn+yTcueT2tmt/unCXOVBl+OOivljhXM0Beq6XGMCodivf3SxXCVWAeK KXqqYvvZAebdZ+TZr1TlaDG/OFcIlfJ4Xb9dJNATyW1mJbZ6yGhnx4vTH4A/Y65SZsXCe4kf/nP tnZiYDDQwruqcyzs7/bqd1P2mTztIHqfTFd/CIpb3DvBGvjKzSl/tJ1ZKqfAYRJdMb2j2/Owhp2 +k/cLtZLuJmnZpKbVjC861KVqUq9YNa7gQobkr1YXJWv8cYOhEGMpHvK6ig9OoGUK/j1hj/7KO1 b5RPAnDUI7rTmARqSNzB1BH0uVpOd9gxPyya48qYlGlNRkE8
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 5692A6B2D5
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO

Currently every ext4 inode gets mapping_metadata_bhs struct although it
is only needed when running without a journal and only for inodes where
any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
when dirtying the first metadata buffer for the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      |  2 +-
 fs/ext4/ext4_jbd2.c | 24 +++++++++++++++++++++---
 fs/ext4/fsync.c     | 12 ++++++++----
 fs/ext4/inode.c     |  9 +++++----
 fs/ext4/super.c     |  7 ++++---
 5 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..6bb29a20420f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1117,7 +1117,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
-	struct mapping_metadata_bhs i_metadata_bhs;
+	struct mapping_metadata_bhs *i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..752326f3b653 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -350,6 +350,21 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 	return 0;
 }
 
+static void ext4_inode_attach_mmb(struct inode *inode)
+{
+	struct mapping_metadata_bhs *mmb;
+
+	/*
+	 * It's difficult to handle failure when marking buffer dirty without
+	 * leaving filesystem corrupted
+	 */
+	mmb = kmalloc_obj(*mmb, GFP_NOFS | __GFP_NOFAIL);
+	mmb_init(mmb, &inode->i_data);
+	/* Someone swapped another mmb before us? */
+	if (cmpxchg(&EXT4_I(inode)->i_metadata_bhs, NULL, mmb))
+		kfree(mmb);
+}
+
 int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 handle_t *handle, struct inode *inode,
 				 struct buffer_head *bh)
@@ -389,11 +404,14 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 					 err);
 		}
 	} else {
-		if (inode)
+		if (inode) {
+			if (!EXT4_I(inode)->i_metadata_bhs)
+				ext4_inode_attach_mmb(inode);
 			mmb_mark_buffer_dirty(bh,
-					      &EXT4_I(inode)->i_metadata_bhs);
-		else
+					      EXT4_I(inode)->i_metadata_bhs);
+		} else {
 			mark_buffer_dirty(bh);
+		}
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
 			if (buffer_req(bh) && !buffer_uptodate(bh)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 924726dcc85f..c104f55a0242 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -46,6 +46,7 @@
 static int ext4_sync_parent(struct inode *inode)
 {
 	struct dentry *dentry, *next;
+	struct mapping_metadata_bhs *mmb;
 	int ret = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
@@ -68,9 +69,12 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		ret = mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
-		if (ret)
-			break;
+		mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
+		if (mmb) {
+			ret = mmb_sync(mmb);
+			if (ret)
+				break;
+		}
 		ret = sync_inode_metadata(inode, 1);
 		if (ret)
 			break;
@@ -89,7 +93,7 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	};
 	int ret;
 
-	ret = mmb_fsync_noflush(file, &EXT4_I(inode)->i_metadata_bhs,
+	ret = mmb_fsync_noflush(file, READ_ONCE(EXT4_I(inode)->i_metadata_bhs),
 				start, end, datasync);
 	if (ret)
 		return ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..3e66e9510909 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -195,9 +195,8 @@ void ext4_evict_inode(struct inode *inode)
 			ext4_warning_inode(inode, "data will be lost");
 
 		truncate_inode_pages_final(&inode->i_data);
-		/* Avoid mballoc special inode which has no proper iops */
-		if (!EXT4_SB(inode->i_sb)->s_journal)
-			mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
+		if (EXT4_I(inode)->i_metadata_bhs)
+			mmb_sync(EXT4_I(inode)->i_metadata_bhs);
 		goto no_delete;
 	}
 
@@ -3451,6 +3450,7 @@ static bool ext4_release_folio(struct folio *folio, gfp_t wait)
 static bool ext4_inode_datasync_dirty(struct inode *inode)
 {
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct mapping_metadata_bhs *mmb;
 
 	if (journal) {
 		if (jbd2_transaction_committed(journal,
@@ -3461,8 +3461,9 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 		return true;
 	}
 
+	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
+	if (mmb && mmb_has_buffers(mmb))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..7fc2cff708cc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1430,7 +1430,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
-	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+	ei->i_metadata_bhs = NULL;
 	return &ei->vfs_inode;
 }
 
@@ -1448,6 +1448,7 @@ static int ext4_drop_inode(struct inode *inode)
 static void ext4_free_in_core_inode(struct inode *inode)
 {
 	fscrypt_free_inode(inode);
+	kfree(EXT4_I(inode)->i_metadata_bhs);
 	if (!list_empty(&(EXT4_I(inode)->i_fc_list))) {
 		pr_warn("%s: inode %llu still in fc list",
 			__func__, inode->i_ino);
@@ -1527,8 +1528,8 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	if (!EXT4_SB(inode->i_sb)->s_journal)
-		mmb_invalidate(&EXT4_I(inode)->i_metadata_bhs);
+	if (EXT4_I(inode)->i_metadata_bhs)
+		mmb_invalidate(EXT4_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	/*
-- 
2.51.0

