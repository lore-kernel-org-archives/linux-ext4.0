Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1133BFE4D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519026; cv=none; b=U5dsgPPVtapGesaIQ0bAF9v/JVAjaXwGzYtscuKGEHVYES/TGu7K1uEjeDprxCXejP4eIIeZWGRRc25X6oJ3JV8Hf/V0P2h6sNmXbVo6qvtm8YgoC0o1oiXumzP3v0ih3NHJiqOripC8I9dj5U3JhBTUe4uiznq2LrX8zRvGbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519026; c=relaxed/simple;
	bh=f6izt04fZCFJQSkSrf7dTi/3Cbur8ValvknA2hTJ8Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUqGNZGfwyNiURaIZikDB+Gy2a8FfJ/s5dgG3gejFTziwQIDV63kvIHawicmN0rPc+PDRDwrXb0A2WDA9LGWksF6t9XknK7wQ4P6iRb5GrcEaW5k3C9dudikKywym5zM+VaYduX/AWydQerKUwnr3Ryo2E5fByPACk6y7syGygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ASU5o0/Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pUfVOkmG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ASU5o0/Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pUfVOkmG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ASU5o0/Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pUfVOkmG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ASU5o0/Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pUfVOkmG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E0485BDBB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=ASU5o0/YYWXbVR26pgaXFebCL3930P3+EUIlfiuWBRdfhgqtM2Qjg7UaRPJJzW4ZreAFxR
	GT1Y6RIvQKE4QxCDaEVPmm1NH7AYvZWQJAD4VNO7SJye5TunzbhZMbuykOWifh1qSZCCcP
	gZXucSGJrLv1j2Bf6MCLIIBAQUa8+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=pUfVOkmG7lb1lIZtjgEhqeCJUz6PcAJezbQNUrhi0HJ2Cy6ieRhpb3OcVwB5qVh8RDLep3
	mSsVjQWUchYWvQDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ASU5o0/Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pUfVOkmG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=ASU5o0/YYWXbVR26pgaXFebCL3930P3+EUIlfiuWBRdfhgqtM2Qjg7UaRPJJzW4ZreAFxR
	GT1Y6RIvQKE4QxCDaEVPmm1NH7AYvZWQJAD4VNO7SJye5TunzbhZMbuykOWifh1qSZCCcP
	gZXucSGJrLv1j2Bf6MCLIIBAQUa8+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=pUfVOkmG7lb1lIZtjgEhqeCJUz6PcAJezbQNUrhi0HJ2Cy6ieRhpb3OcVwB5qVh8RDLep3
	mSsVjQWUchYWvQDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 712924A0A6;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8rSfG3UCxWntYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7C650A0C73; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/42] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
Date: Thu, 26 Mar 2026 10:54:23 +0100
Message-ID: <20260326095354.16340-71-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7567; i=jack@suse.cz; h=from:subject; bh=f6izt04fZCFJQSkSrf7dTi/3Cbur8ValvknA2hTJ8Bo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJLlQqRFKEeG5RqvmZU02Tl0MdB1/bLQi5a0 XfukSttZ9yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSwAKCRCcnaoHP2RA 2UhsCADJWf4qvR904MZ1Xs38Xnpv48CssgT5ZAAeT7048r9JjF3XKdrMqvfzxCMuDzpsYW2/TVJ zvp1pyOmzdfjFtAe5JJOvE3lm1DbibJ092f9I6J3V2DHMf/0cggTc4flNIyaL4QuIepoKD0Upwu Ubpc3wJiKVNBzCmPZbFHlMJLvCwdfk14YCirMSwn22iEAXxQAwCVZz+i3VZRI+gA04oQCCmBEF0 SKC/ZcSUoPTPYuVp9YTQZEoAycs64RrnYdN2yy5HO1vW7mrjWFz1Mq6JVmFlWps30mM9tmCQcej XpVTUVLDxz1snBUc37I2ZAmOttVFWGkWJvzF2RHIb7gUJkgU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,lst.de];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 7E0485BDBB
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

There's only single caller of fsync_buffers_list() so untangle the code
a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
merge the comments and update them to reflect current state of code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 100 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1c0e7c81a38b..fa3d84084adf 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -54,7 +54,6 @@
 
 #include "internal.h"
 
-static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 			  enum rw_hint hint, struct writeback_control *wbc);
 
@@ -531,22 +530,96 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  * @mapping: the mapping which wants those buffers written
  *
  * Starts I/O against the buffers at mapping->i_private_list, and waits upon
- * that I/O.
+ * that I/O. Basically, this is a convenience function for fsync().  @mapping
+ * is a file or directory which needs those buffers to be written for a
+ * successful fsync().
  *
- * Basically, this is a convenience function for fsync().
- * @mapping is a file or directory which needs those buffers to be written for
- * a successful fsync().
+ * We have conflicting pressures: we want to make sure that all
+ * initially dirty buffers get waited on, but that any subsequently
+ * dirtied buffers don't.  After all, we don't want fsync to last
+ * forever if somebody is actively writing to the file.
+ *
+ * Do this in two main stages: first we copy dirty buffers to a
+ * temporary inode list, queueing the writes as we go. Then we clean
+ * up, waiting for those writes to complete. mark_buffer_dirty_inode()
+ * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
+ * are sure the buffer stays on our list until IO completes (at which point
+ * it can be reaped).
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
 	struct address_space *buffer_mapping =
 				mapping->host->i_sb->s_bdev->bd_mapping;
+	struct buffer_head *bh;
+	int err = 0;
+	struct blk_plug plug;
+	LIST_HEAD(tmp);
 
 	if (list_empty(&mapping->i_private_list))
 		return 0;
 
-	return fsync_buffers_list(&buffer_mapping->i_private_lock,
-					&mapping->i_private_list);
+	blk_start_plug(&plug);
+
+	spin_lock(&buffer_mapping->i_private_lock);
+	while (!list_empty(&mapping->i_private_list)) {
+		bh = BH_ENTRY(mapping->i_private_list.next);
+		WARN_ON_ONCE(bh->b_assoc_map != mapping);
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh) || buffer_locked(bh)) {
+			list_add(&bh->b_assoc_buffers, &tmp);
+			bh->b_assoc_map = mapping;
+			if (buffer_dirty(bh)) {
+				get_bh(bh);
+				spin_unlock(&buffer_mapping->i_private_lock);
+				/*
+				 * Ensure any pending I/O completes so that
+				 * write_dirty_buffer() actually writes the
+				 * current contents - it is a noop if I/O is
+				 * still in flight on potentially older
+				 * contents.
+				 */
+				write_dirty_buffer(bh, REQ_SYNC);
+
+				/*
+				 * Kick off IO for the previous mapping. Note
+				 * that we will not run the very last mapping,
+				 * wait_on_buffer() will do that for us
+				 * through sync_buffer().
+				 */
+				brelse(bh);
+				spin_lock(&buffer_mapping->i_private_lock);
+			}
+		}
+	}
+
+	spin_unlock(&buffer_mapping->i_private_lock);
+	blk_finish_plug(&plug);
+	spin_lock(&buffer_mapping->i_private_lock);
+
+	while (!list_empty(&tmp)) {
+		bh = BH_ENTRY(tmp.prev);
+		get_bh(bh);
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh)) {
+			list_add(&bh->b_assoc_buffers,
+				 &mapping->i_private_list);
+			bh->b_assoc_map = mapping;
+		}
+		spin_unlock(&buffer_mapping->i_private_lock);
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			err = -EIO;
+		brelse(bh);
+		spin_lock(&buffer_mapping->i_private_lock);
+	}
+	spin_unlock(&buffer_mapping->i_private_lock);
+	return err;
 }
 EXPORT_SYMBOL(sync_mapping_buffers);
 
@@ -719,99 +792,6 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 }
 EXPORT_SYMBOL(block_dirty_folio);
 
-/*
- * Write out and wait upon a list of buffers.
- *
- * We have conflicting pressures: we want to make sure that all
- * initially dirty buffers get waited on, but that any subsequently
- * dirtied buffers don't.  After all, we don't want fsync to last
- * forever if somebody is actively writing to the file.
- *
- * Do this in two main stages: first we copy dirty buffers to a
- * temporary inode list, queueing the writes as we go.  Then we clean
- * up, waiting for those writes to complete.
- * 
- * During this second stage, any subsequent updates to the file may end
- * up refiling the buffer on the original inode's dirty list again, so
- * there is a chance we will end up with a buffer queued for write but
- * not yet completed on that list.  So, as a final cleanup we go through
- * the osync code to catch these locked, dirty buffers without requeuing
- * any newly dirty buffers for write.
- */
-static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct address_space *mapping;
-	int err = 0;
-	struct blk_plug plug;
-	LIST_HEAD(tmp);
-
-	blk_start_plug(&plug);
-
-	spin_lock(lock);
-	while (!list_empty(list)) {
-		bh = BH_ENTRY(list->next);
-		mapping = bh->b_assoc_map;
-		__remove_assoc_queue(bh);
-		/* Avoid race with mark_buffer_dirty_inode() which does
-		 * a lockless check and we rely on seeing the dirty bit */
-		smp_mb();
-		if (buffer_dirty(bh) || buffer_locked(bh)) {
-			list_add(&bh->b_assoc_buffers, &tmp);
-			bh->b_assoc_map = mapping;
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(lock);
-				/*
-				 * Ensure any pending I/O completes so that
-				 * write_dirty_buffer() actually writes the
-				 * current contents - it is a noop if I/O is
-				 * still in flight on potentially older
-				 * contents.
-				 */
-				write_dirty_buffer(bh, REQ_SYNC);
-
-				/*
-				 * Kick off IO for the previous mapping. Note
-				 * that we will not run the very last mapping,
-				 * wait_on_buffer() will do that for us
-				 * through sync_buffer().
-				 */
-				brelse(bh);
-				spin_lock(lock);
-			}
-		}
-	}
-
-	spin_unlock(lock);
-	blk_finish_plug(&plug);
-	spin_lock(lock);
-
-	while (!list_empty(&tmp)) {
-		bh = BH_ENTRY(tmp.prev);
-		get_bh(bh);
-		mapping = bh->b_assoc_map;
-		__remove_assoc_queue(bh);
-		/* Avoid race with mark_buffer_dirty_inode() which does
-		 * a lockless check and we rely on seeing the dirty bit */
-		smp_mb();
-		if (buffer_dirty(bh)) {
-			list_add(&bh->b_assoc_buffers,
-				 &mapping->i_private_list);
-			bh->b_assoc_map = mapping;
-		}
-		spin_unlock(lock);
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
-			err = -EIO;
-		brelse(bh);
-		spin_lock(lock);
-	}
-	
-	spin_unlock(lock);
-	return err;
-}
-
 /*
  * Invalidate any and all dirty buffers on a given inode.  We are
  * probably unmounting the fs, but that doesn't mean we have already
-- 
2.51.0

