Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E4437997E
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501659; cv=none; b=r68zLPrhe6OxpOoxsHxyVc+05KyAgPAZEtJ4yW/XVQxrL3E8DqhUX1DtHRCqYNcmXSMI//M0RbaJQ4bo8d1TqLAilgjv2XcZ3t0D8Xa8qdB//D/nJhFTXl1YrB8cY52b/0nC/KrmQaROzWMwkYVrnd7WYxDuPVawqgxNqfE4b/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501659; c=relaxed/simple;
	bh=CW5qgLg2xeU7DpYzpWSL2tPRZZYuetyQO7XKNfUL1R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxWa4RoY1rQHsVWviuHXONjmMwMaSUSUFIlDwnLLT13WwxkfAEwbkBChyflCdPgxyWTJ6eXej9vtmAW+JJyT04gerCKbD5S8L/ktVE/fV2pC8pPoI0ZtqZwdqe3QMuzCWr554C0eYoW63s+Bkfj/dO12Waw/U/EoFCXQ9OJYciE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tARKajdo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=abZOR4eh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pfn+NSiz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=W6ME8mjy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tARKajdo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="abZOR4eh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pfn+NSiz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="W6ME8mjy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EABC65C857;
	Mon, 11 May 2026 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyoLD5JlR1FunCKl7IKc6XsE1wJvmQCeJzuyWj8TBwo=;
	b=tARKajdoCpaH2OjEacWVc1WMaQCy7lIGiGer/deZ8paJOrJztvPXkih1cM/sCM28kA5DrC
	8kZkGDq3Of3yWBcgMD24oxeut+BD7jfZEM7wOk/kXp2F9rbsRn4VzIoFyeaq0kDaBdg+zH
	A4ubilzdx+rVijdGhJUwIWlPM8I7/L0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyoLD5JlR1FunCKl7IKc6XsE1wJvmQCeJzuyWj8TBwo=;
	b=abZOR4ehSQK7iGy+6uGwMspt9+1zjSlbpV+qEfs6MbglvhLP56MlgN2Ao5xxgAiCoFJGOs
	636BkVd6DxnbrZBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyoLD5JlR1FunCKl7IKc6XsE1wJvmQCeJzuyWj8TBwo=;
	b=pfn+NSizXXo1LcYCZC9/Qr+Pg/jimWKmM6gRF6TLXIOFajiYMnIZWz4x6Ci8zKl5YMCSPh
	xZokeyh50HT+a2hd7QZBaQzPrmEXkS50mwRrVRlkU8OAkkTyHbfTj2F9zUA+F4Eyf9ldqf
	lb10qoCr222o1coD/ifuFdIEPRuk7XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyoLD5JlR1FunCKl7IKc6XsE1wJvmQCeJzuyWj8TBwo=;
	b=W6ME8mjyAXHRmd+94y0+1nlW/DIJxtia1hDLgrsEPnofZveUZH5PAk08NPeGfPROGJBN1C
	ri1MF+6xIL65G1CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D81E5593A9;
	Mon, 11 May 2026 12:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KQfCNBLIAWrJWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6EF80A0791; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 1/9] affs: Drop support for metadata bh tracking
Date: Mon, 11 May 2026 14:13:51 +0200
Message-ID: <20260511121356.241821-10-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10556; i=jack@suse.cz; h=from:subject; bh=CW5qgLg2xeU7DpYzpWSL2tPRZZYuetyQO7XKNfUL1R8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgEsbsjqx5KjsaIbk3DLuhx/mWVNalSqFxiW ruBHMbPn/eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHIBAAKCRCcnaoHP2RA 2SVjCAC0o8bGGWMQriIJIzjWsOUahTfE5/qaXCNZfT4rS9QNxjYKmyuLDVAeeKEbjDXUUzxkY6u kKWQLtaIIYwNw1dBqsGWQqy1clC513hdc6Jd/n86w4BH1fzycnUCIpiIvLuoAwA26VSIZRoT1cc f3kAiz1Lp+4CGc83cUCKPX5jMJfZyUzpy8EE4Ah2ZHee74l1IkNCF0Y3HyFDosGjxrmqcHTxDC4 aQrcAaUmrMV32DigLQKczzsGfAf5xK6J5My2zK2kBWgxedGVZxndp9jygckxd2MmiaVWsjex2e+ if5MT0d3qKpirktSa664wGyXz6PapPGaJsVzUHMPOCHVRyx+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

AFFS did all the hard work of tracking metadata bhs dirtied for an inode
but it actually never used this information as affs_file_fsync() just
calls sync_blockdev() to writeback all filesystem metadata bhs. After a
discussion with AFFS maintainer nobody cares about AFFS performance
so let's keep this affs_file_fsync() behavior and just drop all the
pointless tracking from AFFS.

CC: David Sterba <dsterba@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h     |  1 -
 fs/affs/amigaffs.c | 12 ++++++------
 fs/affs/file.c     | 25 +++++++++++--------------
 fs/affs/inode.c    | 13 +++++--------
 fs/affs/namei.c    |  9 ++++-----
 fs/affs/super.c    |  1 -
 6 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index a0caf6ace860..406a0ef63e7b 100644
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
index 079f36e1ddec..8451647f3fea 100644
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

