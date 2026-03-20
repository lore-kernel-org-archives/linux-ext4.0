Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8B43BB9F0
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014197; cv=none; b=R4wCVz0izzLj7c73DMO9HPDxKi4XR7qTLjy/rJ013VZLa2/fxMpeAybdQCH/DDnnXUjdFtRwNVQP/55qnOATrSMO6uCezdvHSyVBTEkCK0PWVUrnrCjWrZGeyx9MKJ4mijjapD8LddDFxZ0sRiQ6TLliF3C+gTSKhgoe5wMXHcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014197; c=relaxed/simple;
	bh=WZugQ2Fndy6gye1t3Hfakk0HbjUHGh+F3qYszb5YB0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtajC0usSuYHDb2hQK+CbR11RleumawUgmHk44rfvAcKWUK3sCdfcxz7l6qCLCT4OsqUbaPMYI7tFR60/fmtO+9IEdCkyxsamgzanNSog/Qn7HqWkHIFMiHEAw2ywHeRnppYdlCiyreg2es++rIr+OV5E5v076qTpKf+iLAYYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eJts8GzO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oGJS91mi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eJts8GzO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oGJS91mi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eJts8GzO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oGJS91mi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eJts8GzO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oGJS91mi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A73755BEE5;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=eJts8GzOlvsf8KrhxeUXrxnPrguwV27Xc49JFb9GdOaDIC7tIU37XOF4nPhP8doxIwLbj3
	lm8/6IbZaDMJ+E1ve/umpSFQDVFgG+i7o34vsf6HDxi6QdEQHOOp8lUo+y9ITbnmrnqD1D
	dZS+W+ESrqp+Oej0dkx6mWxQzlTUg/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=oGJS91miOqJkqMjL4P3wLdAmaTws5pgP0lD4JchVU3a58HCSAqWLR14iZJJN+i7YM+SOXJ
	zaerWS4irElvnNDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=eJts8GzOlvsf8KrhxeUXrxnPrguwV27Xc49JFb9GdOaDIC7tIU37XOF4nPhP8doxIwLbj3
	lm8/6IbZaDMJ+E1ve/umpSFQDVFgG+i7o34vsf6HDxi6QdEQHOOp8lUo+y9ITbnmrnqD1D
	dZS+W+ESrqp+Oej0dkx6mWxQzlTUg/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=oGJS91miOqJkqMjL4P3wLdAmaTws5pgP0lD4JchVU3a58HCSAqWLR14iZJJN+i7YM+SOXJ
	zaerWS4irElvnNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 956594281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1AB6JJlOvWmLCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 621D1A0B54; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 31/41] fs: Provide functions for handling mapping_metadata_bhs directly
Date: Fri, 20 Mar 2026 14:41:26 +0100
Message-ID: <20260320134100.20731-72-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12186; i=jack@suse.cz; h=from:subject; bh=WZugQ2Fndy6gye1t3Hfakk0HbjUHGh+F3qYszb5YB0Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Gjk72DX/tnYi3hOlBDnETcNsWqIa/jrBCw rI3+sHnNwqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhgAKCRCcnaoHP2RA 2Su+CACxb81rcrWhsybOMUE+f/cyFWbelIn0UQa1LHhthA8L7xqCma+1S1T80Wo349YM/4AD/Ie mqHzP8LEU+ZKlFlY3MGBDgRyTyFGiugh4WDJX1G1GWLtP/aCwPvFvRHu4zJEpaiCUjNYqIKmaEd QC2agJD08ssntEkfeGJaWfRboOZOCAzol1LwV0zCP2D7xV3GPuyC3Z08BtZINQKwHE9XBroVH3d Na/o6JXa/97xd04EOOQBD1jgKH83pWjyUiiN93So72mC0r9T8cjhw9ioOhOx8GnR1phrWettN8/ Gq2B+byBgcKCrAPqgq1rFXBtWpv2syn8iaBkEtbtKvWZkg/H
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

As part of transition toward moving mapping_metadata_bhs to fs-private
part of the inode, provide functions for operations on this list
directly instead of going through the inode / mapping.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 93 +++++++++++++++++--------------------
 include/linux/buffer_head.h | 45 ++++++++++++++----
 2 files changed, 80 insertions(+), 58 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c70f8027bdd1..43aca5b7969f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -467,31 +467,25 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * a successful fsync().  For example, ext2 indirect blocks need to be
  * written back and waited upon before fsync() returns.
  *
- * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
- * management of a list of dependent buffers in mapping_metadata_bhs struct.
+ * The functions mmb_mark_buffer_dirty(), mmb_sync_buffers(), mmb_has_buffers()
+ * and mmb_invalidate_buffers() are provided for the management of a list of
+ * dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
  * the lock in mapping_metadata_bhs so functions coming from bdev mapping
  * (such as try_to_free_buffers()) need to safely get to mapping_metadata_bhs
  * using RCU, grab the lock, verify we didn't race with somebody detaching the
  * bh / moving it to different inode and only then proceeding.
- *
- * FIXME: mark_buffer_dirty_inode() is a data-plane operation.  It should
- * take an address_space, not an inode.  And it should be called
- * mark_buffer_dirty_fsync() to clearly define why those buffers are being
- * queued up.
- *
- * FIXME: mark_buffer_dirty_inode() doesn't need to add the buffer to the
- * list if it is already on a list.  Because if the buffer is on a list,
- * it *must* already be on the right one.  If not, the filesystem is being
- * silly.  This will save a ton of locking.  But first we have to ensure
- * that buffers are taken *off* the old inode's list when they are freed
- * (presumably in truncate).  That requires careful auditing of all
- * filesystems (do it inside bforget()).  It could also be done by bringing
- * b_inode back.
  */
 
+void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
+{
+	spin_lock_init(&mmb->lock);
+	INIT_LIST_HEAD(&mmb->list);
+	mmb->mapping = mapping;
+}
+EXPORT_SYMBOL(mmb_init);
+
 static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
 			         struct buffer_head *bh)
 {
@@ -533,12 +527,12 @@ bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
- * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
- * @mapping: the mapping which wants those buffers written
+ * mmb_sync_buffers - write out & wait upon all buffers in a list
+ * @mmb: the list of buffers to write
  *
- * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
- * that I/O. Basically, this is a convenience function for fsync().  @mapping
- * is a file or directory which needs those buffers to be written for a
+ * Starts I/O against the buffers in the given list and waits upon
+ * that I/O. Basically, this is a convenience function for fsync().  @mmb is
+ * for a file or directory which needs those buffers to be written for a
  * successful fsync().
  *
  * We have conflicting pressures: we want to make sure that all
@@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
  * buffer stays on our list until IO completes (at which point it can be
  * reaped).
  */
-int sync_mapping_buffers(struct address_space *mapping)
+int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &mapping->i_metadata_bhs;
 	struct buffer_head *bh;
 	int err = 0;
 	struct blk_plug plug;
@@ -626,13 +619,14 @@ int sync_mapping_buffers(struct address_space *mapping)
 	spin_unlock(&mmb->lock);
 	return err;
 }
-EXPORT_SYMBOL(sync_mapping_buffers);
+EXPORT_SYMBOL(mmb_sync_buffers);
 
 /**
- * generic_buffers_fsync_noflush - generic buffer fsync implementation
+ * generic_mmb_fsync_noflush - generic buffer fsync implementation
  * for simple filesystems with no inode lock
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
@@ -641,18 +635,20 @@ EXPORT_SYMBOL(sync_mapping_buffers);
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
-				  bool datasync)
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
-	ret = sync_mapping_buffers(inode->i_mapping);
+	if (mmb)
+		ret = mmb_sync_buffers(mmb);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
@@ -669,13 +665,14 @@ int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
 		ret = err;
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync_noflush);
+EXPORT_SYMBOL(generic_mmb_fsync_noflush);
 
 /**
- * generic_buffers_fsync - generic buffer fsync implementation
+ * generic_mmb_fsync - generic buffer fsync implementation
  * for simple filesystems with no inode lock
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
@@ -685,18 +682,18 @@ EXPORT_SYMBOL(generic_buffers_fsync_noflush);
  * hanging off the address_space structure. This also makes sure that
  * a device cache flush operation is called at the end.
  */
-int generic_buffers_fsync(struct file *file, loff_t start, loff_t end,
-			  bool datasync)
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
 	if (!ret)
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync);
+EXPORT_SYMBOL(generic_mmb_fsync);
 
 /*
  * Called when we've recently written block `bblock', and it is known that
@@ -717,20 +714,18 @@ void write_boundary_block(struct block_device *bdev,
 	}
 }
 
-void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
+void mmb_mark_buffer_dirty(struct buffer_head *bh,
+			   struct mapping_metadata_bhs *mmb)
 {
-	struct address_space *mapping = inode->i_mapping;
-
 	mark_buffer_dirty(bh);
 	if (!bh->b_mmb) {
-		spin_lock(&mapping->i_metadata_bhs.lock);
-		list_move_tail(&bh->b_assoc_buffers,
-				&mapping->i_metadata_bhs.list);
-		bh->b_mmb = &mapping->i_metadata_bhs;
-		spin_unlock(&mapping->i_metadata_bhs.lock);
+		spin_lock(&mmb->lock);
+		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
+		bh->b_mmb = mmb;
+		spin_unlock(&mmb->lock);
 	}
 }
-EXPORT_SYMBOL(mark_buffer_dirty_inode);
+EXPORT_SYMBOL(mmb_mark_buffer_dirty);
 
 /**
  * block_dirty_folio - Mark a folio as dirty.
@@ -797,14 +792,12 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 EXPORT_SYMBOL(block_dirty_folio);
 
 /*
- * Invalidate any and all dirty buffers on a given inode.  We are
+ * Invalidate any and all dirty buffers on a given buffers list.  We are
  * probably unmounting the fs, but that doesn't mean we have already
  * done a sync().  Just drop the buffers from the inode list.
  */
-void invalidate_inode_buffers(struct inode *inode)
+void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
-
 	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
@@ -812,7 +805,7 @@ void invalidate_inode_buffers(struct inode *inode)
 		spin_unlock(&mmb->lock);
 	}
 }
-EXPORT_SYMBOL(invalidate_inode_buffers);
+EXPORT_SYMBOL(mmb_invalidate_buffers);
 
 /*
  * Create the appropriate buffers when given a folio for data area and
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 44094fd476f5..399277c679eb 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -205,12 +205,31 @@ struct buffer_head *create_empty_buffers(struct folio *folio,
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
-/* Things to do with buffers at mapping->private_list */
-void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
-int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
-				  bool datasync);
-int generic_buffers_fsync(struct file *file, loff_t start, loff_t end,
-			  bool datasync);
+/* Things to do with metadata buffers list */
+void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
+static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
+					   struct inode *inode)
+{
+	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
+}
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync_noflush(struct file *file,
+						loff_t start, loff_t end,
+						bool datasync)
+{
+	return generic_mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
+					 start, end, datasync);
+}
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync(struct file *file,
+					loff_t start, loff_t end, bool datasync)
+{
+	return generic_mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
+				 start, end, datasync);
+}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -515,9 +534,18 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
+void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
-void invalidate_inode_buffers(struct inode *inode);
-int sync_mapping_buffers(struct address_space *mapping);
+void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb);
+int mmb_sync_buffers(struct mapping_metadata_bhs *mmb);
+static inline void invalidate_inode_buffers(struct inode *inode)
+{
+	mmb_invalidate_buffers(&inode->i_data.i_metadata_bhs);
+}
+static inline int sync_mapping_buffers(struct address_space *mapping)
+{
+	return mmb_sync_buffers(&mapping->i_metadata_bhs);
+}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -527,6 +555,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
+static inline int mmb_sync_buffers(struct mapping_metadata_bhs *mmb) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
-- 
2.51.0

