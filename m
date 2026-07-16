Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE642A7AF
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213772; cv=none; b=S9g0GWtXPe9PEnvFMs/cC3n63ntVOfMROSEABMrWQR2RF5Jo864iY2v0S0y5CpwkkS4iNgGPxQJo3OdZv08c89cKUsyKBZJAc1SCGZrcrW87EMZen7u/0See2S/EaVK4YjUETEcb93NlSk60DQtgNONY3JusacnypkVkH6Lwbb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213772; c=relaxed/simple;
	bh=RnR7wJ6UBFjJYQ3neMTfo+BwEPdhTLE68eu7xMB8aIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEZBdCRBcOq0kqFahNAwzPWLaLuHPUaL9jl7gBg5uGx8/qS7sFdrhGjbFwl+VSSJAbv7Y3hkKC0oKPPPPZ3BGYdb38k+3tlv3V13B01ho8U3q8HBbBBGLKgfzGfOitoNy9cjcfBJ/67sZVCYRDVYlh5Va8ZAdoxR/ULewJzp3Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4369D789D0;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EE7A779AD;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4kGKB/3wWGrkXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 68EF0A0921; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 04/21] ext4: Allocate mapping_metadata_bhs struct on demand
Date: Thu, 16 Jul 2026 16:55:26 +0200
Message-ID: <20260716145527.3580300-25-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6911; i=jack@suse.cz; h=from:subject; bh=RnR7wJ6UBFjJYQ3neMTfo+BwEPdhTLE68eu7xMB8aIw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDiIVgQt4sXaBj+SzvOeUTRLCmUTdMnIp9FD 5FWHdbYhcSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw4gAKCRCcnaoHP2RA 2SdTB/4vzQSBhFZ1pI3K+4k4Slev1HpC76BDg24rTLgGRIi0A4Qrwb11RUpWEbJXHjrwqoNo2OV /4Dfa+F5/2ozgoQtBlwvJ/whaeFfSspIrNXM/xIgNtur5DTBB8xfwlAMQpt2Luj+cksTpzgW1vQ 251nmF8FNbO6obQRjBHTQtpcDIe+HYrmIwLQx77edvAFDdBTNG8at7Dpkve6hjmBfnkhaR2jEd7 4jBsCuItDiYM2nz+3L+fLxbYS/OORY913t6wGRqMoJgrGW3NekOsQFOFitk/dnQaAVluULPACYp kViwhik4jki8+zRestiZIX9TfXYjYtt23PeTEsi0NkJCIIfE
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 4369D789D0
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
index 9a8c225f2753..3b2f8ac20bf8 100644
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

