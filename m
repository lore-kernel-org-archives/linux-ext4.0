Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974D39656D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519054; cv=none; b=qiC3xQjx/ZOIRogVzhqpXfsQX47q7lkf0mghO+0cknEuoRkA46CH+2obDgu+TvpNcf45V0zayk4tb1cGTpQzT+SLqU9BB7mZWZhcdXrpjW6GZyjLIFW9T8VZQ+eYTIitmUl7qAn8F36o0+pBMw6Mm869ySgsOZU5eWOnXvGgwEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519054; c=relaxed/simple;
	bh=zcHN97EwD1Y/vlUwirfZ68msBRzbfUd919+cBu1Gy8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMUv2/etb7Mqi2nHRgQ1tLMbPevLP3819uNkKrXmHRkHgndawpTnk2gIKFCb/SJk2IfsDgBl3EMhUTIFNCaXxrhcJhnqDfj6gBRHYkImaD+i+8/ehuXL992Bt4SdGBOQayb54zMGaK7A5HEfyRgpTEKtzfHxsVeu94+OPeCMzvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ux56Y7de; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cXbY8Urw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ux56Y7de; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cXbY8Urw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ux56Y7de";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cXbY8Urw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ux56Y7de";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cXbY8Urw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BBCD5BDC2;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6APxvH5SmdcIHWcl7TBM1pTXqnKMUAJBlKozlmMHFBc=;
	b=Ux56Y7de55mwt3O75RUMHz6DquJzQOf4siyFs/s+smE6/jpzxY/FTEJ1JRUlFsOzEbLuJV
	TSANMbSzS16KRgEcX6Zt95zXRzW0MiKyjUIg/nvC8hMb+dO1qjxLfKUCXV7tltvI1+inEj
	yOOgIl3wtK0R2dUhUk7Q03jrea6C1b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6APxvH5SmdcIHWcl7TBM1pTXqnKMUAJBlKozlmMHFBc=;
	b=cXbY8Urw21mohEWbRXIRtbAIhbpoHjoLVWQVgQ2Ycu0Cqom3vHrrxr0k6DF3vlVYoOEcWD
	DDvfJc521BOCI8Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ux56Y7de;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cXbY8Urw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6APxvH5SmdcIHWcl7TBM1pTXqnKMUAJBlKozlmMHFBc=;
	b=Ux56Y7de55mwt3O75RUMHz6DquJzQOf4siyFs/s+smE6/jpzxY/FTEJ1JRUlFsOzEbLuJV
	TSANMbSzS16KRgEcX6Zt95zXRzW0MiKyjUIg/nvC8hMb+dO1qjxLfKUCXV7tltvI1+inEj
	yOOgIl3wtK0R2dUhUk7Q03jrea6C1b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6APxvH5SmdcIHWcl7TBM1pTXqnKMUAJBlKozlmMHFBc=;
	b=cXbY8Urw21mohEWbRXIRtbAIhbpoHjoLVWQVgQ2Ycu0Cqom3vHrrxr0k6DF3vlVYoOEcWD
	DDvfJc521BOCI8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 833284A0B1;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XacHIHUCxWn2YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AA7A7A0C78; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 34/42] ext2: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:28 +0100
Message-ID: <20260326095354.16340-76-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4123; i=jack@suse.cz; h=from:subject; bh=zcHN97EwD1Y/vlUwirfZ68msBRzbfUd919+cBu1Gy8s=; b=kA0DAAgBnJ2qBz9kQNkByyZiAGnFAk+jrbUrX8v69NsO/nyH/ePXsmPvf0C8YPco8iOLr9wUc okBMwQAAQgAHRYhBKtZ0SvWnjKKtVUoHJydqgc/ZEDZBQJpxQJPAAoJEJydqgc/ZEDZzwIH/Ru0 2AF+/teHTL5QT0y+e7OM1JSXSgtJVvs45IucCcMez844DMUE9ky8I1vCvwsQFDJzoEvJai4ZaNN hvGzJQNe1KukBiOsNsjbkIHfNsH6NHyvL3MqtCP382ebyjrHKTadS9CP2+J2s1XycVtqpHkNTDF U33nQqpPdfiTOqHP26e7n5XjTXbA/PKkFArdlvxlIQbdlcs9kRZMsaEZIFyDcW9+P6lGncdtGLn XLlwF3Z+xXq+FCkwyQCIIN9eQTAk9RzS7Nvcljc8WKpaQCTijjvpiuTT7ltOCY9dcH5HY/2aMPz Rqp32kpQbzXRh/x/Va3tW9q5BUMOXqTSdtRD4G4=
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9BBCD5BDC2

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  |  6 ++++--
 fs/ext2/inode.c | 16 +++++++++-------
 fs/ext2/super.c |  1 +
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e0c6c5fcb6c..3eb1f342645c 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -676,6 +676,7 @@ struct ext2_inode_info {
 #ifdef CONFIG_QUOTA
 	struct dquot __rcu *i_dquot[MAXQUOTAS];
 #endif
+	struct mapping_metadata_bhs i_metadata_bhs;
 };
 
 /*
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ebe356a38b18..d9b1eb34694a 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -156,9 +156,11 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int ret;
-	struct super_block *sb = file->f_mapping->host->i_sb;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
 
-	ret = generic_buffers_fsync(file, start, end, datasync);
+	ret = mmb_fsync(file, &EXT2_I(inode)->i_metadata_bhs,
+			start, end, datasync);
 	if (ret == -EIO)
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fb91c61aa6d6..fa33a6e79b93 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -95,9 +95,9 @@ void ext2_evict_inode(struct inode * inode)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate(&EXT2_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	ext2_discard_reservation(inode);
@@ -527,7 +527,7 @@ static int ext2_alloc_branch(struct inode *inode,
 		}
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &EXT2_I(inode)->i_metadata_bhs);
 		/* We used to sync bh here if IS_SYNC(inode).
 		 * But we now rely upon generic_write_sync()
 		 * and b_inode_buffers.  But not for directories.
@@ -598,7 +598,7 @@ static void ext2_splice_branch(struct inode *inode,
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
-		mark_buffer_dirty_inode(where->bh, inode);
+		mmb_mark_buffer_dirty(where->bh, &EXT2_I(inode)->i_metadata_bhs);
 
 	inode_set_ctime_current(inode);
 	mark_inode_dirty(inode);
@@ -1211,7 +1211,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 		if (partial == chain)
 			mark_inode_dirty(inode);
 		else
-			mark_buffer_dirty_inode(partial->bh, inode);
+			mmb_mark_buffer_dirty(partial->bh,
+					      &EXT2_I(inode)->i_metadata_bhs);
 		ext2_free_branches(inode, &nr, &nr+1, (chain+n-1) - partial);
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
@@ -1220,7 +1221,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 				   partial->p + 1,
 				   (__le32*)partial->bh->b_data+addr_per_block,
 				   (chain+n-1) - partial);
-		mark_buffer_dirty_inode(partial->bh, inode);
+		mmb_mark_buffer_dirty(partial->bh,
+				      &EXT2_I(inode)->i_metadata_bhs);
 		brelse (partial->bh);
 		partial--;
 	}
@@ -1303,7 +1305,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (inode_needs_sync(inode)) {
-		sync_mapping_buffers(inode->i_mapping);
+		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 		sync_inode_metadata(inode, 1);
 	} else {
 		mark_inode_dirty(inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 603f2641fe10..4118a3a1f620 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -215,6 +215,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
-- 
2.51.0

