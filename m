Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975E33E4C92
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699522; cv=none; b=rDmu4vdJE6JTwtlo6B8ZMv5r/dhtJkRczlVFtTZumj6M/qfQLcrECszRGbszTxbVOS8LM5IsTZrPukONXS0WsxOdg1tQf9zjZgqxV7bC8uHtrA33sRF/fH/IKxHfDuEl0arGMIXvSpgd5gtu/Wdsf9qwuOnrMrmNWTzZ6nsREXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699522; c=relaxed/simple;
	bh=VXnRcBl9pss7zzJUWRzlWrZCA4iZkehCvDcTCDvFCY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjq9lnw8BxV+bptZa0RNS0aXJYVBzGMZ2dYR+u/Tr634G5p0Hb+spIJmoWPPCBZPGhHEKkpDPQB41Mc22tYWb34isxaf/UqBwW0ecmwih/LtXs+jqfbp1OwMXmV8pvruMBNiFozOYpD6cUrE99JVs8fiYH+2I1jHsUhRfZ4maZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70B9764B6A;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6630959B70;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8b3vGD0PFGrFbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BA51FA0913; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 03/10] fs: Writeout inode buffer from mmb_sync()
Date: Mon, 25 May 2026 10:58:09 +0200
Message-ID: <20260525085821.769119-13-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6575; i=jack@suse.cz; h=from:subject; bh=VXnRcBl9pss7zzJUWRzlWrZCA4iZkehCvDcTCDvFCY8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8vJd52gaa5hik/W5nndxLhNl8DLjq5wKHGr zd7hXtNm2iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPLwAKCRCcnaoHP2RA 2fxYB/43cmIXpcBsP68brcD8g7ZmpkTmrrDKl/Pt9fsUrgZy4L9O3OXrPEjgeK7E5sZeNEBZ9q+ RTtNI0oL9AQeBdxvFt11OGQIa7nZEqOAFHnrN5lcmkS8sqNTqMLARGaky5yYbY+ll0hQp2gi7Zz VfMIuC/bsPIILQDk+pwTrPGSi1pun0IT7AFgx4/63/R2u9DlYgkswB+gE0zPUxdGvLBSQSbg9ur g8cgh0IU3eNkIxsod7S99l/WBwXIqVQT+F1x2/ngydvnIvGsHJkD5XTqd6bmG4bh82+VPtcU8QH Obja+Ui2RthrMQzhCQc9oJOgwExWPmYiUnwi0TZ2IZH9m8Lu
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 70B9764B6A
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO

Currently metadata bh tracking does not track inode buffers because they
are usually shared by several inodes and so our linked list tracking
cannot be used. On fsync we call sync_inode_metadata() to write inode
instead where filesystems' .write_inode methods detect data integrity
writeback and take care to submit inode buffer to disk and wait for it
in that case. This is however racy as for example flush worker can
submit normal (WB_SYNC_NONE) inode writeback first, which makes the
inode clean and copies the inode to the buffer but doesn't submit the
buffer for IO. Thus sync_inode_metadata() call does nothing and we fail
to persist inode buffer to disk on fsync(2).

Fix the problem by allowing filesystem to set the number of block backing
the inode in mmb structure and mmb_sync() then takes care to writeout
corresponding buffer and wait for it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 64 +++++++++++++++++++++++++++++--------
 include/linux/buffer_head.h | 14 ++++++++
 include/linux/fs.h          |  1 +
 3 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..f83fb3cdc6ac 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -477,12 +477,12 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * using RCU, grab the lock, verify we didn't race with somebody detaching the
  * bh / moving it to different inode and only then proceeding.
  */
-
 void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
 {
 	spin_lock_init(&mmb->lock);
 	INIT_LIST_HEAD(&mmb->list);
 	mmb->mapping = mapping;
+	mmb->inode_blk = MMB_INVALID_BLK;
 }
 EXPORT_SYMBOL(mmb_init);
 
@@ -550,11 +550,13 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
 int mmb_sync(struct mapping_metadata_bhs *mmb)
 {
 	struct buffer_head *bh;
+	sector_t inode_blk;
 	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (!mmb_has_buffers(mmb))
+	if (!mmb_has_buffers(mmb) &&
+	    data_race(mmb->inode_blk == MMB_INVALID_BLK))
 		return 0;
 
 	blk_start_plug(&plug);
@@ -593,8 +595,22 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 			}
 		}
 	}
-
+	inode_blk = mmb->inode_blk;
+	mmb->inode_blk = MMB_INVALID_BLK;
 	spin_unlock(&mmb->lock);
+
+	/* Writeout inode buffer if it was set and wasn't written out yet */
+	if (inode_blk != MMB_INVALID_BLK) {
+		bh = sb_find_get_block(mmb->mapping->host->i_sb, inode_blk);
+		if (bh) {
+			write_dirty_buffer(bh, REQ_SYNC);
+			wait_on_buffer(bh);
+			if (!buffer_uptodate(bh))
+				err = -EIO;
+			brelse(bh);
+		}
+	}
+
 	blk_finish_plug(&plug);
 	spin_lock(&mmb->lock);
 
@@ -646,18 +662,18 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 	if (err)
 		return err;
 
-	if (mmb)
-		ret = mmb_sync(mmb);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
-		goto out;
+		goto sync_buffers;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
-		goto out;
-
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
-out:
+		goto sync_buffers;
+
+	ret = sync_inode_metadata(inode, 1);
+sync_buffers:
+	if (mmb) {
+		err = mmb_sync(mmb);
+		if (ret == 0)
+			ret = err;
+	}
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
 	if (ret == 0)
@@ -733,6 +749,28 @@ void mmb_mark_buffer_dirty(struct buffer_head *bh,
 }
 EXPORT_SYMBOL(mmb_mark_buffer_dirty);
 
+/**
+ * mmb_mark_inode_buffer_dirty - Mark buffer containing inode as dirty and
+ *				 track it for fsync.
+ * @bh: The buffer containing the inode.
+ * @mmb: Mmb structure for metadata tracking.
+ *
+ * Mark the buffer containing inode as dirty and track the block number of
+ * the buffer containing the inode in mmb so that it gets written out from
+ * mmb_sync().
+ */
+void mmb_mark_inode_buffer_dirty(struct buffer_head *bh,
+				 struct mapping_metadata_bhs *mmb)
+{
+	/* For simplicity we use mmb->lock to synchronize with mmb_sync() */
+	spin_lock(&mmb->lock);
+	mark_buffer_dirty(bh);
+	mmb->inode_blk = bh->b_blocknr;
+	spin_unlock(&mmb->lock);
+}
+EXPORT_SYMBOL(mmb_mark_inode_buffer_dirty);
+
+
 /**
  * block_dirty_folio - Mark a folio as dirty.
  * @mapping: The address space containing this folio.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b5..b77464359028 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,6 +207,8 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
+void mmb_mark_inode_buffer_dirty(struct buffer_head *bh,
+				 struct mapping_metadata_bhs *mmb);
 int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 		      loff_t start, loff_t end, bool datasync);
 int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
@@ -513,12 +515,24 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_BUFFER_HEAD
 
+#define MMB_INVALID_BLK (~0ULL)
+
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
 void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate(struct mapping_metadata_bhs *mmb);
 int mmb_sync(struct mapping_metadata_bhs *mmb);
+static inline void mmb_clear_inode_blk(struct mapping_metadata_bhs *mmb)
+{
+	/*
+	 * The lock is mostly pointless here but let's keep setting of
+	 * inode_blk consistently under it.
+	 */
+	spin_lock(&mmb->lock);
+	mmb->inode_blk = MMB_INVALID_BLK;
+	spin_unlock(&mmb->lock);
+}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..435a41e4c90f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -446,6 +446,7 @@ extern const struct address_space_operations empty_aops;
 /* Structure for tracking metadata buffer heads associated with the mapping */
 struct mapping_metadata_bhs {
 	struct address_space *mapping;	/* Mapping bhs are associated with */
+	sector_t inode_blk;	/* Number of block containing the inode */
 	spinlock_t lock;	/* Lock protecting bh list */
 	struct list_head list;	/* The list of bhs (b_assoc_buffers) */
 };
-- 
2.51.0

