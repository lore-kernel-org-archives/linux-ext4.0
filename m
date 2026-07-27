Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5493F823E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149405; cv=none; b=lAFKl+5nNBuWa4BoUz/fYjhYxc4a6aBhgo0gpkPXgu8ZEjC72tvOMd+ZY3I1HMc/pWb6yPEUNy/ENuNQKr7AM52GMTKpGidNanhgDyz7qKErCst3vGuIcpCxr/6wPx5TwFCT4RSLyvx0XZJsx9Ewfj3vTnJX4P2q7HXVSD2zMNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149405; c=relaxed/simple;
	bh=5IVNvbAYhDutNaljd43uNQBoGbKN0Xp+xwXKr2nP5xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPo4x+Au8dTLlhEwRNA4C2wd6CWZMrb2K2F3/Fx1HIetIeuQ/1HfyVoe4EyKzyGC955csrfjVyRrImZC2V2nTnDERCAUEBkEvNVLp9sGqSLzZOEsYdGFHCNZBPJSFQvB4Q8cC3QabGqLK/I2/qg5VMlvfGL8c0aLOPBGMywthZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SqmAhc0u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8rN9MrEV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=twj6ABoG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a9Mynn5/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SqmAhc0u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8rN9MrEV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="twj6ABoG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a9Mynn5/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E7773444B;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uj0ezlHYNn89ML0VVtf/MZNtYyhzN7D0oMffXGCr2U8=;
	b=SqmAhc0u3rGioHRMvKIE3VuDgAIKp/B4I78GafY5MHhhdmZYFD4iEWLGu+B9KcmPyN2rtJ
	Uquj5i+SJW6ZP4tT46WbPxsvcf4+D3nyNzi3fDdMb+bcUjcghoFjBs8d5UE/SZBT5caWWy
	EG89wlF0JWf2pOLqkomCWCCTx2tQZVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uj0ezlHYNn89ML0VVtf/MZNtYyhzN7D0oMffXGCr2U8=;
	b=8rN9MrEVz+OrLy8q++viz8Ts3OVCuEaDY7McvdoTXBgRUrYQvcOMiGaoWcJiWuChkKFSdy
	IChj5J+YueL71VAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uj0ezlHYNn89ML0VVtf/MZNtYyhzN7D0oMffXGCr2U8=;
	b=twj6ABoGUjzFyHqbzQeMe0Wdt0hru5PJCw+CsZe9SnTcdmW+q/OJnSt31kFC0LspInwq5U
	ooMt54Vj+3lehunsiZEash5ku7dvns77D5aqmWGym7t0cKSYHzPC9ec7yEW8kFn4twCeE8
	heMiLpyWVS6m0vnnE7K49/cFV8ulicI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uj0ezlHYNn89ML0VVtf/MZNtYyhzN7D0oMffXGCr2U8=;
	b=a9Mynn5/0LUuVD4JvK8QV/Cq6kgtZ06AxMSdG5D511A6p3h4DLTzDFfdcZhJBe6klDnVeJ
	ECbDT+eB7WAQ7OBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3B09779CA;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nFStM8s3Z2oHawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3B31DA1322; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 04/20] ext4: Allocate mapping_metadata_bhs struct on demand
Date: Mon, 27 Jul 2026 12:49:22 +0200
Message-ID: <20260727104923.3828017-24-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6927; i=jack@suse.cz; h=from:subject; bh=5IVNvbAYhDutNaljd43uNQBoGbKN0Xp+xwXKr2nP5xY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze2pP35cbxaTZk1JHHieb04BwAVaan9zRfNi FfM3nXUFSuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3tgAKCRCcnaoHP2RA 2T7uB/4nwmKEdZzNWUz3hENND5gHx8wKtX8cKvKx5+aqQxhCm0zXoJ4WK3JFFOqkOq+mNzaWFTv mrhAZp1wl+BTHZ4R8jGxEcU81vwS2iw5jpnTibPvJYj/89IuSit8mGSCnZMvvbb3DjARZvwGjX7 YK8jJliQcGKvIDrk+1NxhOo58cTbwVruk37FtLVqkohWVsUC+McyxvCpMYynK8cLf2Dh81z6E6t jsiWF0WuM/2TWkM5tzfKlCrXTkITWfkwrJfRJ6YzCEpT8hYVDDLK6GS2wo/07ccTqbA/qG2OD6j j1Pl8S8jdYxybCuiotZdWub2EB+fv1cGZlBGANWur8wWD2Ym
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

Currently every ext4 inode gets mapping_metadata_bhs struct although it
is only needed when running without a journal and only for inodes where
any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
when dirtying the first metadata buffer for the inode.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      | 13 ++++++++++++-
 fs/ext4/ext4_jbd2.c | 25 +++++++++++++++++++++----
 fs/ext4/fsync.c     | 12 ++++++++----
 fs/ext4/inode.c     | 12 ++++++++----
 fs/ext4/super.c     |  9 ++++++---
 5 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..64f8f63f4415 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1151,7 +1151,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
-	struct mapping_metadata_bhs i_metadata_bhs;
+	struct mapping_metadata_bhs *i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
@@ -2126,6 +2126,17 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
 		!list_empty(&EXT4_I(inode)->i_orphan);
 }
 
+static inline struct mapping_metadata_bhs *ext4_i_metadata_bhs(
+							struct inode *inode)
+{
+	/*
+	 * i_metadata_bhs is set in ext4_inode_attach_mmb() using cmpxchg().
+	 * We use READ_ONCE when accessing i_metadata_bhs to make sure we get
+	 * consistent view for all accesses.
+	 */
+	return READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
+}
+
 /*
  * Codes for operating systems
  */
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..02b066299164 100644
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
+	mmb = kmalloc_obj(*mmb, GFP_NOFS | __GFP_NOFAIL | __GFP_ACCOUNT);
+	mmb_init(mmb, &inode->i_data);
+	/* Someone swapped another mmb before us? */
+	if (cmpxchg(&EXT4_I(inode)->i_metadata_bhs, NULL, mmb))
+		kfree(mmb);
+}
+
 int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 handle_t *handle, struct inode *inode,
 				 struct buffer_head *bh)
@@ -389,11 +404,13 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 					 err);
 		}
 	} else {
-		if (inode)
-			mmb_mark_buffer_dirty(bh,
-					      &EXT4_I(inode)->i_metadata_bhs);
-		else
+		if (inode) {
+			if (!ext4_i_metadata_bhs(inode))
+				ext4_inode_attach_mmb(inode);
+			mmb_mark_buffer_dirty(bh, ext4_i_metadata_bhs(inode));
+		} else {
 			mark_buffer_dirty(bh);
+		}
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
 			if (buffer_req(bh) && !buffer_uptodate(bh)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 924726dcc85f..b7ea4433f4be 100644
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
+		mmb = ext4_i_metadata_bhs(inode);
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
+	ret = mmb_fsync_noflush(file, ext4_i_metadata_bhs(inode),
 				start, end, datasync);
 	if (ret)
 		return ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..e6acef486ee1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -186,6 +186,8 @@ void ext4_evict_inode(struct inode *inode)
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
+		struct mapping_metadata_bhs *mmb;
+
 		/*
 		 * If there's dirty page will lead to data loss, user
 		 * could see stale data.
@@ -195,9 +197,9 @@ void ext4_evict_inode(struct inode *inode)
 			ext4_warning_inode(inode, "data will be lost");
 
 		truncate_inode_pages_final(&inode->i_data);
-		/* Avoid mballoc special inode which has no proper iops */
-		if (!EXT4_SB(inode->i_sb)->s_journal)
-			mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
+		mmb = ext4_i_metadata_bhs(inode);
+		if (mmb)
+			mmb_sync(mmb);
 		goto no_delete;
 	}
 
@@ -3452,6 +3454,7 @@ static bool ext4_release_folio(struct folio *folio, gfp_t wait)
 static bool ext4_inode_datasync_dirty(struct inode *inode)
 {
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct mapping_metadata_bhs *mmb;
 
 	if (journal) {
 		if (jbd2_transaction_committed(journal,
@@ -3462,8 +3465,9 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 		return true;
 	}
 
+	mmb = ext4_i_metadata_bhs(inode);
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
+	if (mmb && mmb_has_buffers(mmb))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..8671fa1209dd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1430,7 +1430,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
-	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+	ei->i_metadata_bhs = NULL;
 #ifdef CONFIG_LOCKDEP
 	lockdep_set_subclass(&ei->i_data_sem, I_DATA_SEM_NORMAL);
 #endif
@@ -1451,6 +1451,7 @@ static int ext4_drop_inode(struct inode *inode)
 static void ext4_free_in_core_inode(struct inode *inode)
 {
 	fscrypt_free_inode(inode);
+	kfree(ext4_i_metadata_bhs(inode));
 	if (!list_empty(&(EXT4_I(inode)->i_fc_list))) {
 		pr_warn("%s: inode %llu still in fc list",
 			__func__, inode->i_ino);
@@ -1529,9 +1530,11 @@ static void destroy_inodecache(void)
 
 void ext4_clear_inode(struct inode *inode)
 {
+	struct mapping_metadata_bhs *mmb = ext4_i_metadata_bhs(inode);
+
 	ext4_fc_del(inode);
-	if (!EXT4_SB(inode->i_sb)->s_journal)
-		mmb_invalidate(&EXT4_I(inode)->i_metadata_bhs);
+	if (mmb)
+		mmb_invalidate(mmb);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	/*
-- 
2.51.0

