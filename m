Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7CB3E0248
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699539; cv=none; b=X41O47x5JK/qLAPyqpEWqUPPgyHqTW2VLgmmcp+wWqZSo6cL4LNFMkFQFetpetI5bqqFN5qdFWrbD7YEYezMEFzN0fXqyplZWENqg2bLG5n3hP7fM8zFxIf9sxbieSyiyKATd9HWUg3/TpG32T2XdD5O9/GU9tEt0xX9TlPKUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699539; c=relaxed/simple;
	bh=4/1pgAmao0lTQ0DVJswth+03BjeNbSO8j/pGIRjZ3Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG6ClLf5sEbjWMDWMMy/2txuLCKfTuleL312x2kNE1plqhgYINmG6PVHq2OciloJvFGhXLOSTc64AVS165VRO7EtEYydVSCAfl1Sdze8MfmmnhVQOmjAKuB27e8BA7CcCySya4qivAfvowwGFgdAn+q1N0/w2ki1R7gZWS6PBsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1F8275922;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD44559B6E;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j680Lj0PFGrQbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D711BA0A7E; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 09/10] ext4: Use mmb infrastructure for inode buffer writeout
Date: Mon, 25 May 2026 10:58:15 +0200
Message-ID: <20260525085821.769119-19-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4501; i=jack@suse.cz; h=from:subject; bh=4/1pgAmao0lTQ0DVJswth+03BjeNbSO8j/pGIRjZ3Ag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA805ibsNDiaDvxYMbz/QKcXMLQe9xAfDD54W dqpR0Dlj/eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPNAAKCRCcnaoHP2RA 2ZkWCAC/PNp4/jkm3423GiMsyQtGqTeBfjrNiguAldWVJDdIqUrLsSqmNZygRIGy3MbZhrC8vfx gpODBTHgUthRLmfKPVol45evuBII34LPN1oH7PXzSvOcn6GEDffx4J5foUS689dIT7TjqzqSUOL zyRwanglRo2M7oAOakdiMGpvAEjFvB4UMuoKlYRNAQHiGAvOiKQsHLSx27F2ySIchjaI6vto1fD xsld3IFDF/6RGrs03TgVEGBDbe8N9BWguyK0PvAsWCg97DzLlhDFu59sMcaO7LoMjHrrD/ZlZTl fuvgKv98kgB8lmHgj2F5UP93AVufND81keXR5g6XJPLwDppK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: D1F8275922
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

Use mmb inode buffer writeout infrastructure to reliably write out
inode's inode table block on fsync(2) in nojournal mode (from
ext4_sync_parent() and ext4_fsync_nojournal()). This significantly
simplifies the code as we don't have to explicitely handle inode buffer
writeback in ext4_write_inode() and thus we can also remove
sync_inode_metadata() calls from ext4_sync_parent() and
ext4_write_inode() call from ext4_fsync_nojournal().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c |  2 +-
 fs/ext4/ext4_jbd2.h |  2 ++
 fs/ext4/fsync.c     | 12 ------------
 fs/ext4/inode.c     | 33 ++++++++++-----------------------
 4 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 752326f3b653..3d6b8f494a76 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -350,7 +350,7 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 	return 0;
 }
 
-static void ext4_inode_attach_mmb(struct inode *inode)
+void ext4_inode_attach_mmb(struct inode *inode)
 {
 	struct mapping_metadata_bhs *mmb;
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 63d17c5201b5..2a01b8279c88 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -122,6 +122,8 @@
 #define EXT4_HT_EXT_CONVERT     11
 #define EXT4_HT_MAX             12
 
+void ext4_inode_attach_mmb(struct inode *inode);
+
 int
 ext4_mark_iloc_dirty(handle_t *handle,
 		     struct inode *inode,
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c104f55a0242..1cb613478386 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -75,9 +75,6 @@ static int ext4_sync_parent(struct inode *inode)
 			if (ret)
 				break;
 		}
-		ret = sync_inode_metadata(inode, 1);
-		if (ret)
-			break;
 	}
 	dput(dentry);
 	return ret;
@@ -87,10 +84,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 				int datasync, bool *needs_barrier)
 {
 	struct inode *inode = file->f_inode;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = 0,
-	};
 	int ret;
 
 	ret = mmb_fsync_noflush(file, READ_ONCE(EXT4_I(inode)->i_metadata_bhs),
@@ -98,11 +91,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	if (ret)
 		return ret;
 
-	/* Force writeout of inode table buffer to disk */
-	ret = ext4_write_inode(inode, &wbc);
-	if (ret)
-		return ret;
-
 	ret = ext4_sync_parent(inode);
 
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e66e9510909..651201849667 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5696,10 +5696,16 @@ static int ext4_do_update_inode(handle_t *handle,
 		ext4_update_other_inodes_time(inode->i_sb, inode->i_ino,
 					      bh->b_data);
 
-	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, bh);
-	if (err)
-		goto out_error;
+	if (!ext4_handle_valid(handle)) {
+		if (!ei->i_metadata_bhs)
+			ext4_inode_attach_mmb(inode);
+		mmb_mark_inode_buffer_dirty(iloc->bh, ei->i_metadata_bhs);
+	} else {
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, NULL, bh);
+		if (err)
+			goto out_error;
+	}
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 	if (set_large_file) {
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");
@@ -5786,24 +5792,6 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 						EXT4_I(inode)->i_sync_tid);
-	} else {
-		struct ext4_iloc iloc;
-
-		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
-		if (err)
-			return err;
-		/*
-		 * sync(2) will flush the whole buffer cache. No need to do
-		 * it here separately for each inode.
-		 */
-		if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
-			sync_dirty_buffer(iloc.bh);
-		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
-			ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
-					       "IO error syncing inode");
-			err = -EIO;
-		}
-		brelse(iloc.bh);
 	}
 	return err;
 }
@@ -6348,7 +6336,6 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
-
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
 	err = ext4_do_update_inode(handle, inode, iloc);
 	put_bh(iloc->bh);
-- 
2.51.0

