Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124933FA5F5
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149483; cv=none; b=CKVvJaMTDneVIrW0C42aQpK6myV9bDWTqQ49md5J0Mt0/DmIqXiwKgD72XFvF0/ym98e0ho6u8nfNK54zQpoXKaeQcrTQsQh9q3wYNPqPrAG13GMoqjQit6tIoTK/XD69MwuXQRinQZYfILnG7ojZeTVFosWTFxqu0o3K32ayWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149483; c=relaxed/simple;
	bh=d9RsGMwVUmEVDtayuofK9R8tRi6KoPp5Zh4VnB6jpTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH/NTuzzzqMlFemS+oCI6+FbMPrVM5qgXGNX5U96tQ0bi7fZ6DEwf6Dbk/5AEYXvt1kwK4aSejrh2OPNNbftj4+0jTcVgXdYTIA6ggIhAmXnEVJ+sHt3SNhojxBXPhAn1d7jScL/BAMOPlmXKKkc9yH74mULFdw0ke2cDnttc9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U66SoMRQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q8j4iCUW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3DGbFPcR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u7EyFm3V; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U66SoMRQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q8j4iCUW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3DGbFPcR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u7EyFm3V"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BB0851A1;
	Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVuiovNms8G+qDmKXdVqa33DWiNiZjHF7eAU+C13y1M=;
	b=U66SoMRQRoW6I/WKAWEufSnaa77PpHhL3rB8MnNFqy53tBOEfaxbAcQV/uKDHvp7bcRO9V
	4P0MBHJt7GOCc6N9CZ47E9AMzh2QdxTbUqrvy0lwM//AuCQqwCZ0aVfq7+1NIBMhdPlY5Z
	4Ti97euy0FMj1T+6fO0ejA8TOBwx7iE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVuiovNms8G+qDmKXdVqa33DWiNiZjHF7eAU+C13y1M=;
	b=q8j4iCUWfYzxPxJwIdeHyZEi+IEGerV7w3TU456uk8Mju83z5vlmMiCymX0j01q4e2ir/I
	3rI++q/2SRcLsRBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3DGbFPcR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=u7EyFm3V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVuiovNms8G+qDmKXdVqa33DWiNiZjHF7eAU+C13y1M=;
	b=3DGbFPcRUz6mykCb4DxsU+tTZuEkffsgrGW+xLw/7fipH4xf3DR8BTnsKDwQAy2xaZIjhY
	zw4C+wyBMO7tKqTJ7CRg03cPPjN26+CT1tDXMv0HhipnrLjtXlfdix4jTNpGfwm49BAkqS
	+4fc2yyw1nTYo9kqIoThgZA14GA96ls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVuiovNms8G+qDmKXdVqa33DWiNiZjHF7eAU+C13y1M=;
	b=u7EyFm3VuqjFkGncsJENtlmqmFVFB+nfbk9qSiWtZVdqjz6bWVfQ9+lhpTKIhakO1EEJPb
	vcYges8pbEQRFpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E39C779EA;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D7yfJsw3Z2ozawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8EC60A1340; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 20/20] vfs: Remove mmb_fsync()
Date: Mon, 27 Jul 2026 12:49:38 +0200
Message-ID: <20260727104923.3828017-40-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3798; i=jack@suse.cz; h=from:subject; bh=d9RsGMwVUmEVDtayuofK9R8tRi6KoPp5Zh4VnB6jpTQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzfDr7J7eZqr9MH4rPMC81Q098MBNIObGjHn4 LBWRMASrXiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3wwAKCRCcnaoHP2RA 2YWcB/0ZwXT90NATg36k06uO3kR7xygyzgfT2Cxzrq6pf5zReqwQa6A6612W4sa8Sa9XUKse9Rw oGXn+qKflD/spmyMhTk0Ajo8MxOa0um/CqK/jZFNKmm++LunByw6lqY05quHky8RjBmx3O/012d oGH78CIYMOFBui4SBSOX7d8DBoIpZo/zeNUtAIAvfc7sxWOTf0MIdJ7dIq0YjYjcllvIYp8MGWs E0MUYhAFTTzCxaid84XYggosHApAipIcBIA9djtsinbeK5LbrwdcLxYidGmdEo0Qa2QJLVF6dCO 3WHXO/pS8cpLkVC+6A346FC321q1jZcv+olO1BlCguUKhHWp
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid,suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 7BB0851A1
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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

