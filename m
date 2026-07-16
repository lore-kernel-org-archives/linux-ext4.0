Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7032925F98A
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213799; cv=none; b=k0YLFN6/0zf9RxMPWWTe1X+bPsYwvPz6U5CJtpUfhDFnZ+md0oM+BPHSt/szc+wAmuhlqkcRjRErbwgemAkf09XahI8Skhhs17ysQAwZs5T9DHhFIyk0N0oeTULHmOb5JIIvHnf1NwNQjc5wuRkR/jOvQsWynzXs4Ss9UU4eRvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213799; c=relaxed/simple;
	bh=llI8RGLrVqf2YAmiC6qYwgUfAqUbMod9RxhZ+LeqhLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9ojHydgTeKhSaAmXGYV8AQvE2augOzrNNj5ZwRIEcTe6gdvJ12LMsapS7cTTvbgY8MI3gXOorCgNOrC8JksYMjZp2VpUOfMBe72a45VnMxNbiHQAtQzlva5oMjLQ9ZAzJPVvz8x73+YtZH7vtYjGDym1na50M4USz8qQh27b+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE54C3E43;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4AEF779AD;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3XYzKAXxWGoGXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F16EA10A3; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 15/21] bfs: Fix data integrity writeout issues
Date: Thu, 16 Jul 2026 16:55:37 +0200
Message-ID: <20260716145527.3580300-36-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2823; i=jack@suse.cz; h=from:subject; bh=llI8RGLrVqf2YAmiC6qYwgUfAqUbMod9RxhZ+LeqhLo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDslve77mntj8E2zZ736y/9R9wbqfdW4wMsQ f4RYDaVoqaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw7AAKCRCcnaoHP2RA 2V3TB/wJ2X3hU+IlOFqRjU1q3uM1qwCD9wVzbmxR5wDIqSKUNaOxOrHGrjoYL5IWUxxJR1bK+Di uoFB1wUeETtt5K6HEv6T2jzBFAbHBGkujzp4PmBhqTuq3C/Pl1PpVGiGl05XfjQxXAOUdmircrq syjhDp7TUsrJ91czwiuscJ/or9jSqtWkmMgGx+dHv2ZyeQjX5qlwk1j38JkcJd9FnSp0RPEzBV6 2Rwn+YCoioeAXlB2mfq9HaVRKhJz5wCu6c0+cvk09hna72chYlzFqkMe1LU1+wi53MxvotPeT+C 4XiHqtlDG4/uBSvGoXTZinCe7gBJ6t5Td4nKnkIKwIopo9Ep
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: AE54C3E43
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

BFS could fail to properly write out inode on fsync(2) due to races with
WB_SYNC_NONE writeback. Several racing fsyncs could also result in some
fsync returning earlier than all metadata buffers were properly
persisted.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/dir.c   |  9 +--------
 fs/bfs/inode.c | 30 ++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 5b40ab09a796..9b37ec4bd89a 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -68,17 +68,10 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	return 0;
 }
 
-static int bfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	return mmb_fsync(file,
-			&BFS_I(file->f_mapping->host)->i_metadata_bhs,
-			start, end, datasync);
-}
-
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= bfs_fsync,
+	.fsync		= simple_fsync,
 	.llseek		= generic_file_llseek,
 };
 
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e41efdd35db9..cacc7eff9c33 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -136,7 +136,6 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned long i_sblock;
 	struct bfs_inode *di;
 	struct buffer_head *bh;
-	int err = 0;
 
 	dprintf("ino=%08x\n", ino);
 
@@ -165,13 +164,31 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
 	mark_buffer_dirty(bh);
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
-			err = -EIO;
-	}
 	brelse(bh);
 	mutex_unlock(&info->bfs_lock);
+	set_inode_metadata_writeback(inode);
+	return 0;
+}
+
+static int bfs_sync_inode_metadata(struct inode *inode,
+				   struct writeback_control *wbc)
+{
+	int err = 0;
+	struct bfs_inode *di;
+	struct buffer_head *bh;
+
+	di = find_inode(inode->i_sb, (u16)inode->ino, &bh);
+	if (IS_ERR(di))
+		return PTR_ERR(di);
+
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		err = -EIO;
+		goto out;
+	}
+	err = mmb_sync(&BFS_I(inode)->i_metadata_bhs);
+out:
+	brelse(bh);
 	return err;
 }
 
@@ -302,6 +319,7 @@ static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.free_inode	= bfs_free_inode,
 	.write_inode	= bfs_write_inode,
+	.sync_inode_metadata = bfs_sync_inode_metadata,
 	.evict_inode	= bfs_evict_inode,
 	.put_super	= bfs_put_super,
 	.statfs		= bfs_statfs,
-- 
2.51.0

