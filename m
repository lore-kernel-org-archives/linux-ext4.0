Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9B3E51DA
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699529; cv=none; b=PzHDxdzDuSSCJUQnwuEpblQL2CJeRcn2IRMNKegdVKagv8jDxKKUyNeDBs/59dn1lP1R44QWJI0pbdj3+AzqymjjOOmKIo5dkdskJ5/b/QW1A0JllWJe+wf+GykfZ9mivFYoZnrucGubdzxee8xH4pWmsqOW/R4x3lNTvEGgD18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699529; c=relaxed/simple;
	bh=y/Yh2rI2ILcFNVagCjqbgSoT0wCD+uFAViLSLkYT0Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOEYaVG6goAgs0hlslHTDSUfNDnIMo/5YS1B2O/6pjX9Z7mz2D/Cd4ea5g+mOFRUYjyoYziGtSdlrvA6NdHu0rRZQ7YIGP2rDzWXiGwtpvFRdmdiKjHRdMUb51HLGyz+syLMa2D/ze+2QqnD9K7fLFkPTsBvtf09uoYTf88g6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 813F364B6E;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7914959B70;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qgVQHT0PFGrJbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C84C3A0A01; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 06/10] fat: Fix possibly missing inode write on fsync(2)
Date: Mon, 25 May 2026 10:58:12 +0200
Message-ID: <20260525085821.769119-16-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1396; i=jack@suse.cz; h=from:subject; bh=y/Yh2rI2ILcFNVagCjqbgSoT0wCD+uFAViLSLkYT0Ac=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8ydvdxYfHwhIzR6Ohw6vT3OoShv3KsjqI04 1pgbKBlk6iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPMgAKCRCcnaoHP2RA 2bQRCACwXH91mn8xNPgxqrtYWKIpAIO5Q5DU40sm9tylX1H3tLTT1nuIhDiHeSjIDO/X5wsdUKu qqj0m471TXcwj0GDcofTs92oHVD4m4UoEXiez74uE+dS/9+S2pDdmS0pVJ78W8SLVo1nBtBACBF EdgERpIUMAmdJ2ZMQqqrsyQK41I+xBoz11d49/iaV94DDUeXuaOer5qAKv1rBJEWEv5UfpVzUm2 gXsViSvdF6AHF6BR/7DaqtslbAZft60JGSRHjkKgbAZ7bwyWElHtVP+UDiMV0IQWe94ah5QyK0+ R8sY1KKTNqe2PXdAIX863Rv+ApK8y7e5IzNHilxN8AAZy1p4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 813F364B6E
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 28f78df086ef..1ffbfee1a9ad 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -431,6 +431,9 @@ EXPORT_SYMBOL_GPL(fat_attach);
 void fat_detach(struct inode *inode)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+
+	/* The block isn't associated with the inode anymore... */
+	mmb_clear_inode_blk(&MSDOS_I(inode)->i_metadata_bhs);
 	spin_lock(&sbi->inode_hash_lock);
 	MSDOS_I(inode)->i_pos = 0;
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
@@ -906,7 +909,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
 				  &raw_entry->cdate, &raw_entry->ctime_cs);
 	}
 	spin_unlock(&sbi->inode_hash_lock);
-	mark_buffer_dirty(bh);
+	mmb_mark_inode_buffer_dirty(bh, &MSDOS_I(inode)->i_metadata_bhs);
 	err = 0;
 	if (wait)
 		err = sync_dirty_buffer(bh);
@@ -925,7 +928,7 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = fat_clusters_flush(sb);
 		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
-		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+		err = __fat_write_inode(inode, 0);
 
 	return err;
 }
-- 
2.51.0

