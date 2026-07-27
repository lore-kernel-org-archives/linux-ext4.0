Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA103FB7C1
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149445; cv=none; b=JdjkRi2IDKIwGPI4j1bBsXHIX1cFxVVKgxjddDpJ/TRD9NVgiGTEcC09GXRqoaL7ZlxuQgH1R0YxaV8jVgAF6jjQ6LaCRuF3CNgpdPcXTkFg6DCyBMyYWv9DzubVd4x35ZbYox4a7OMXr0wVvuDEaV3MQSsvVjcmABBwFjS1cVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149445; c=relaxed/simple;
	bh=ejspJvANjWvDzVMA0IxwP41Wi4JESDm5nzXIomuqDyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJEHrByRRzBuhn4xR0ILH7qBCUwvxIL1fqZeQ8nTeY2+OR63C16/+waJCr65ZGsObbYj0fb42wEYECSKiuWFhi0iUBHUxLld98HoDDgbeIjtrQP0AOm0nMX45ORMvlcf0WI3rQ/cya4hUATBzF1g0vKHu6XQbaa2NyLvNIeJ5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f39Xhfy1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ybyRwL+y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uP9bFCTZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BQWtAjsR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f39Xhfy1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ybyRwL+y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uP9bFCTZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BQWtAjsR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72DE87DAF6;
	Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6i9Nian6Uk6NKmMGXZ/it4vlUCAM7P8C9nVOJJnALs=;
	b=f39Xhfy12FIkpgpchOs/G0RKgwML9PC9KLXE7r5ErjE+6iXUz9cFdB9FWMy+4pcqn6A70G
	ril7oFgVLO/fRvqD/jSR9iEz8gqAagD6ZBVLzurHBA41SfID7d2zN4mIryzBnYFW70dMnQ
	M36R4BjCPX003EIZFa26XuiNphC4Yyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6i9Nian6Uk6NKmMGXZ/it4vlUCAM7P8C9nVOJJnALs=;
	b=ybyRwL+yMuXvH2wITDjFfuUWv834tj8wqYjDRmb4ob1Uv7ISBeagEiyFC8d+96k3f4LaLB
	HvKi3NkVsQzhWICQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uP9bFCTZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BQWtAjsR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6i9Nian6Uk6NKmMGXZ/it4vlUCAM7P8C9nVOJJnALs=;
	b=uP9bFCTZDXUsVu39h/tzTpwNuEygukgfpgzGbW8E2r+wY7IDlvHZZAxvLqszbXbfbJvSRQ
	Y9g5ztxi52ueE4KfuzkCPestomZ1PhYf3F5RtR4wH5Yx26wLAFvxAUaEx56QP1nUwn0WIs
	OCxA+ah33GCUEz6FE02pGlCwqiUKcjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6i9Nian6Uk6NKmMGXZ/it4vlUCAM7P8C9nVOJJnALs=;
	b=BQWtAjsRBowdgyN2zYvYMKdx00/xH3cnbTfIcAMAVLQQsF6bQ/rNtZYC9Y5BkL0QVrwSLR
	ishyt+okI3DpzwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8095A779D9;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z75iH8w3Z2orawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 796D3A133C; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 16/20] minix: Fix data integrity writeout issues
Date: Mon, 27 Jul 2026 12:49:34 +0200
Message-ID: <20260727104923.3828017-36-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6549; i=jack@suse.cz; h=from:subject; bh=ejspJvANjWvDzVMA0IxwP41Wi4JESDm5nzXIomuqDyU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzfAfrkJJihwFQcnULvC0obKUS8/gIXK2RMB1 4DRTdjKlVSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3wAAKCRCcnaoHP2RA 2TO0B/4pLDdlVcgAmi+TEjcv79gGca4xFLMuesVf0yD41nCz7pL0bGOIg9ezOS3XjLxnCvphG+j hzVxHwnq/jmxlKPrDtAl3WDnMWW+XYYXvzjO2pKFiEbsgounDFG8Wb7AQBllBvki8ytw+yeyH3q SJG1+b2M9f2RkauTEgHoDbvQE0Y1szeAt10tBF09lftJ5XOVvJT06qvL7rULSC7XnD3+EzdRsqH vQ3KTx2/MjfVFxvNLitesDRKQK7pCjRdsbPSD71hUTVLSJERRQHpJKg11KAYW8ylU4r+duMpu55 2zcJY7JhinDv2QVW2PWflgT88A7kbDaCnq9W/1uqMOHFNqQD
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid,suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 72DE87DAF6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Minix could fail to properly write out inode on fsync(2) due to races
with WB_SYNC_NONE writeback. Several racing fsyncs could also result in
some fsync returning earlier than all metadata buffers were properly
persisted. Furthermore DIRSYNC handling missed writing inode related
metadata.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c   |  2 +-
 fs/minix/file.c  |  9 +--------
 fs/minix/inode.c | 52 ++++++++++++++++++++++++++++++++----------------
 fs/minix/minix.h |  1 -
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 361d26d87d2e..2ca16f849d5a 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= minix_fsync,
+	.fsync		= simple_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index 86e5943cd2ff..02aabbdb5dea 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -10,13 +10,6 @@
 #include <linux/buffer_head.h>
 #include "minix.h"
 
-int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	return mmb_fsync(file,
-			&minix_i(file->f_mapping->host)->i_metadata_bhs,
-			start, end, datasync);
-}
-
 /*
  * We have mostly NULLs here: the current defaults are OK for
  * the minix filesystem.
@@ -26,7 +19,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= minix_fsync,
+	.fsync		= simple_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index c30cc590698d..daf83e4ff25c 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -24,6 +24,8 @@
 
 static int minix_write_inode(struct inode *inode,
 		struct writeback_control *wbc);
+static int minix_sync_inode_metadata(struct inode *inode,
+				     struct writeback_control *wbc);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 
 void __minix_error_inode(struct inode *inode, const char *function,
@@ -128,6 +130,7 @@ static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.free_inode	= minix_free_in_core_inode,
 	.write_inode	= minix_write_inode,
+	.sync_inode_metadata = minix_sync_inode_metadata,
 	.evict_inode	= minix_evict_inode,
 	.put_super	= minix_put_super,
 	.statfs		= minix_statfs,
@@ -630,7 +633,7 @@ struct inode *minix_iget(struct super_block *sb, unsigned long ino)
 /*
  * The minix V1 function to synchronize an inode.
  */
-static struct buffer_head * V1_minix_update_inode(struct inode * inode)
+static int V1_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -639,7 +642,7 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode)
-		return NULL;
+		return -EIO;
 	raw_inode->i_mode = inode->i_mode;
 	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
 	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
@@ -651,13 +654,15 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 	else for (i = 0; i < 9; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i1_data[i];
 	mark_buffer_dirty(bh);
-	return bh;
+	brelse(bh);
+	set_inode_metadata_writeback(inode);
+	return 0;
 }
 
 /*
  * The minix V2 function to synchronize an inode.
  */
-static struct buffer_head * V2_minix_update_inode(struct inode * inode)
+static int V2_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
@@ -666,7 +671,7 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode)
-		return NULL;
+		return -EIO;
 	raw_inode->i_mode = inode->i_mode;
 	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
 	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
@@ -680,29 +685,42 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 	else for (i = 0; i < 10; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i2_data[i];
 	mark_buffer_dirty(bh);
-	return bh;
+	brelse(bh);
+	set_inode_metadata_writeback(inode);
+	return 0;
 }
 
 static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	if (INODE_VERSION(inode) == MINIX_V1)
+		return V1_minix_update_inode(inode);
+	return V2_minix_update_inode(inode);
+}
+
+static int minix_sync_inode_metadata(struct inode *inode,
+				     struct writeback_control *wbc)
 {
 	int err = 0;
 	struct buffer_head *bh;
+	void *raw_inode;
 
 	if (INODE_VERSION(inode) == MINIX_V1)
-		bh = V1_minix_update_inode(inode);
+		raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	else
-		bh = V2_minix_update_inode(inode);
-	if (!bh)
+		raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
+	if (!raw_inode)
 		return -EIO;
-	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08llx]\n",
-				inode->i_sb->s_id, inode->i_ino);
-			err = -EIO;
-		}
+	err = mmb_sync(&minix_i(inode)->i_metadata_bhs);
+	if (err)
+		goto out;
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		printk("IO error syncing minix inode [%s:%08llx]\n",
+			inode->i_sb->s_id, inode->i_ino);
+		err = -EIO;
 	}
-	brelse (bh);
+out:
+	brelse(bh);
 	return err;
 }
 
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 9e52d4302f0d..78722ce22e1e 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -59,7 +59,6 @@ int minix_getattr(struct mnt_idmap *, const struct path *,
 		struct kstat *, u32, unsigned int);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
 struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
-int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 extern void V1_minix_truncate(struct inode *);
 extern void V2_minix_truncate(struct inode *);
-- 
2.51.0

