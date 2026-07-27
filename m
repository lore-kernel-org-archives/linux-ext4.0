Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1323F88A8
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149414; cv=none; b=hFYgfz69VEDlMQchebCaepaTU9gOrbDqyQGthoc8bidL53xaoFHj9+yRrGd//dOUT5heBFsIlxlbSkenO5B/D8xW+XDhQJu3plN8i+mXmi/+Tb7XoD1rQ3rhWEYWJzCWIlOQh/5ul+h+hsn0i3Sa9c5Jms9TPziRsQrs7j0FxZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149414; c=relaxed/simple;
	bh=rMK73+bdj/e95QlMiIb47ugwEYRc2LZ6je/fZq6ipFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/JDEZZF0FEQV2SrSB5clO3fC9esWXQh6LwtD4Nl6E+bdLcd8VZrHPF1+2WBGU7lwSist3XS5ppTp2vvcyRCNTlb9e5K5D5RunBZC4e4vfWZ4BglxGz7vpR1zNBmKGfoxm4mc1LU1caetEip16rEsMlezoXMpFAYUgN4IxBMV20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xGTGVRDx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iGW5F4Gr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GdrYmisb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G/IEefle; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xGTGVRDx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iGW5F4Gr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GdrYmisb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G/IEefle"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 229ED7DABD;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2A6QOPdfcUgXQlUY5tF43GJDI+oUQaTKVXuxDTBGBlk=;
	b=xGTGVRDx1a9yeCEBssdG27qtpdueDFpvXo4EuZs877j34XS4aR9RtzCl/l4zg7vIXYYuYI
	YkqYTDvGg9VmDhEkgNhyVXMrQc26Rac+49eV2cBmFSB3DE/paMQWZPWD0jpoko29A7hAL7
	Spf5bgwIbFSfkWv4nrITUVGbM9XMlQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2A6QOPdfcUgXQlUY5tF43GJDI+oUQaTKVXuxDTBGBlk=;
	b=iGW5F4Gri9HiuN0jMhqsBbIpy2qA2Y+/zzHJT/RIldhuNR8SnfGPLK+I0GM89GGq63Y9XG
	r/aDEzHwg5EtUlAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2A6QOPdfcUgXQlUY5tF43GJDI+oUQaTKVXuxDTBGBlk=;
	b=GdrYmisblhBnuMv3RJFaM5Z1ryMYJ8pZtFK/8QfE8I8r4TFtoXYs1E9CDm0hh7t+sDqffD
	txggK3UnxtWhQgULr/XViqk6+mm0tpnv4U8qCUndBTPpgD8pzDlHlQzCJ1dl0O3fUIHCvP
	Rmrn1jwGD5NWhbVVq3bq3A44RYFc66A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2A6QOPdfcUgXQlUY5tF43GJDI+oUQaTKVXuxDTBGBlk=;
	b=G/IEefleNZGUmsC7lZ0K+Wu7Kv+JD/FrLJR4c9YzFGJIsTujSSB2MeS5NCvzEs72DeyemT
	zyYhnShmlxml8zAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F95A779D1;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Tj6fC8w3Z2oYawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 55FD3A132C; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 09/20] ext2: Fix data integrity writeout issues
Date: Mon, 27 Jul 2026 12:49:27 +0200
Message-ID: <20260727104923.3828017-29-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5993; i=jack@suse.cz; h=from:subject; bh=rMK73+bdj/e95QlMiIb47ugwEYRc2LZ6je/fZq6ipFY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze6l3Ebn/rLURrCT+MEB6v4Jb5OIDAyWqYSD V+zglY5dBWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3ugAKCRCcnaoHP2RA 2UYOCADrsaw5lnCmp+bJTGc/GiaUm/D1lBDEjxlyT6VuYCK4GE0UyeMZ7djtkKlbiKkix1N0ror fegm+y9l7HQ+hSCb1fBQ7P/Z+gBjONZ02zJpKiVhkLK8t2TFPysQZOyfgEH6okw3PQJm77bjYTN cl0GdpgiB1SAJ5/nGXlnNYszI8g4rsbNgwRNoCOel2CO50l637D/AwML6k8SgUyS9QCiqRSb1oA 4Dl/T2kDAGpR5AtlEh2pysSMybJurpSZ4QjnA4QkOOkFaixod3HVbtTCTmcmRrzUmmO0ndRp6N1 KjxT7y5UcFhpfcJlQodxed2BtajGkQ91GhBp+dtuslW7atWN
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

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
 fs/ext2/inode.c | 48 ++++++++++++++++++++++++++++++------------------
 fs/ext2/super.c |  1 +
 5 files changed, 34 insertions(+), 37 deletions(-)

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
index 904e70f3140e..b5c958db9ecf 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -81,16 +81,11 @@ void ext2_evict_inode(struct inode * inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	if (want_delete) {
-		struct writeback_control wbc = {
-			.sync_mode = inode_needs_sync(inode) ? WB_SYNC_ALL :
-							       WB_SYNC_NONE,
-		};
-
 		sb_start_intwrite(inode->i_sb);
 		/* set dtime */
 		EXT2_I(inode)->i_dtime	= ktime_get_real_seconds();
 		mark_inode_dirty(inode);
-		ext2_write_inode(inode, &wbc);
+		sync_inode_metadata(inode, inode_needs_sync(inode));
 		/* truncate to 0 */
 		inode->i_size = 0;
 		if (inode->i_blocks)
@@ -1560,20 +1555,37 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
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
+	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
+	if (err) {
+		ext2_error(inode->i_sb, __func__,
+			"Error syncing inode metadata ino=%lu\n",
+			(unsigned long)inode->i_ino);
+		goto out;
+	}
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		ext2_error(inode->i_sb, __func__,
+			"IO error syncing inode %lu\n",
+			(unsigned long)inode->i_ino);
+		err = -EIO;
+	}
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

