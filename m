Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4853A9870
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016516; cv=none; b=jujDEQ1x/keo0Vwtr3vL+PdyCMWN5wGF9naXq6wYBPLSbFO5eHnxS+V+j4UumSva6mBrMxHJ3VQdfVT1LZP5crY4k0Is8hWOCBse99BRKSYFO6l2QjTcmmLm+c1rQhAuZjHXqi565iPEFNnnGkK4v8sHP6a2DkEo8CX09TurBXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016516; c=relaxed/simple;
	bh=TouimwIOuYbLEw0nmNpfjmAAk/WPjFMgOYvbbpNr6kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxg/YhzmPM3HyILjft+kPha1Te+KPBsvJz5FyLni9ykQ99P/q5dir8V7S0sVgReaYIq2/NzHgmZMo4m3Alrx4mix1ElEElrXBoVt30dJVlbkPDlQ7GI0oG51Ldvlj7q8cACGCadmUSdAQGgTw2ER5E+FRFqbJNYES0vxXLMXJu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CE8574362;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FB4B779B0;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jqgUIyGsRmoYGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67737A12B3; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 19/19] vfs: Remove mmb_fsync()
Date: Thu,  2 Jul 2026 20:21:16 +0200
Message-ID: <20260702182057.2832980-38-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3797; i=jack@suse.cz; h=from:subject; bh=TouimwIOuYbLEw0nmNpfjmAAk/WPjFMgOYvbbpNr6kw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwZSd/5y+bw48dQOB9vh172sp3fm6JBI0aM3 eGWv7H/e0KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasGQAKCRCcnaoHP2RA 2Xv0B/wLBXg58e1J22ftalGgmor/Z6wsGAeBb56g0DEQX3ah33GI7ydBdHWTwt0kgBBlQKAEc2v bi4KdXe+BYSaOtq/F0JsFE1FftZpIsmh3i8XebIPE5LjODJmqmm7ajUT0lOcx5KEAuCHzp7R2R9 syvgqVnZfxc12URg2ucOBj95r9gkcHMFGQqqWuFvTnIxIdF2xiudPOtzwCTPvQ5h+M5zfg7oyP0 7fjghc9ZurnCCnuTxKvAuLUyvaRhxDPVff2MwgGbdIvWl01yhwiNzupJ2ZjO4IUOaVuffnOucYD K7NcmTSInZ5GUic0Da0BihznltZoHSTfSWI6oDeG3quwRnuc
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 9CE8574362
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

Now that everybody has been converted from mmb_fsync() (and it's variant
mmb_fsync_noflush()) to simple_fsync(), we can delete these calls.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 74 -------------------------------------
 include/linux/buffer_head.h |  4 --
 2 files changed, 78 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 83ff53c9e6a2..be8b57a635cd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -628,80 +628,6 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 }
 EXPORT_SYMBOL(mmb_sync);
 
-/**
- * mmb_fsync_noflush - fsync implementation for simple filesystems with
- * 		       metadata buffers list
- *
- * @file:	file to synchronize
- * @mmb:	list of metadata bhs to flush
- * @start:	start offset in bytes
- * @end:	end offset in bytes (inclusive)
- * @datasync:	only synchronize essential metadata if true
- *
- * This is an implementation of the fsync method for simple filesystems which
- * track all non-inode metadata in the buffers list hanging off the @mmb
- * structure.
- */
-int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
-		      loff_t start, loff_t end, bool datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	int err;
-	int ret = 0;
-
-	err = file_write_and_wait_range(file, start, end);
-	if (err)
-		return err;
-
-	if (mmb)
-		ret = mmb_sync(mmb);
-	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
-		goto out;
-	if (datasync &&
-	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC))
-		goto out;
-
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
-out:
-	/* check and advance again to catch errors after syncing out buffers */
-	err = file_check_and_advance_wb_err(file);
-	if (ret == 0)
-		ret = err;
-	return ret;
-}
-EXPORT_SYMBOL(mmb_fsync_noflush);
-
-/**
- * mmb_fsync - fsync implementation for simple filesystems with metadata
- * 	       buffers list
- *
- * @file:	file to synchronize
- * @mmb:	list of metadata bhs to flush
- * @start:	start offset in bytes
- * @end:	end offset in bytes (inclusive)
- * @datasync:	only synchronize essential metadata if true
- *
- * This is an implementation of the fsync method for simple filesystems which
- * track all non-inode metadata in the buffers list hanging off the @mmb
- * structure. This also makes sure that a device cache flush operation is
- * called at the end.
- */
-int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
-	      loff_t start, loff_t end, bool datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	int ret;
-
-	ret = mmb_fsync_noflush(file, mmb, start, end, datasync);
-	if (!ret)
-		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
-	return ret;
-}
-EXPORT_SYMBOL(mmb_fsync);
-
 /*
  * Called when we've recently written block `bblock', and it is known that
  * `bblock' was for a buffer_boundary() buffer.  This means that the block at
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 8b23bc9a244c..fd2c7115c054 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -210,10 +210,6 @@ void bh_end_async_write(struct bio *bio);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
-		      loff_t start, loff_t end, bool datasync);
-int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
-	      loff_t start, loff_t end, bool datasync);
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
-- 
2.51.0

