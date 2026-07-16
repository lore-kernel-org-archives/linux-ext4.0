Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2941F5CB
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213818; cv=none; b=HmGJr4UQZyu6J+XjBO3tzZbgf8eav1HfYqcbuv/ynFLFLhMv+HAgwdV6GV8Oe78ZCnl8xvwx9gbM727ilIe06hyw04sllUWSN/jUBsSPqkfj8PIcOB0aP2419LuLMrNZ3/RBxb/aAxGSt7IGaElPFYWsx8vviYeQIDDQHOutb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213818; c=relaxed/simple;
	bh=g+ClMAqpSvV8ev1zul5gRzxLKEgba2TXsCAJrluSt1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKObeMob3I6YyiFwssh16jh2frdgafQ3ZSns0iPiSHDYeFpan0F5V4A6lKIopUP/LtgeEctHi/ai5mCwB2FZJFMakWm9sE3jf9eZfOfvX3msHmkFyGO/0+B1olMBDngwdORowf4RbSvgfs0FRjRQtJtRmTro/XFsLCGKI+8RhOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NtZ2m6F0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yKI25KK4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NtZ2m6F0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yKI25KK4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NtZ2m6F0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yKI25KK4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NtZ2m6F0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yKI25KK4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C06EA3E48;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14BILaeK2ZkZ8eXD9N8idz07vgNBfSjgCgNJakKDnj8=;
	b=NtZ2m6F0glCGitmw+SiV1Cqtq512kVQOuPHD+EB5bZlKzSByLjvtKGF04SMk0/JtYpESdZ
	EvE/snYtHuUmVs/n38kVqsHaxtgT/9LOxpj2QsKcuAacfmtISTwNyK4uQXpP3o6pHHQC2B
	0qCvB9gnrW0XnWs22v7yeyQP8owtJ0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14BILaeK2ZkZ8eXD9N8idz07vgNBfSjgCgNJakKDnj8=;
	b=yKI25KK4YR2x3kJMPIcdQL3f1O3YzTtezUvNlupG109i+YWlDw7bNVnK+SVZBnontQ8W5d
	BDlzeaZDSvknhWAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14BILaeK2ZkZ8eXD9N8idz07vgNBfSjgCgNJakKDnj8=;
	b=NtZ2m6F0glCGitmw+SiV1Cqtq512kVQOuPHD+EB5bZlKzSByLjvtKGF04SMk0/JtYpESdZ
	EvE/snYtHuUmVs/n38kVqsHaxtgT/9LOxpj2QsKcuAacfmtISTwNyK4uQXpP3o6pHHQC2B
	0qCvB9gnrW0XnWs22v7yeyQP8owtJ0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14BILaeK2ZkZ8eXD9N8idz07vgNBfSjgCgNJakKDnj8=;
	b=yKI25KK4YR2x3kJMPIcdQL3f1O3YzTtezUvNlupG109i+YWlDw7bNVnK+SVZBnontQ8W5d
	BDlzeaZDSvknhWAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4C37779AD;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PgbzKwXxWGoPXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A41C2A12D7; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 16/21] minix: Fix data integrity writeout issues
Date: Thu, 16 Jul 2026 16:55:38 +0200
Message-ID: <20260716145527.3580300-37-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5937; i=jack@suse.cz; h=from:subject; bh=g+ClMAqpSvV8ev1zul5gRzxLKEgba2TXsCAJrluSt1M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDsVW34AmWKBzcJ20H0gN4iWv2sc404THxk1 zuQutT1qrOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw7AAKCRCcnaoHP2RA 2Ym6CACeKxMbJMcztO/RQRxPo7xJ7P+L+RK8zBuXjVVKZotjruq35iVcjxycYQDnvP8oT765Uc5 VFV5wIpexUfHkPZDyh1l3evIQ6Ml8aT/3w73LwzBVx0MoQE27l/ay5WCoKoBi4TwTZQRP5A17Qx fneC8nuKJWFIJSfTYc6RToV7XVa119RMrD8/Zo7dR6QoE4kBNffodH2isfavK4rxzgFg7VK20sZ REqIwT4xGgjn3gIImVhYWcqLeWojUEOy8+8LWB/X1XTDiIbD5BBxeqDo1VQ8OpL/ex+sC4xp9It WPB1OdOkJJrw/KwjrYtH4+iy5R62+YIDeQRr78B6qgrpNk4F
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

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
 3 files changed, 37 insertions(+), 26 deletions(-)

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
 
-- 
2.51.0

