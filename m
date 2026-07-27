Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C653F823E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149454; cv=none; b=pGD/vf8jo9crtIz98lxwTAtbI7X0JJXg1EtH55eGNAAS8vEjteoRakhS43YElBpqyQOiHeRG3OkQ31xxt7eJrimL61XA54CyNmszyr+WUNt0MwBZSuKwwczuo6flrwP0RAUjZku29gSwjBL8oHX1FS5WntiqpyyUrILUgENJd/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149454; c=relaxed/simple;
	bh=QG2LVpd0do8ofgyapR6F2An7YiIoSNfQiEsVG0fxauI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahwxxUQceM/11gCkXhS2AG1KLVY86hJYxA88Gji0DAABeVMCemOhQLYWk9kvTDy3gaynAA9vYXTExdaPUvvjt0eDE2+y6bbxxGJOzHY/YtvFfbd4Exq9zCUBXxbFPq54XxqHmGpvWdrD7FV3giDB/vntnBbQmdV/5K8fZTSgSjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nQZsqRlE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=16LDGyJO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3XpY1hnB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pjxu8yIb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nQZsqRlE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="16LDGyJO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3XpY1hnB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pjxu8yIb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C39B7DAEE;
	Mon, 27 Jul 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6701VuVFZ6GIy2shE+uZWycalsmTaq/1Vyxf+/asQFg=;
	b=nQZsqRlE+EvvE5VxLF6kIm2BgWnw0EotnLb8FUA911JoN2IpzjiorZxQmoYsEgMyZ7l8YG
	ClvaYiqRc/IPwbUZXNGDQ5fCum86OhepNOr8XrmGUL9VcWJ3MOHLkciA+c52y+Gs+YSLef
	VRQNyIRXCdmRajIgWRehCljoSnv6Toc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6701VuVFZ6GIy2shE+uZWycalsmTaq/1Vyxf+/asQFg=;
	b=16LDGyJO0bcwKvBbYLR1KkcajkY0MUj0rXsWjyGweQyb4fA92sj5rNXUTsYYkTu/r9Zljo
	CGSdshlCpOaDvbBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6701VuVFZ6GIy2shE+uZWycalsmTaq/1Vyxf+/asQFg=;
	b=3XpY1hnB9UUNPmGMDGXCtrORtXBUH8ozqvtwRz97vGV4/Pexn265zOiphJvr7b0nE14r/J
	CkQWSvYPqeXVb7qQZQ6e+tEnmIOZKMhvO+09paD/BY+OHgpEhLydcutPOiO5jlLwkpdwSs
	pYYcVgmu1MtFHxxRfJ/fHigLqjaSMpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6701VuVFZ6GIy2shE+uZWycalsmTaq/1Vyxf+/asQFg=;
	b=pjxu8yIbaJLLaDcr1H3RjATkdFZcZhPhrzguBo7L8zT0PdkmhO71ClmrbSMPSq3G6/SXPw
	1CKJgUmrw1mXP1Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F593779E8;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CUf9Isw3Z2owawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 841B2A133E; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 18/20] fat: Fix missed inode writeback during fsync(2)
Date: Mon, 27 Jul 2026 12:49:36 +0200
Message-ID: <20260727104923.3828017-38-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4735; i=jack@suse.cz; h=from:subject; bh=QG2LVpd0do8ofgyapR6F2An7YiIoSNfQiEsVG0fxauI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzfBtuZmR6bd4DsA0xVVDhmkjMQjqm+A7Uyxp uUwdB9d8rOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3wQAKCRCcnaoHP2RA 2XU6B/9/k00Q3J4zKhPWCrPhhPPT1wHHRoRjvewFIkCVUY3k/2+ab8IGtezrjH/vZuU3sSWCoTA 2fU2rGDd5QfX92/6Qb3PiRVBF2qthxMrQIw2j4x4mnGo2q5XzgkKD+LTrG/toly3g3OsdIO1W24 e2+7fyhF4K/LKyCEJG5n96bvfY00RhgC70Uk+hwLj3+MKzBEkXU79S6re9+k1GCQsYy7+gE69Yr GpSud2694B5+8kgDP0cpn3KA4oynchgVdVUH1Az1meILQkUbXAMa8GI8Bh2wP9sfJjV8DKynPno RDS7fbtvt70eTFDRi0VB3Vu0sbM4C0R3bvPKdeOEMqf80084
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
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
 fs/fat/inode.c | 54 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 12 deletions(-)

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
index 3aa52481ad5c..f6f847ff1b1c 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -623,7 +623,34 @@ struct inode *fat_build_inode(struct super_block *sb,
 
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
+	 * Buffer present? We leave buffer_dirty check for sync_dirty_buffer()
+	 * for proper synchronization with ongoing IO.
+	 */
+	if (bh && buffer_uptodate(bh))
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
+}
 
 static void fat_free_eofblocks(struct inode *inode)
 {
@@ -640,7 +667,7 @@ static void fat_free_eofblocks(struct inode *inode)
 		 * any corruption on the next access to the cluster
 		 * chain for the file.
 		 */
-		err = __fat_write_inode(inode, inode_needs_sync(inode));
+		err = sync_inode_metadata(inode, inode_needs_sync(inode));
 		if (err) {
 			fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
 					"update on disk inode for unused "
@@ -854,7 +881,7 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static int __fat_write_inode(struct inode *inode, int wait)
+static int __fat_write_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
@@ -863,7 +890,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	struct timespec64 mtime;
 	loff_t i_pos;
 	sector_t blocknr;
-	int err, offset;
+	int offset;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -907,11 +934,9 @@ static int __fat_write_inode(struct inode *inode, int wait)
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
@@ -925,14 +950,22 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -942,6 +975,7 @@ static const struct super_operations fat_sops = {
 	.alloc_inode	= fat_alloc_inode,
 	.free_inode	= fat_free_inode,
 	.write_inode	= fat_write_inode,
+	.sync_inode_metadata = fat_sync_inode_metadata,
 	.evict_inode	= fat_evict_inode,
 	.put_super	= fat_put_super,
 	.statfs		= fat_statfs,
-- 
2.51.0

