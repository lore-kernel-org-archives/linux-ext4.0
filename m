Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCD83F9298
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149445; cv=none; b=mTs9GBtH3MrMFx0XCR0b08tJZ1sxi4IrRDYtV46ZWDCxIrN7Oo0EXM1I94W+SHR9qh/+wMCgfmeZAy5H+JHJH7DXaKXBuCakHcKUNP5akfzahnzlbpqjzGpOGKZBlRJVolfuZ/fj9ShHjfsz3epKJPncRxEfRAHfH+Wx7KolkAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149445; c=relaxed/simple;
	bh=OYAIolUWwWeJ3/Ihc9z98HYqiLH7iPhlr4uYU0uFBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls9uRQ49AvA3oiGONCSCpBGA/b0pOhIqDKq4+6VP3Qo0X6SrO3jhgpXZOz+ywxzGe7xtMcmokimrtzkBYIOfJbaDezlHk4aGCyRcEEXHryHjH+Ai8+sBPkwSeFTP4+yK3w7ddX9L1mEAghobfoUUQmy1EdIgzU1WkA5GguVEZ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SC6duY2K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8Ro9G+fg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v6Y8AfXp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KFAUZNAK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SC6duY2K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8Ro9G+fg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v6Y8AfXp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KFAUZNAK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2DC58523B;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MY79L33RsokdVvKXSkcNs8diXQdnkxkDSiBO0mc3FpM=;
	b=SC6duY2K8xZM6l+Fgb+ecNCRe28FI7a/Kj3BhzOuejSLA7aSUoRr87idl1LCk97u0Jw7Rp
	HU92j2TW1GfBnwZ4bTG1C/wPT9h0CLCyWROUPYQ7XzsK9C2NFt7ryxdqqC/62Nt80/mRSk
	nf7p5TtV1Q9FtZKPWthK2UkGXPqow/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MY79L33RsokdVvKXSkcNs8diXQdnkxkDSiBO0mc3FpM=;
	b=8Ro9G+fg9gFp7gtdrVmn6efMr/2vFgx8cBqHNrJEvRrmW/weaFkuk+ANVCzl5j7E4MPYr8
	KeaJkYAIUzl6vrDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MY79L33RsokdVvKXSkcNs8diXQdnkxkDSiBO0mc3FpM=;
	b=v6Y8AfXp+h3Cj6ZMjhZDvCRKQR7P0jum+NiDwBxJ034/pEJ8mc1mWgk0Dt4Hy/M/C9F26K
	orwA2/1fBBNOOnZeq2L2fWhgXFa+tcxSaWoHnbgmNe6pibrSRruzeJAJJrjaUYKlgg8PTt
	UyG/OSdcTtQpL/K68jpznn/ZIkN2nNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MY79L33RsokdVvKXSkcNs8diXQdnkxkDSiBO0mc3FpM=;
	b=KFAUZNAKayG9GLsGUJNxLBGGbmi0A57DXRvD5OppSzf4VNhItt0a3H6ekjCzkAeXf3WZS/
	hjgxs/LrzQbVp7Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E6D2779D2;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id If07D8w3Z2obawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5B53EA132D; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 10/20] udf: Fix data integrity writeout issues
Date: Mon, 27 Jul 2026 12:49:28 +0200
Message-ID: <20260727104923.3828017-30-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5657; i=jack@suse.cz; h=from:subject; bh=OYAIolUWwWeJ3/Ihc9z98HYqiLH7iPhlr4uYU0uFBFw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze71j6cQH2FCl6ebsHuOsmmWZyUdlGLukilJ nr2gw9btSeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3uwAKCRCcnaoHP2RA 2bTmB/96Kr4vzpLtm/SOffdXM9MdgY9ipRWCjWydqrIXccmchRQ93HhQ9Z9oHBkqi97P414DEk2 kwckAu1UkwX5Gkwqn3vwq745wHmyp/6qlIY5zhfXbaQeHNDyKHC3MTD0KVg2b1luiaQxc/9rLa+ CrgRCGc9AhiACF3V16xtvog0yMnHUTQSYJfBfzkmL/wlYBzpEw214DwBMh8JLAZg0+kzZ0cJfoK RRB+vd3LGG97jr7MH4rEZ1bTC18dwv/sE0WDG6NJAcpEc2+PE2J4ruH4+qWWYK1bZ5pCD1NokJH +/xTpm1oPp89YutfoWxOO5bIY1lk581dVBRcp8yMuhYAubVi
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

UDF could fail to properly write out inode on fsync(2) due to races
with WB_SYNC_NONE writeback. Several racing fsyncs could also result in
some fsync returning earlier than all metadata buffers were properly
persisted.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c     |  2 +-
 fs/udf/file.c    |  9 +--------
 fs/udf/inode.c   | 40 +++++++++++++++++++++++++++++-----------
 fs/udf/super.c   |  1 +
 fs/udf/udfdecl.h |  2 +-
 5 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index ebc9f6a379fe..425e3c162935 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= udf_fsync,
+	.fsync			= simple_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index f7f1422de30f..0748cc965117 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -198,13 +198,6 @@ static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-int udf_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	return mmb_fsync(file,
-			&UDF_I(file->f_mapping->host)->i_metadata_bhs,
-			start, end, datasync);
-}
-
 const struct file_operations udf_file_operations = {
 	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
@@ -212,7 +205,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= udf_fsync,
+	.fsync			= simple_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 67bcf83758c8..05e61a65478c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -142,7 +142,9 @@ void udf_evict_inode(struct inode *inode)
 		if (!inode->i_nlink) {
 			want_delete = 1;
 			udf_setsize(inode, 0);
-			udf_update_inode(inode, IS_SYNC(inode));
+			udf_update_inode(inode, 0);
+			if (IS_SYNC(inode))
+				udf_sync_inode_metadata(inode, NULL);
 		}
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 		    inode->i_size != iinfo->i_lenExtents) {
@@ -1710,6 +1712,30 @@ int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
+int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
+{
+	struct buffer_head *bh;
+	int err = 0;
+
+	bh = sb_getblk(inode->i_sb,
+			udf_get_lb_pblock(inode->i_sb,
+					  &UDF_I(inode)->i_location, 0));
+	if (!bh)
+		return -EIO;
+
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
+			 inode->i_ino);
+		err = -EIO;
+		goto out;
+	}
+	err = mmb_sync(&UDF_I(inode)->i_metadata_bhs);
+out:
+	brelse(bh);
+	return err;
+}
+
 static int udf_sync_inode(struct inode *inode)
 {
 	return udf_update_inode(inode, 1);
@@ -1732,7 +1758,6 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	uint32_t udfperms;
 	uint16_t icbflags;
 	uint16_t crclen;
-	int err = 0;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -1937,17 +1962,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
-	if (do_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_write_io_error(bh)) {
-			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
-				 inode->i_ino);
-			err = -EIO;
-		}
-	}
 	brelse(bh);
+	set_inode_metadata_writeback(inode);
 
-	return err;
+	return 0;
 }
 
 struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b85f5a2b79f..e7e9f2a0d24e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -211,6 +211,7 @@ static const struct super_operations udf_sb_ops = {
 	.alloc_inode	= udf_alloc_inode,
 	.free_inode	= udf_free_in_core_inode,
 	.write_inode	= udf_write_inode,
+	.sync_inode_metadata = udf_sync_inode_metadata,
 	.evict_inode	= udf_evict_inode,
 	.put_super	= udf_put_super,
 	.sync_fs	= udf_sync_fs,
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 6d951e05c004..86dc2d6a2ef1 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -137,7 +137,6 @@ static inline unsigned int udf_dir_entry_len(struct fileIdentDesc *cfi)
 
 /* file.c */
 extern long udf_ioctl(struct file *, unsigned int, unsigned long);
-int udf_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* inode.c */
 extern struct inode *__udf_iget(struct super_block *, struct kernel_lb_addr *,
@@ -158,6 +157,7 @@ extern struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
 extern int udf_setsize(struct inode *, loff_t);
 extern void udf_evict_inode(struct inode *);
 extern int udf_write_inode(struct inode *, struct writeback_control *wbc);
+int udf_sync_inode_metadata(struct inode *, struct writeback_control *wbc);
 extern int inode_bmap(struct inode *inode, sector_t block,
 		      struct extent_position *pos, struct kernel_lb_addr *eloc,
 		      uint32_t *elen, sector_t *offset, int8_t *etype);
-- 
2.51.0

