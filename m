Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7153F4854
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149464; cv=none; b=PwRsJly64MSpgRxkFB+GeBiAt2OmFf3EzXLXg2hHmbJfM3hmoYWgmcuiWmQDyc2xyUd9v5+xUmBRRxl1iIxrzPOxDDo5heGakGTmBY2pH084lbd3BYAbSsQI99HSkANhobQ2MWYJnWe8SLQliH/XhJRcG53TfJdrpb0m2jUhOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149464; c=relaxed/simple;
	bh=zdILv8fZ7mTJ/FtPj4PE5ASsi0rosJ+3mUWzlRJaka8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB8L/lGa9lxSmOgBmypVUgHZ4fRrHFi8PueP8GNdrDJfu4IDSsQ8n9IFNFtC/MaXB6Ffo0dfi2X8xPieFA9Q1JcHIaHO+Kohjjr7tyHHzBvzrSF9SelcJc9MdmVPPFOfUMH1yam7Db8ComwK9nO0wnbTy855AQXyW/H2NRq3HfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DkM2oGLA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1l8mNkz0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kw8iw8l7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NxRbAoIm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DkM2oGLA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1l8mNkz0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kw8iw8l7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NxRbAoIm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6861B5242;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4EFuCKVEdhaBGFi8xcQCygBIEjYRYhrW3lHiIg6Y3w=;
	b=DkM2oGLAngk0pZ/d8PbTmH6nDFseOay7t+wJK0WKcWsVuP1suw5ca+MCVi9ndmjK7L6fx4
	b9x/kCUgiK+uIHsKaO8OlmRQfNksi8IyE+HZTC2E26YqV5hvJdHcgBA2D755nbDdSlF8Wn
	fwxaddOswJXHGDFrGLYMwGtnqLuzaXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4EFuCKVEdhaBGFi8xcQCygBIEjYRYhrW3lHiIg6Y3w=;
	b=1l8mNkz0vPYSHGf/fttzEFMpFPgdsmEMifNYt3YlpVydZrlnZ35JC1p5jIVp5cjv2jotlG
	BNtxsLhf2/nkjtDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kw8iw8l7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NxRbAoIm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4EFuCKVEdhaBGFi8xcQCygBIEjYRYhrW3lHiIg6Y3w=;
	b=kw8iw8l7uCUgbcD3WF3yGUzsjyWY6Ktx6+3fMscRV1pwA7vTAUJ+n0JduHJjXVTVaffEV7
	J1A1Dj6lX2zJCthpXMuFDAvvzsWn2ITaZt3/nM5Bf+mjzGem6fbpGUprbL3ZEVgCRV6mL3
	JSglyrRDPNyio65SrKaQuHwGIOuGZ30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4EFuCKVEdhaBGFi8xcQCygBIEjYRYhrW3lHiIg6Y3w=;
	b=NxRbAoImemOFQba2LTMx+AybW1m/AzGMpxv1BABW1eGhqEn7beeS1KpxR1/79vsUssre6b
	WltkmV5IDYf6w2Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 608CB779D7;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kdZVF8w3Z2olawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 73D89A133B; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 15/20] bfs: Fix data integrity writeout issues
Date: Mon, 27 Jul 2026 12:49:33 +0200
Message-ID: <20260727104923.3828017-35-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2825; i=jack@suse.cz; h=from:subject; bh=zdILv8fZ7mTJ/FtPj4PE5ASsi0rosJ+3mUWzlRJaka8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze/eOHyc6jRrOCay9VGzKF5Al/G20Hejp59E FNfSyQ7xDmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3vwAKCRCcnaoHP2RA 2aDxCACYrVIkcjDyWu1M7Vl0ct9zEjSF+qbqR8c5HzH8E34xkgwtLBQ8tavU57nMttV9TGbTM3q XSkBeJiPacXQmWJPpsAyXYuOC1464REf1nllOSSl2lwdV04gY0yCNLU1w/ZNYRtR9UA99vJP5Qz SgGXmwRJjPKP52BWqM6k5ec8sNbe/21lyGwN7cuEvwyDNlJvZ4eNRJ9n/rOzZUZ09abvqZoq/Eg GwppZzUlcsownlyeEGOLeitely4uImU3VTKWH5cEkxD5smv62IfA915HiSQtlbhSvWbedjuYCwK dCzuO3kW+xsh+EaA21v/nV5vvbroYPNcY7xSo3nWZHOXyxpU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid,suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6861B5242
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

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
index e41efdd35db9..06e3a848b4ef 100644
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
+	di = find_inode(inode->i_sb, (u16)inode->i_ino, &bh);
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

