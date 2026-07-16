Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD4E42A783
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213828; cv=none; b=pE8Qjbcp3vgdz45I6WrvLPLpyl8NpO/f+AlMvcWa26ZwXw/WR0ywHPOndtcIIX9AQ0ucyIEIeithdkIojchF9lPeGPijuqzMNO/kUeQM3Pci5kT02cvM8uDHXSeBXpcwfDeWttouGdnlj2j4hb7OQWLvfjv7w4/QojMnnvjUSf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213828; c=relaxed/simple;
	bh=QG2LVpd0do8ofgyapR6F2An7YiIoSNfQiEsVG0fxauI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THc5Bh/4gtbDXlADbktQF6dB75Stho4a2xuilY5TzsZEmZR5RCCDDL88NWsE8W1HWXv4Ri45aEBO2QLouDCj/JmoXnllQml+IkAeTySmYzB0J+UV6WUaQaI0DM/iQI8+bBAugf0LMsC+B5ydwpfbJL3VyTBH6khs+0ehF5CJjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE18E789DA;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA1F6779AF;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wK1WMQXxWGoZXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AEC09A12F6; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 18/21] fat: Fix missed inode writeback during fsync(2)
Date: Thu, 16 Jul 2026 16:55:40 +0200
Message-ID: <20260716145527.3580300-39-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4735; i=jack@suse.cz; h=from:subject; bh=QG2LVpd0do8ofgyapR6F2An7YiIoSNfQiEsVG0fxauI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDutuZmR6bd4DsA0xVVDhmkjMQjqm+A7Uyxp uUwdB9d8rOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw7gAKCRCcnaoHP2RA 2d0yCAC6UuQCIhqf1CTFewp9dvEh0obg0KGw+6tZw/TcylF7AZb9W0Eu11JQeT6DfdHnpJLCiZs Bar6tRGMgZEf2i5k5gf+bcjAWuEgNUA1iS8AcvlzdyV8yXkEWr5ONMFZl/31F1wepHskbz9eZi1 r/evqnSoS33EKfrZPtoAgBMrXL2gDZv0225THdqk5/EQy+J4mhttbod97q36tzda6LW3h8qVOQ8 7oQMdX14WNIDK9+e7PMx7yyGqxbtwzlzg1atgnUWzw4eX0PjbiDYCK9jSsluFGWt/AqyWs/LJ3w 101yFGu2SWHS3tp7tfH9lchuypa6X4ICR97kyF6HGShob/+s
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: DE18E789DA
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

