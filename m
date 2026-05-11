Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192E371049
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501671; cv=none; b=By4D9pzIWMv6R73+BBHgdJ0CoDAIacH/ZomBGeG/X/1VVu7uddTGN3h2yNTJ0fYzRREbiU0nbcIlUnxDrC42NQpcqQdNiSZmHftHfVa7xlChsn52To00hcP6tEmFRoUJmeelNwDuKU5hZ9rOiPLsb9qazEp+2bEvEseIfZJ2s5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501671; c=relaxed/simple;
	bh=TdtjI3mhs/tf9ochvmYUHBpaLHBLyJSR4kkqvZeKDAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLW+0b6xyynRiIdyClaUOMVdKSxoX//7P1Kk5bqey9zHYdhc+CB+5KdkLREEK2RlpSFnAWFtX+tA1xixGYGhJGpZ8XpASFcKAZLq96ClE85WUqQ0IWFRLLyCdPrVpWJRDwlHTFNIf02PDcn0yB2Ls/Ts4rxpG2F4Ho7MvorZzlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lgrvfjmm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mqDVd82E; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aZWW7fFV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uAaxeGpE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lgrvfjmm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mqDVd82E";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aZWW7fFV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uAaxeGpE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BB5C5CEF2;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+cZ4JZ7sAlSn+m8mIX5c82uUqoNdVkPMlAgPrOjnNM=;
	b=lgrvfjmmhitDBAItv5F+9a+8CauM2NFPdT4Bw0lTqykHU++1xXNEMgMTXX7tsfuGgULH2P
	GFD+Mkyce0UL1QsykLsJeOFvDcXFUGPFb36+0jffYY+ygASYA41F7EG/2Y10ZsZkwsETGu
	5dG+HQtYN9o8GRlSMc3IKiJ61QLVA3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+cZ4JZ7sAlSn+m8mIX5c82uUqoNdVkPMlAgPrOjnNM=;
	b=mqDVd82Eb53brDxtXA7Rl54f4pxnPYdJJiqjOwA3rydD+xSNBGv9M4/GydDMUH5oB+EVxT
	JVERRbxQVyFKx/CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aZWW7fFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uAaxeGpE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+cZ4JZ7sAlSn+m8mIX5c82uUqoNdVkPMlAgPrOjnNM=;
	b=aZWW7fFVHrluKIDRQnvVaY4ScyWW4Kfo1ci7cPh4OP0dJKaNuIYE52zqVjjYljMOUkoCwr
	ED98rA73iYI4OAhVKCo1FUPwYhycsk0ax+DR87jjZNUsJLLJWYah19AKGsecJed6BiSDrI
	AOGtZHwudh3L2QI+HVgtaoytRAnVz+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+cZ4JZ7sAlSn+m8mIX5c82uUqoNdVkPMlAgPrOjnNM=;
	b=uAaxeGpEFQCi2jEO8iU7X2ru19rEuF/T+N3Y4YjGCERoLmszdaIsIKsU/WcA2XRP5CNfgP
	iM661fEuWoB0NtDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0252B593AA;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JKaOABPIAWrMWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75473A07A0; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/9] ext4: Allocate mapping_metadata_bhs struct on demand
Date: Mon, 11 May 2026 14:13:52 +0200
Message-ID: <20260511121356.241821-11-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5683; i=jack@suse.cz; h=from:subject; bh=TdtjI3mhs/tf9ochvmYUHBpaLHBLyJSR4kkqvZeKDAQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgFIEzKPdAvHNuTkNeb/aGQ59nl8Ign7J0SF asz056TH/6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHIBQAKCRCcnaoHP2RA 2fBLB/4ljaWSCPdDWKcwyxICDojxg9P6c/MVoG82LRQlH40NqB2VZSZ7Y0z3rzC8JCWO9RgGYJn oop6aSEGSuPYAxKmp8f6eSbnpZWtrvjRQukIBjMYcUaBMGmgqOKZg2rQY3W769v125NhqAb6ExF 2I0CmYsM2qHTpEpxS6oxeYEFNGRD9a89wknQEdhPG+OBekoYowHOPZ6kNYTxsZA+WPbpwawL3fo n/UmeZQIsg2wNf5FHgkn0JNZr9FdGrhEAyzdzsmtqByybd9klKDgVNrK5JlRYmj9FX1Vto2dirX B+9860mFGr/wqJuoF/ERjMCYQaKBMJ9bLppvgFlFGEdUrLvl
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.cz:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 1BB5C5CEF2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.51

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
 fs/ext4/super.c     |  8 +++++---
 5 files changed, 40 insertions(+), 15 deletions(-)

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
index 9a8c225f2753..74f05bd0cdde 100644
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
+	 * leaving filesystem corrupyted
+	 */
+	mmb = kmalloc_obj(*mmb, GFP_KERNEL | __GFP_NOFAIL);
+	mmb_init(mmb, inode->i_mapping);
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
index 924726dcc85f..e25d365e1179 100644
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
+	ret = mmb_fsync_noflush(file, EXT4_I(inode)->i_metadata_bhs,
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
index 6a77db4d3124..92134ea4620c 100644
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
 
@@ -1527,8 +1527,10 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	if (!EXT4_SB(inode->i_sb)->s_journal)
-		mmb_invalidate(&EXT4_I(inode)->i_metadata_bhs);
+	if (EXT4_I(inode)->i_metadata_bhs) {
+		mmb_invalidate(EXT4_I(inode)->i_metadata_bhs);
+		kfree(EXT4_I(inode)->i_metadata_bhs);
+	}
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	/*
-- 
2.51.0

