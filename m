Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640753195EF
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213767; cv=none; b=SCY15mT5Xgm8HBee9pOXvHOi6JJQNvvZIWnTXIFz9RcijuSpcVBNABNcUiwy8WKk9FqPs4Obo2Lm7zQpuTq/KiYelmn62lWj2BP7iiCkA6JwUv6XCCGgEINcoc2Peg1Avq5zVsGSD/CBlXPpaSJhXM5pIJKY6EAzTMx+A0y4t0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213767; c=relaxed/simple;
	bh=+ZKbN4NqjhaM+0lCSrPLsOilVhhoRSuqkjArQtLqXYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBbvJ45yDHOWZUz8bmklJ6BpBMet01OffL4uY8TNkldKNZCpn4UXuNEusQqUlisUqaPuGnDgqmJuanMf8BflDwzPZYhfwCbC/ERg6EMjDlclH5gRdZt5e1sqsQiSr/V0Xqsy+W9LvDwui5ktsaERc2LbqjEAoKF0eUDZGQipU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8BDB3E3A;
	Thu, 16 Jul 2026 14:55:56 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5653779AE;
	Thu, 16 Jul 2026 14:55:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /iowMPzwWGreXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 585FBA002E; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH v4 01/21] affs: Drop support for metadata bh tracking
Date: Thu, 16 Jul 2026 16:55:23 +0200
Message-ID: <20260716145527.3580300-22-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10948; i=jack@suse.cz; h=from:subject; bh=+ZKbN4NqjhaM+0lCSrPLsOilVhhoRSuqkjArQtLqXYU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDglZeBm8aehxz8hcTrsSVeDIR7KrlJb+OIz 8UciNsG6DyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw4AAKCRCcnaoHP2RA 2XhGB/9TvNnz4K+l1L7PJzdBMT/c9/J/UFVk9t+kYFPCkQ6b65WxnAscuEyESzCspx1pbY0WCWD hs9puPMX4G62lLgFUcjRUCeNU9X9nJu+DR5YwjYR+D4LaU4E7HS08PmADsM0aQFY0/B5vrPLDo7 wX947qnDQegA4hod1oPd5mW0bHF+0JWk2XZl2NlBsUZxiHoGTVT9g/iyKxGsKAnR62FtqAeSB/Q uTVAyFMYt0kFHG/Hw3wdPEsTd9XFncjdba9Cllak8mt+mYz1GfsThpo6fkZ6ms9rJP+NIUG/xJ5 bcBNnDwtcv1f0K3sb6+0sQzNlmgyeVAYdH9RfwiMyoZdt1/N
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: D8BDB3E3A
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

AFFS did all the hard work of tracking metadata bhs dirtied for an inode
but it actually never used this information as affs_file_fsync() just
calls sync_blockdev() to writeback all filesystem metadata bhs. After a
discussion with AFFS maintainer nobody cares about AFFS performance
so let's keep this affs_file_fsync() behavior and just drop all the
pointless tracking from AFFS.

CC: David Sterba <dsterba@suse.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h     |  2 --
 fs/affs/amigaffs.c | 12 ++++++------
 fs/affs/file.c     | 25 +++++++++++--------------
 fs/affs/inode.c    | 13 +++++--------
 fs/affs/namei.c    |  9 ++++-----
 fs/affs/super.c    |  1 -
 6 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 44a3f69d275f..a7faa91deed5 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -44,7 +44,6 @@ struct affs_inode_info {
 	struct mutex i_link_lock;		/* Protects internal inode access. */
 	struct mutex i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
-	struct mapping_metadata_bhs i_metadata_bhs;
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -152,7 +151,6 @@ extern bool	affs_nofilenametruncate(const struct dentry *dentry);
 extern int	affs_check_name(const unsigned char *name, int len,
 				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
-struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode);
 
 /* bitmap. c */
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index bed4fc805e8e..6cc0fc9a4cbf 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -57,7 +57,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 		AFFS_TAIL(sb, dir_bh)->hash_chain = cpu_to_be32(ino);
 
 	affs_adjust_checksum(dir_bh, ino);
-	mmb_mark_buffer_dirty(dir_bh, &AFFS_I(dir)->i_metadata_bhs);
+	mark_buffer_dirty(dir_bh);
 	affs_brelse(dir_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -100,7 +100,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 			else
 				AFFS_TAIL(sb, bh)->hash_chain = ino;
 			affs_adjust_checksum(bh, be32_to_cpu(ino) - hash_ino);
-			mmb_mark_buffer_dirty(bh, &AFFS_I(dir)->i_metadata_bhs);
+			mark_buffer_dirty(bh);
 			AFFS_TAIL(sb, rem_bh)->parent = 0;
 			retval = 0;
 			break;
@@ -180,7 +180,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mmb_mark_buffer_dirty(link_bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(link_bh);
 
 		memcpy(AFFS_TAIL(sb, bh)->name, AFFS_TAIL(sb, link_bh)->name, 32);
 		retval = affs_insert_hash(dir, bh);
@@ -188,7 +188,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 
 		affs_unlock_dir(dir);
 		iput(dir);
@@ -203,7 +203,7 @@ affs_remove_link(struct dentry *dentry)
 			__be32 ino2 = AFFS_TAIL(sb, link_bh)->link_chain;
 			AFFS_TAIL(sb, bh)->link_chain = ino2;
 			affs_adjust_checksum(bh, be32_to_cpu(ino2) - link_ino);
-			mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+			mark_buffer_dirty(bh);
 			retval = 0;
 			/* Fix the link count, if bh is a normal header block without links */
 			switch (be32_to_cpu(AFFS_TAIL(sb, bh)->stype)) {
@@ -306,7 +306,7 @@ affs_remove_header(struct dentry *dentry)
 	retval = affs_remove_hash(dir, bh);
 	if (retval)
 		goto done_unlock;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 
 	affs_unlock_dir(dir);
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 144b17482d12..23e088a7ed4f 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -140,14 +140,14 @@ affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext)
 	AFFS_TAIL(sb, new_bh)->parent = cpu_to_be32(inode->i_ino);
 	affs_fix_checksum(sb, new_bh);
 
-	mmb_mark_buffer_dirty(new_bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(new_bh);
 
 	tmp = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 	if (tmp)
 		affs_warning(sb, "alloc_ext", "previous extension set (%x)", tmp);
 	AFFS_TAIL(sb, bh)->extension = cpu_to_be32(blocknr);
 	affs_adjust_checksum(bh, blocknr - tmp);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 
 	AFFS_I(inode)->i_extcnt++;
 	mark_inode_dirty(inode);
@@ -581,7 +581,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
 		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		size += tmp;
 		bidx++;
 	} else if (bidx) {
@@ -603,7 +603,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_fix_checksum(sb, bh);
 		bh->b_state &= ~(1UL << BH_New);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		if (prev_bh) {
 			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 
@@ -613,8 +613,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-			mmb_mark_buffer_dirty(prev_bh,
-					      &AFFS_I(inode)->i_metadata_bhs);
+			mark_buffer_dirty(prev_bh);
 			affs_brelse(prev_bh);
 		}
 		size += bsize;
@@ -733,7 +732,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
 			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -766,13 +765,12 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mmb_mark_buffer_dirty(prev_bh,
-					&AFFS_I(inode)->i_metadata_bhs);
+				mark_buffer_dirty(prev_bh);
 			}
 		}
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += bsize;
 		from += bsize;
 		bidx++;
@@ -801,14 +799,13 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mmb_mark_buffer_dirty(prev_bh,
-						&AFFS_I(inode)->i_metadata_bhs);
+				mark_buffer_dirty(prev_bh);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -945,7 +942,7 @@ affs_truncate(struct inode *inode)
 	}
 	AFFS_TAIL(sb, ext_bh)->extension = 0;
 	affs_fix_checksum(sb, ext_bh);
-	mmb_mark_buffer_dirty(ext_bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(ext_bh);
 	affs_brelse(ext_bh);
 
 	if (inode->i_size) {
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 5dd1b016bcb0..d4a3f381c4bc 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -206,7 +206,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	affs_fix_checksum(sb, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	affs_free_prealloc(inode);
 	return 0;
@@ -266,11 +266,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
-	} else {
-		mmb_sync(&AFFS_I(inode)->i_metadata_bhs);
 	}
 
-	mmb_invalidate(&AFFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
@@ -305,7 +302,7 @@ affs_new_inode(struct inode *dir)
 	bh = affs_getzeroblk(sb, block);
 	if (!bh)
 		goto err_bh;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 
 	inode->i_uid     = current_fsuid();
@@ -393,17 +390,17 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		AFFS_TAIL(sb, bh)->link_chain = chain;
 		AFFS_TAIL(sb, inode_bh)->link_chain = cpu_to_be32(block);
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
-		mmb_mark_buffer_dirty(inode_bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(inode_bh);
 		set_nlink(inode, 2);
 		ihold(inode);
 	}
 	affs_fix_checksum(sb, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	dentry->d_fsdata = (void *)(long)bh->b_blocknr;
 
 	affs_lock_dir(dir);
 	retval = affs_insert_hash(dir, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_unlock_dir(dir);
 	affs_unlock_link(inode);
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index c3c6532da4b0..57d8d755aada 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -373,7 +373,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	*p = 0;
 	inode->i_size = i + 1;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
 
@@ -443,8 +443,7 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/* TODO: move it back to old_dir, if error? */
 
 done:
-	mmb_mark_buffer_dirty(bh,
-			&AFFS_I(retval ? old_dir : new_dir)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	return retval;
 }
@@ -497,8 +496,8 @@ affs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = affs_insert_hash(old_dir, bh_new);
 	affs_unlock_dir(old_dir);
 done:
-	mmb_mark_buffer_dirty(bh_old, &AFFS_I(new_dir)->i_metadata_bhs);
-	mmb_mark_buffer_dirty(bh_new, &AFFS_I(old_dir)->i_metadata_bhs);
+	mark_buffer_dirty(bh_old);
+	mark_buffer_dirty(bh_new);
 	affs_brelse(bh_old);
 	affs_brelse(bh_new);
 	return retval;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index b232251aa7bb..0ad5127e9fb8 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -108,7 +108,6 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
-	mmb_init(&i->i_metadata_bhs, &i->vfs_inode.i_data);
 
 	return &i->vfs_inode;
 }
-- 
2.51.0

