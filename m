Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954DC3A5438
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016484; cv=none; b=VH9KEjP369sesovKzeL292ENdMuJ4oEgH/KOC/505+bvRVk06vCye5cnQ6/iZVN7IhPtqbqiXX/Fu3GPMn1LJdK+sYfTOhJyi0O0XoJD3jHPZIEVZ/BlWKKntbxxy1CfWqXOmYmIBWFZ67fwRDEgi8yZKQzPcHFdHutULTlI6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016484; c=relaxed/simple;
	bh=kVVzwgAvTmA1fP+YJ2cYW7gBnPflxPeKoeoC1LO0pVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfJbbRtbmKDgZsc3mhINaFxhErdCvGMlIuny8Lwzt8I/J+18i8IvdU9NERicAt1aV0ufSxpnVaYMBzk7O9eH4wFbaFDTbtgQuRfvk0mlZuvVMO2lK1h4ZuXfdKIsSoEGBLgRFPsjvHkXnNCC0Dc93VeWzgoHAO/CIakRWzvSgS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pa/HEbXV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UNx0Pmh3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rvrsxc+k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZezLm41z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pa/HEbXV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UNx0Pmh3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rvrsxc+k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZezLm41z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA98D7435C;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pcj0oX+xmwt+qpXV4eUyR+3pBVmx1e4yycGZAd2yDw=;
	b=pa/HEbXVZmlLjaeFpbJRdzjtS5dPCKK0DkPM1oC//VodVWV4VaZdgJMGXjAI7ck4A0KWtF
	3yU6k9EOkPbF17uvkDXuK8ww1XFsNlVEp6a5z0YjaPNgWqSeN9ouYD+QcXFNwMa+vZia8B
	y2y+WJaV3O4IbTU2cGq+5MTaweDufIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pcj0oX+xmwt+qpXV4eUyR+3pBVmx1e4yycGZAd2yDw=;
	b=UNx0Pmh3YKgXL8aCOG3dhzHqGG5ieSEMeYfd2JyYVhYqD/0GuOwrtmzknyeQn2aSxF/2aj
	iagV974N8llLY9CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pcj0oX+xmwt+qpXV4eUyR+3pBVmx1e4yycGZAd2yDw=;
	b=rvrsxc+k6DlK8LlzLEhw6ffDZ8qFWKK15tJVOaOvwwN2LSaGk1P+07RuRWaXZH6panX5Ge
	By0DcCR/8d9CW34v6EzHu42VvA9A3DBFYMMYIVkf6DQLhgOG6D6b0BPbuPscvcjScaNSFY
	SR3CZSYM9S6dyeD1pKvxmI1gRCSJHaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pcj0oX+xmwt+qpXV4eUyR+3pBVmx1e4yycGZAd2yDw=;
	b=ZezLm41zB+oUhcl+gx1loSW8XrzqWQX1cU328rAn4BKWTc3/msZAhai3dGqISRgtM+Plbu
	WQMJSnnGPhaUl6BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6302779AA;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mwNKNCCsRmrzFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1A58DA10A6; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 04/19] ext4: Allocate mapping_metadata_bhs struct on demand
Date: Thu,  2 Jul 2026 20:21:01 +0200
Message-ID: <20260702182057.2832980-23-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6073; i=jack@suse.cz; h=from:subject; bh=kVVzwgAvTmA1fP+YJ2cYW7gBnPflxPeKoeoC1LO0pVg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwM4JXJqdDXYC3zXF1S4bUnh/DuLtY3lgO8R gucUbsyQG2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasDAAKCRCcnaoHP2RA 2fwyB/9QJm6N/KMVkHZNypzM6e5DIN4JHhmvPJZifSIQ1E5svmngTjiy9xoiCDaUTjiORrHWbFP O2Aj70CIsQ3RbcEyWSYoV0bYScoWTU+1dp6wiD+B/myB9Q2g7HTDsvNlpTEYbmMT921iPwGsSDp MVOu+OL6h7UtUXxPFtOiko4TMLYjLQX2YE1YvUXr9rX7o7iGAJjcmvrnvL2GGUogr70QG2CqWqw mDXHh0FIkHwkEagPclOE/UAmL85SkxYOOKbDKcIdjykMjXYCGC9U+4Wp/3r36WgyEutu+tkQpOM cOQwUwKe6P3AwdXk0YnU7vF9oKc9GD+N8Yi9wzzO6f9/uahV
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

Currently every ext4 inode gets mapping_metadata_bhs struct although it
is only needed when running without a journal and only for inodes where
any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
when dirtying the first metadata buffer for the inode.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      |  2 +-
 fs/ext4/ext4_jbd2.c | 24 +++++++++++++++++++++---
 fs/ext4/fsync.c     | 12 ++++++++----
 fs/ext4/inode.c     |  9 +++++----
 fs/ext4/super.c     |  7 ++++---
 5 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..36edde1bd031 100644
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
index ce99807c5f5b..363396b728f2 100644
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
 
@@ -3452,6 +3451,7 @@ static bool ext4_release_folio(struct folio *folio, gfp_t wait)
 static bool ext4_inode_datasync_dirty(struct inode *inode)
 {
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct mapping_metadata_bhs *mmb;
 
 	if (journal) {
 		if (jbd2_transaction_committed(journal,
@@ -3462,8 +3462,9 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
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
index 245f67d10ded..79c73219e9c6 100644
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
+	kfree(EXT4_I(inode)->i_metadata_bhs);
 	if (!list_empty(&(EXT4_I(inode)->i_fc_list))) {
 		pr_warn("%s: inode %llu still in fc list",
 			__func__, inode->i_ino);
@@ -1530,8 +1531,8 @@ static void destroy_inodecache(void)
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

