Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C63B9DBB
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014191; cv=none; b=UXB+ZZ/RsfIMxviwUEDwES1+MgRR2NMSa5AEgkiK9uvdYLDkZ4JXXGebnoP2rU5zeg58ESq73cz+gk9LMJ25yPoI2fuU14vXqks7CChjcBgH+aQUwkgpeyX9kgJOwClRmuhN8ZD3Qhxk9r6wuVLbBbUfAJclK7kWjyxS0LBtc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014191; c=relaxed/simple;
	bh=69wm8J/iuVA/C0LqpgrhH0eFrbxBGnvY/zfsyT0LKqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ4GSpeTMqtwfN4Z6aGcvSr90rXoEdjMo19B80aAn0A9PFbnNv0OnusBcswEGnBvmhDK+tAqodtmdhupdGNFuv9B1TS6y4s0pNnzsPpaAZ1W8FTPO/csyqnhMtD59uGiZb1nIJH9H4qXC9UbIjyFSz52Hd49VBLjLhj0jDK89zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 970CC5BEE3;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E5B54281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z0bAIplOvWmJCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5922DA0B52; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 30/41] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
Date: Fri, 20 Mar 2026 14:41:25 +0100
Message-ID: <20260320134100.20731-71-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3235; i=jack@suse.cz; h=from:subject; bh=69wm8J/iuVA/C0LqpgrhH0eFrbxBGnvY/zfsyT0LKqA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Gj+Z5RYeNReOqGeEBWkWaNnGaNEZjZ540x qgyJNuRGqGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhgAKCRCcnaoHP2RA 2SILCADvtRbpL9sQeXk2ATLaaUGVCxb3x1O9HrScoxpgHaIxGtqufzRqZMVfXTDHrjaP6C2qP/K EDPQwR1f4w1pohkgKuuasspNKQTMuNSMb+Zo+uVUnmimmYVtBxlnuuJ6Al1d7EpZCPde11zhrvV K4qw4Tf1WeR6Ta8jpIFUDcFI6vFFLnOp3OWqrOTfTiS5kVsvQAkoMdn2R2J8RuU4Gfiych3FfZY PdMiy7jMdI7eB2nFwjAnhwaVvPvhJhEADjMwrdcQsn/7EvrZZBZyW+j4B4kBW93m8GBPgeId5GE C1tGJwnc810Y0ttPRyfvV/Lszn16jgnG4Zl+iA3OGWcM07DB
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 970CC5BEE3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

As part of a move towards placing mapping_metadata_bhs in fs-private
inode part, switch inode_has_buffers() to take mapping_metadata_bhs
and rename the function to mmb_has_buffers().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 14 +++++++-------
 fs/ext4/inode.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index e0e522b0cdad..c70f8027bdd1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -468,7 +468,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * written back and waited upon before fsync() returns.
  *
  * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * inode_has_buffers() and invalidate_inode_buffers() are provided for the
+ * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
  * management of a list of dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
@@ -526,11 +526,11 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	}
 }
 
-int inode_has_buffers(struct inode *inode)
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&inode->i_data.i_metadata_bhs.list);
+	return !list_empty(&mmb->list);
 }
-EXPORT_SYMBOL_GPL(inode_has_buffers);
+EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
@@ -561,7 +561,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (list_empty(&mmb->list))
+	if (!mmb_has_buffers(mmb))
 		return 0;
 
 	blk_start_plug(&plug);
@@ -803,9 +803,9 @@ EXPORT_SYMBOL(block_dirty_folio);
  */
 void invalidate_inode_buffers(struct inode *inode)
 {
-	if (inode_has_buffers(inode)) {
-		struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
+	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
 
+	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
 			__remove_assoc_queue(mmb, BH_ENTRY(mmb->list.next));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f892abef003..011cb2eb16a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (inode_has_buffers(inode))
+	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 20636599d858..44094fd476f5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -515,7 +515,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
-int inode_has_buffers(struct inode *inode);
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void invalidate_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
-- 
2.51.0

