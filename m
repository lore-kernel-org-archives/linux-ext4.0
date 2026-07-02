Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910F937A83C
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016524; cv=none; b=s4mxWhfrFh2rktQafS41QVRyjsm9HBen+UFOBumwBUczitLIt7VA0XGtpMjCqquexIKeNE/x6lC0HcUiGDR/oanH/Y7RVK4TlAIMiZ88L3EVpECEG07sGfQ+nR4CfZLTZFC2Wu3UAEBS20GG42HryUVnxni43/IONFdxjexjj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016524; c=relaxed/simple;
	bh=JhyibOKQehpNyooLRGGCJa6vt4XiP6K25upDOBsUZDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrY3/mRlZb+Sq/BdC22D4XVaL6CcLtvHgui3jMH3vo6JMfB6Xm3UtURs/2itKY9JOa9SBEVVkbV9CIvQgaQhk2bSC7Jb7puFE/HFDzCqsSPQ0E+S6sZKJf/L3Z7Q/cgFSTQBriSebFNFrncc2nQEonltUf0KAb8UxyfeJncnh1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L8UTLnAd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BzAD2xgQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L8UTLnAd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BzAD2xgQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L8UTLnAd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BzAD2xgQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L8UTLnAd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BzAD2xgQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2462E760E8;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEQpp7X4hTcOIvhYIsJtNuvzkaipI6VVSLiSOWP8P7s=;
	b=L8UTLnAdqabMD1/mRV36Sclh2KZjcsPwSLkguLGwjvgBJY4OGym7GtzB8CTn+g/upIOZ8G
	fVEmwEgrAxP0kQOyn6m1205Aw2X7tyNUgoHqiKzjERUcc/CXpFXPQmaxma9CDH5DQkUr1m
	9TeEHtj+FvdX0nekOraCEdreHEX5OXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEQpp7X4hTcOIvhYIsJtNuvzkaipI6VVSLiSOWP8P7s=;
	b=BzAD2xgQoRDYVNLGV0c9f2vxT0fKnikeDts3vDhxvH/a78aO6kOQ7YTwJ6lMLTu8JpNKds
	RIiJ4NNErj0BnlBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEQpp7X4hTcOIvhYIsJtNuvzkaipI6VVSLiSOWP8P7s=;
	b=L8UTLnAdqabMD1/mRV36Sclh2KZjcsPwSLkguLGwjvgBJY4OGym7GtzB8CTn+g/upIOZ8G
	fVEmwEgrAxP0kQOyn6m1205Aw2X7tyNUgoHqiKzjERUcc/CXpFXPQmaxma9CDH5DQkUr1m
	9TeEHtj+FvdX0nekOraCEdreHEX5OXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEQpp7X4hTcOIvhYIsJtNuvzkaipI6VVSLiSOWP8P7s=;
	b=BzAD2xgQoRDYVNLGV0c9f2vxT0fKnikeDts3vDhxvH/a78aO6kOQ7YTwJ6lMLTu8JpNKds
	RIiJ4NNErj0BnlBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04C76779AC;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YTUtASGsRmr9FwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2E716A10AA; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 08/19] ext2: Fix data integrity writeout issues
Date: Thu,  2 Jul 2026 20:21:05 +0200
Message-ID: <20260702182057.2832980-27-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5270; i=jack@suse.cz; h=from:subject; bh=JhyibOKQehpNyooLRGGCJa6vt4XiP6K25upDOBsUZDQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwPNJiJiCxAhdkkfUpKqF6nCZQIF8mlRdKyz zKxaxwAbTaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasDwAKCRCcnaoHP2RA 2VZnCAC0Jji+/1wnJcnNcJLRZjlQG9R761IhbleOsr5k2rraUHgRF0m3L9YeVchJe/tGIGjpmTR XnWnnibu4DJsC500ki60AZibGlne3mLztFoFg/Y2VoNFaRiA6vt8rUy+3kVBuG40f4MWLOl/9mc SetO/3wWwKJEw5OfaJmxOqngx8DjlY9czU3HAEoNRK/LGtTqeciVWmDx5EE3iFhzhcBDUncpYoJ JZFPw+QrJbbiikYftykVGhMviRfUdyB9vsMiOXJuaUwUjWso+kvjg3fXDldu0GCSLBR00CjtMu2 SCfRoKimWWCvveFwRVhRfv2YMx4OIeSYYsJW2xGoBdaaBaiy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Ext2 could fail to properly write out inode on fsync(2) due to races
with WB_SYNC_NONE writeback. Several racing fsyncs could also result in
some fsync returning earlier than all metadata buffers were properly
persisted. Finally DIRSYNC handling was not properly persisting all
inode related metadata.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c   |  2 +-
 fs/ext2/ext2.h  |  3 +--
 fs/ext2/file.c  | 17 +----------------
 fs/ext2/inode.c | 35 +++++++++++++++++++++++------------
 fs/ext2/super.c |  1 +
 5 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 278d4be8ecbe..e17bbc7598c1 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -734,6 +734,6 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= ext2_fsync,
+	.fsync		= simple_fsync,
 	.setlease	= generic_setlease,
 };
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 79f7b395258c..5642451bf191 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -735,6 +735,7 @@ extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 /* inode.c */
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, struct writeback_control *);
+extern int ext2_sync_inode_metadata(struct inode *, struct writeback_control *);
 extern void ext2_evict_inode(struct inode *);
 void ext2_write_failed(struct address_space *mapping, loff_t to);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
@@ -772,8 +773,6 @@ extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
-extern int ext2_fsync(struct file *file, loff_t start, loff_t end,
-		      int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 8dca9ec4cacd..b9020df7d89e 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -47,21 +47,6 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
-int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	int ret;
-	struct inode *inode = file->f_mapping->host;
-	struct super_block *sb = inode->i_sb;
-
-	ret = mmb_fsync(file, &EXT2_I(inode)->i_metadata_bhs,
-			start, end, datasync);
-	if (ret == -EIO)
-		/* We don't really know where the IO error happened... */
-		ext2_error(sb, __func__,
-			   "detected IO error when writing metadata buffers");
-	return ret;
-}
-
 static ssize_t ext2_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -213,7 +198,7 @@ const struct file_operations ext2_file_operations = {
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= ext2_file_open,
 	.release	= ext2_release_file,
-	.fsync		= ext2_fsync,
+	.fsync		= simple_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 48862e73610c..51656641c4e5 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1563,20 +1563,31 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	/*
-	 * For sync(2) the generic code will call sync_blockdev() to write
-	 * all metadata more efficiently.
-	 */
-	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
-				sb->s_id, (unsigned long) ino);
-			err = -EIO;
-		}
-	}
 	ei->i_state &= ~EXT2_STATE_NEW;
 	brelse (bh);
+	set_inode_metadata_writeback(inode);
+	return err;
+}
+
+int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
+{
+	struct buffer_head *bh;
+	struct ext2_inode *raw_inode = ext2_get_inode(inode->i_sb, inode->i_ino,
+						      &bh);
+	int err = 0;
+
+	if (IS_ERR(raw_inode))
+		return -EIO;
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		printk("IO error syncing ext2 inode [%s:%08lx]\n",
+		       inode->i_sb->s_id, (unsigned long)inode->i_ino);
+		err = -EIO;
+		goto out;
+	}
+	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
+out:
+	brelse(bh);
 	return err;
 }
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3999f8f3b156..a40f530872a4 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -362,6 +362,7 @@ static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.free_inode	= ext2_free_in_core_inode,
 	.write_inode	= ext2_write_inode,
+	.sync_inode_metadata = ext2_sync_inode_metadata,
 	.evict_inode	= ext2_evict_inode,
 	.put_super	= ext2_put_super,
 	.sync_fs	= ext2_sync_fs,
-- 
2.51.0

