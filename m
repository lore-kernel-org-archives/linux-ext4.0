Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694253A83A9
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016547; cv=none; b=dOJptgefXh81J6U4CeXN3f0kshsJmOZ1uP9Q4K2hdlNpAqyc84aASQuTWgrxXcD5fYWq1VKe0NwNGOyHScmuuVHujgS08URM0xG5UQ/gze0rOmMpLiKVwsBF7B7JD9xH4Qwp0TgPVDAG+TNdfqOHPLi5tEXQ+MqeuCk96cmPwNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016547; c=relaxed/simple;
	bh=9xT7bpdZnySg6yB0t+yiqHCsggtJ+bNKnSlpRPstIVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSw3NUXYepDlEGBYF3uMfMGV/iuHRAQXtwvoHmStr26rIOGp43LcBgWMx25sSUwdgvKf0eqzqHMkf/FHnJ26Jpcph7735mkrebziOCwV+EM0+e3AVfUxPV67pHJ4FSC5LGWjQpIxeZxVRDViEQr0ZLELyNKakKX+mJ3xrF7JGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ayNYNMNC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rqJG00Qh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ayNYNMNC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rqJG00Qh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ayNYNMNC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rqJG00Qh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ayNYNMNC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rqJG00Qh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 874DF760EC;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdqBRG4xKhLWtgAcoPE6z/OUR0rJPC5X2iSjuF+YN8c=;
	b=ayNYNMNCg6MvW9tlF4Y9AJUk5JHKUPI3cf4k34fduSuR2Lc4rzZj05OTo9DYDcebKAyusN
	86aD1MgrVDNyTTmaeAaVhyjO29xixq9RJPWjjze9SYL9soIl0mRD02ZB4U9TeQr9pqDyTy
	MoCj6+c3Jr35tqVTN50QfB2eMz4Lodw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdqBRG4xKhLWtgAcoPE6z/OUR0rJPC5X2iSjuF+YN8c=;
	b=rqJG00QheV1TqaFXsvlF/aKbm8GH0TKs5jP+UmgyoZCS74ey+am6ecpwydhQoyS6JggOIa
	mJxhNOjTHrMfpvCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdqBRG4xKhLWtgAcoPE6z/OUR0rJPC5X2iSjuF+YN8c=;
	b=ayNYNMNCg6MvW9tlF4Y9AJUk5JHKUPI3cf4k34fduSuR2Lc4rzZj05OTo9DYDcebKAyusN
	86aD1MgrVDNyTTmaeAaVhyjO29xixq9RJPWjjze9SYL9soIl0mRD02ZB4U9TeQr9pqDyTy
	MoCj6+c3Jr35tqVTN50QfB2eMz4Lodw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdqBRG4xKhLWtgAcoPE6z/OUR0rJPC5X2iSjuF+YN8c=;
	b=rqJG00QheV1TqaFXsvlF/aKbm8GH0TKs5jP+UmgyoZCS74ey+am6ecpwydhQoyS6JggOIa
	mJxhNOjTHrMfpvCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C142779AF;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zYh6FiGsRmoNGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 596E7A10B2; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 16/19] fat: Fix missed inode writeback during fsync(2)
Date: Thu,  2 Jul 2026 20:21:13 +0200
Message-ID: <20260702182057.2832980-35-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4931; i=jack@suse.cz; h=from:subject; bh=9xT7bpdZnySg6yB0t+yiqHCsggtJ+bNKnSlpRPstIVI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwWbz+DLTOVIxMUO1TqdSsNhmQ+usJx+HHlc OICMNzZIKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasFgAKCRCcnaoHP2RA 2c4dCACTlweaRY7ao1ok/m7KnvO+nT2iDg4vZEKwA9iMSGhncGEXPDS6eog29vW9GG8R3QzBs6m mkzXkuU3y4anPgyqV831pOqgLDtzG9Yx5S1LNDotktrVgvihqNNm0qtdsxDtAFCSz+xYNQ4o8PP hrvnsspMBq5FP0dlnZAPwqxPTjEeV+BeHM5sHSy04KPx7vAy+m1+1CbnolxMlPBbFMQxX71LFxU 1lp6JgO7vaazuxnnMuZSymHGUXZ83aOVZCnwZ3NrKcv5wHALlHgW9lgnmrXRp8/emawY1JsJfuc /g+rBwQ7ituXXKhh1zksBJFtGrROELfMTB+Lj8NcY5mzsBow
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

FAT could fail to properly write out inode on fsync(2) due to races with
WB_SYNC_NONE writeback. Several racing fsyncs could also result in some
fsync returning earlier than all metadata buffers were properly
persisted.

Fix these issues by using new .sync_inode_metadata method which makes
sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback. The slight disadvantage of this approach is that
when fsync(2) of an inode races with rename(2) of the inode, the window
during which inode isn't properly persisted becomes wider.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c  |  3 +--
 fs/fat/inode.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 37e7049b4c8c..8a7585c25207 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -190,8 +190,7 @@ int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *fat_inode = MSDOS_SB(inode->i_sb)->fat_inode;
 	int err;
 
-	err = mmb_fsync_noflush(filp, &MSDOS_I(inode)->i_metadata_bhs,
-				start, end, datasync);
+	err = simple_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3aa52481ad5c..c4d8ca8736fb 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -623,7 +623,37 @@ struct inode *fat_build_inode(struct super_block *sb,
 
 EXPORT_SYMBOL_GPL(fat_build_inode);
 
-static int __fat_write_inode(struct inode *inode, int wait);
+static int __fat_write_inode(struct inode *inode);
+
+static int fat_sync_inode_metadata(struct inode *inode,
+				   struct writeback_control *wbc)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct buffer_head *bh;
+	loff_t i_pos;
+	sector_t blocknr;
+	int offset;
+
+	if (inode->i_ino == MSDOS_ROOT_INO)
+		return 0;
+	i_pos = fat_i_pos_read(sbi, inode);
+	if (!i_pos)
+		return 0;
+
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_find_get_block_nonatomic(inode->i_sb, blocknr);
+	/*
+	 * Buffer already written? We leave buffer_dirty check for
+	 * sync_dirty_buffer() for proper synchronization with ongoing IO.
+	 */
+	if (!bh || !buffer_uptodate(bh)) {
+		brelse(bh);
+		return 0;
+	}
+	sync_dirty_buffer(bh);
+	brelse(bh);
+	return mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
+}
 
 static void fat_free_eofblocks(struct inode *inode)
 {
@@ -640,7 +670,13 @@ static void fat_free_eofblocks(struct inode *inode)
 		 * any corruption on the next access to the cluster
 		 * chain for the file.
 		 */
-		err = __fat_write_inode(inode, inode_needs_sync(inode));
+		err = __fat_write_inode(inode);
+		if (!err && inode_needs_sync(inode)) {
+			struct writeback_control wbc = {
+				.sync_mode = WB_SYNC_ALL,
+			};
+			err = fat_sync_inode_metadata(inode, &wbc);
+		}
 		if (err) {
 			fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
 					"update on disk inode for unused "
@@ -854,7 +890,7 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static int __fat_write_inode(struct inode *inode, int wait)
+static int __fat_write_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
@@ -863,7 +899,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	struct timespec64 mtime;
 	loff_t i_pos;
 	sector_t blocknr;
-	int err, offset;
+	int offset;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -907,11 +943,9 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	}
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
-	err = 0;
-	if (wait)
-		err = sync_dirty_buffer(bh);
 	brelse(bh);
-	return err;
+	set_inode_metadata_writeback(inode);
+	return 0;
 }
 
 static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -925,14 +959,22 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = fat_clusters_flush(sb);
 		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
-		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+		err = __fat_write_inode(inode);
 
 	return err;
 }
 
 int fat_sync_inode(struct inode *inode)
 {
-	return __fat_write_inode(inode, 1);
+	int err;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+	};
+
+	err = __fat_write_inode(inode);
+	if (err)
+		return err;
+	return fat_sync_inode_metadata(inode, &wbc);
 }
 
 EXPORT_SYMBOL_GPL(fat_sync_inode);
@@ -942,6 +984,7 @@ static const struct super_operations fat_sops = {
 	.alloc_inode	= fat_alloc_inode,
 	.free_inode	= fat_free_inode,
 	.write_inode	= fat_write_inode,
+	.sync_inode_metadata = fat_sync_inode_metadata,
 	.evict_inode	= fat_evict_inode,
 	.put_super	= fat_put_super,
 	.statfs		= fat_statfs,
-- 
2.51.0

