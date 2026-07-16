Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFDF38236F
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213802; cv=none; b=FSsb/RGrvEcgnyeCfOzcou8gnngonIZ9Aua//UEnxKEYhzuuy0Wkdj3xTq8lu1iO+NgpYBjWZfpftQFq2ooShCb4hf8HeWpCDGNrylBZQ7PSb4rwluWXovsUnsgE/SlY6oDVgSibFDQG3KkqR+3oYBNWJ8xbcrrQ3cmtAckjwt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213802; c=relaxed/simple;
	bh=d9RsGMwVUmEVDtayuofK9R8tRi6KoPp5Zh4VnB6jpTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8/zviH1j5CUoTCcSYpPFick0LzoI0nWAP9M+Y4I2p7CsLmZnVJi1Ah0tPaCYKJgfywuCCk6OWpbVJvoGzxW4tzOlgoYcH6LEWm46CjUPbFVAtl9pMcgAy/KH+vX6nvlIAIcdHqwkIIMz/bThwaZLvxUEuyyftjm8yxAINobR6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B880D789D5;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEC0A779AE;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IXGqKgXxWGoMXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BE27BA1319; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 21/21] vfs: Remove mmb_fsync()
Date: Thu, 16 Jul 2026 16:55:43 +0200
Message-ID: <20260716145527.3580300-42-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3798; i=jack@suse.cz; h=from:subject; bh=d9RsGMwVUmEVDtayuofK9R8tRi6KoPp5Zh4VnB6jpTQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDxr7J7eZqr9MH4rPMC81Q098MBNIObGjHn4 LBWRMASrXiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw8QAKCRCcnaoHP2RA 2V0ZB/4ypplB2W70PsI9cFeLfLKHStux12Ou9tkFp/0irrFpAC+6L7WWdv8NOPeD7NzJBw5pcX+ MEq3xMarhxG3oHthqlJhmz6MN7A2R+TotH4C3mBpdMniZWh78A6xS9maH0nudrYUkbQTscbNApd zUAt0oU2lesIlliPfcqlvnoNdzBEzTf204yeOx/NDdPEsp7guk2FE2u0CkYtdtVucBRIDkFPA8g nyKFxyDUdfS8HWoQ7wHUCcJHhKnRjbAL/URajq+6rFzOTqBHmGNO2bc4oMu+cZUdcKeWSq6KnKf WVxufo98vLQUs8x5evH76kGIewMkvkMj+SRhlCyTU1dUlg2s
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
X-Rspamd-Queue-Id: B880D789D5
X-Rspamd-Action: no action

Now that everybody has been converted from mmb_fsync() (and it's variant
mmb_fsync_noflush()) to simple_fsync(), we can delete these calls.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 74 -------------------------------------
 include/linux/buffer_head.h |  4 --
 2 files changed, 78 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7e5ad9f4754d..be8b57a635cd 100644
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
-	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
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

