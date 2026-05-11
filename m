Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665F3242B8
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501658; cv=none; b=by+FOPO9rh5h7tQIVgTE+GDdsnkIY9LGbY/IlGxclbZx+y+tF67FswJmAmf0B67rHXJ18Zs8XG+B0QUT68E1nxxY2n8tkJSuC7yYLyG0hWoMMT6U2Z2grrIaZUH7GVciaNN2wiJYu1a5w/Lzo3BxTveuBT/ycB9o7UhJ8oYsVSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501658; c=relaxed/simple;
	bh=pPonS2GQEY1W18D7zENkCxkKiUhJTOVSQ9ulStQUnOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXuFjK1Yv8E11JmqKlnFaBUGFmdYEGxDew2vJK7BiRx9y0AiGwQZhH7Wegz64ByzyiHYc16cm4GimcQbWdnjNXvQnHVQc+JHqDp40qalYET07RO1jWoDII9qdrdFbNt2eijFU5qP1uDr6TIm/fIqIEmN2kyz5CxEHgvTVuxWVZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tGzIryaS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+1hvAMt5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fc99BxJf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wGYmGLbY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tGzIryaS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+1hvAMt5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fc99BxJf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wGYmGLbY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 282AC6BAE7;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jzXMKEVfeYzqSmmmptCGF2i7bA/2c2b3/MuFHVCu7jM=;
	b=tGzIryaSg1oZbHWct+AkX9P6TPng+xATFfx8xsk7Hl69xtslDwYZ3kIgvJA4bPeUpDaGU8
	XAKqPvbu8ej/LGChOMwstLHmaNOoXClhRxP0peRefUByUmTC69ky9K3YFjeFUKTFrnq9YG
	w6t4V+x5BeB7oQA4XsD2AAqFHFaBpm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jzXMKEVfeYzqSmmmptCGF2i7bA/2c2b3/MuFHVCu7jM=;
	b=+1hvAMt5xoEUleBAINqR0IptXHRTdut/oACO7DCrsIQlVzZQSHLoiaPgJw35PYiPbgS5N1
	62WDgbhO567/bJCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fc99BxJf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wGYmGLbY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jzXMKEVfeYzqSmmmptCGF2i7bA/2c2b3/MuFHVCu7jM=;
	b=Fc99BxJfUIqiQEQhx9zrILqRb6m7fwkhzIh+FgAERgbJPIuQC6RIFFjjlyO812dDfQqwQV
	BEKECOal4BADc4J/sClkox8Y5zvx+Rjamw3Nj6gZiHsn1r7GwXcW1gHstcuQNgMnmV1ryA
	LiMBJIt9KMWW85bOuxI8lgJdRiqI5V8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jzXMKEVfeYzqSmmmptCGF2i7bA/2c2b3/MuFHVCu7jM=;
	b=wGYmGLbYBErXwypP2zMxdWrmuxqe3Bj+rbFVDfQIgwfJ0aED7ibIL/JjZbrHlpev7Y1qCu
	6kd02QSE4SqKWZCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A459593A3;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCxnBhPIAWrOWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7A857A07A2; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/9] fs: Writeout inode buffer from mmb_sync()
Date: Mon, 11 May 2026 14:13:53 +0200
Message-ID: <20260511121356.241821-12-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3462; i=jack@suse.cz; h=from:subject; bh=pPonS2GQEY1W18D7zENkCxkKiUhJTOVSQ9ulStQUnOw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgFg+69z7actsiAWKqHH6ehZMA4xdwYXVfXH lJwjT5HLFaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHIBQAKCRCcnaoHP2RA 2RBnCADB2Ie1CbIDgDtMGN46COqXgKqPQ5w5lDQyD3D1lfpUqrY2tCOZX2NQo2rY+Lz06zFKdUq 0fOPi9BQhE1P9ygIPcc2HqGxjkvij3ZOWIXBYNYFMQxMy42WQ5DCzT9HzJKOm+QvRmmyQZrORsV VCLWvIoKZI6YFwpFCSaTZGaIj8bI9r1I2aBlzYpRAWgfMEt4MKAUjOidAeHEGzYXimdNsuQBoxS KcDVXCenGXyVWlYWTRuCsVOVnd/eAN6STnogfn+t9ffGuGp9hpYUZK+9qDQTNxICfUqqYOWXd9M FZ9YiGDkdBPEDMLLS5tLoVB4SsWptDJCbdxBSP6FFkidFHm/
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Rspamd-Action: no action
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 282AC6BAE7
X-Spam-Level: 

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
 fs/buffer.c        | 34 +++++++++++++++++++++++-----------
 include/linux/fs.h |  1 +
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..dba29a45346b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -477,12 +477,14 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * using RCU, grab the lock, verify we didn't race with somebody detaching the
  * bh / moving it to different inode and only then proceeding.
  */
+#define INVALID_BLK (~0ULL)
 
 void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
 {
 	spin_lock_init(&mmb->lock);
 	INIT_LIST_HEAD(&mmb->list);
 	mmb->mapping = mapping;
+	mmb->inode_blk = INVALID_BLK;
 }
 EXPORT_SYMBOL(mmb_init);
 
@@ -593,8 +595,18 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 			}
 		}
 	}
-
 	spin_unlock(&mmb->lock);
+
+	/* Writeout inode buffer head */
+	if (mmb->inode_blk != INVALID_BLK) {
+		bh = sb_find_get_block(mmb->mapping->host->i_sb, mmb->inode_blk);
+		write_dirty_buffer(bh, REQ_SYNC);
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			err = -EIO;
+		brelse(bh);
+	}
+
 	blk_finish_plug(&plug);
 	spin_lock(&mmb->lock);
 
@@ -646,18 +658,18 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
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

