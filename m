Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898AA3C2799
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519054; cv=none; b=DKzWIzOF1qNnbXTGMZhSUziRiaSNJD5BCCFUBduxkQaSxR2YTglKKW508lbxQWvqUBh2xlEs6nrarFHBt1IGVhT6yim0bImSbK1ihxZ36Yfo4wEB+qW1xf4L2cV5hs8GpMktBPze9iXQSXBMeE68h9BugXnM8Q3mvgOfxKxCkYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519054; c=relaxed/simple;
	bh=1/HAIWZ4CPXkxgREibL9KxrIfyMEMVaSpeFYw9kCkjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9oivO+9x80jtyVOefnlAqeu3ATOlH7oAigipZAhozafEYIjMmleZ6GqHyFIXKKraWBZRoX3Jl0pcZr18C0o4dsEdHnkfxtdSKi9WhoUo1EhR/i+1cG9SZsiNoXLKmnZHHYw252yniU0iCeeImFB6mBIlRsbI5jbFPbJ1Olxdh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ym8EyKYQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=niRlKN0f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vOYRJZHt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RNydFC3v; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ym8EyKYQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="niRlKN0f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vOYRJZHt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RNydFC3v"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 97B3A4D2A0;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3zzZkJM5jiIJmPKU2A5e2C97vLxrneM7mTx6PGkvas=;
	b=ym8EyKYQzRH/PPglfiIQCqNB9hm8ZDADveg2i6rWhB2kQab5C9zR4Pi+lJDADKz0YbqlPJ
	PobesgUDPdxluVqAAG71aHgU7/DZ3OGy7R1cVkIJa/WyyUD2SEx+kktVvhpA07Jkc4TThJ
	R+ht7zP+c3GHe6r3/0otyjdPugu3J8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518902;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3zzZkJM5jiIJmPKU2A5e2C97vLxrneM7mTx6PGkvas=;
	b=niRlKN0fVftGtb32/h/IdUZSNF5sYO/jiYn4XpvgxF/Qmh8dEeVfoisb1YE8/3ldvu3jFo
	2+wtXPNpzzGELqBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vOYRJZHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RNydFC3v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3zzZkJM5jiIJmPKU2A5e2C97vLxrneM7mTx6PGkvas=;
	b=vOYRJZHtR0pZnc5AmI4SvhzynPdi2hO7l6T7PnJ4FVRB7BZ59Ec6NeaQNgBl1II0IHXiGd
	t9EdHz3srdHPJgVACJihXqa0dSjJV7cQo+L60Pxd5MI38LgnLu0wF36/xXgizoGTiHX2kv
	VttcX1CzO9AMYdYbNVhJ0z3U4RHuPHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3zzZkJM5jiIJmPKU2A5e2C97vLxrneM7mTx6PGkvas=;
	b=RNydFC3vzk5UxsrHFUvLFsKsAnHgH0qxCMK2hnfw2mKs655Ct5396pIu1Er1ASAYMa1Vyv
	DHtp79tWJ0ACmbAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88F0D4A0B2;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5MF9IXUCxWn4YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CE813A0C7D; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 38/42] udf: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:32 +0100
Message-ID: <20260326095354.16340-80-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7265; i=jack@suse.cz; h=from:subject; bh=1/HAIWZ4CPXkxgREibL9KxrIfyMEMVaSpeFYw9kCkjM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJSlK1hThLj/TLfS3LZgr/CFyx+K+PqQ1KSB zXdI5yy2QqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUgAKCRCcnaoHP2RA 2W6aB/9w4HzjUPcT5XjsNto4p54guHKDkPic4BzYh8Nv42IzL4/ujA64iJKf+Pf85sS8FCo9Oyv r2OLQG25mKkb9hXOUecFY0Gc5MEj+Sa1veodMjWGp3eoAajbNEhSwjMpCPF86UGMA1lMvdj5SOK laIJPK7Q6j10XAa6/26f8FER5AevCL4oQjm78Cgrlp0a0SNBbMxgbHZIhMx1o+T1R8GjhxqX2Lq RPXEGYOPMNEuSi5VcmizG/PwALYsdyVyxzjEEz4mnx0RfUlXym9kA5NpKkUKFn/rdgknWfSc88K Yt/ZFJz/+sbTsFxgJv7HG3IlElC8c6MWxVz5QMyOQwacZ9jv
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 97B3A4D2A0
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c       |  2 +-
 fs/udf/directory.c |  5 +++--
 fs/udf/file.c      |  9 ++++++++-
 fs/udf/inode.c     | 16 ++++++++--------
 fs/udf/namei.c     |  2 +-
 fs/udf/super.c     |  1 +
 fs/udf/truncate.c  |  2 +-
 fs/udf/udf_i.h     |  1 +
 fs/udf/udfdecl.h   |  1 +
 9 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index a1705aedac46..ebc9f6a379fe 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= generic_buffers_fsync,
+	.fsync			= udf_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 632453aa3893..83edd04ca6fa 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -430,9 +430,10 @@ void udf_fiiter_write_fi(struct udf_fileident_iter *iter, uint8_t *impuse)
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(iter->dir);
 	} else {
-		mark_buffer_dirty_inode(iter->bh[0], iter->dir);
+		mmb_mark_buffer_dirty(iter->bh[0], &iinfo->i_metadata_bhs);
 		if (iter->bh[1])
-			mark_buffer_dirty_inode(iter->bh[1], iter->dir);
+			mmb_mark_buffer_dirty(iter->bh[1],
+					      &iinfo->i_metadata_bhs);
 	}
 	inode_inc_iversion(iter->dir);
 }
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 627b07320d06..e8c57c6ee8b8 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -198,6 +198,13 @@ static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+int udf_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return mmb_fsync(file,
+			&UDF_I(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 const struct file_operations udf_file_operations = {
 	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
@@ -205,7 +212,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= generic_buffers_fsync,
+	.fsync			= udf_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 739b190ca4e9..656eb031b4c0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -155,8 +155,8 @@ void udf_evict_inode(struct inode *inode)
 	}
 	truncate_inode_pages_final(&inode->i_data);
 	if (!want_delete)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync(&iinfo->i_metadata_bhs);
+	mmb_invalidate(&iinfo->i_metadata_bhs);
 	clear_inode(inode);
 	kfree(iinfo->i_data);
 	iinfo->i_data = NULL;
@@ -1263,7 +1263,7 @@ struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
 		memset(bh->b_data, 0x00, inode->i_sb->s_blocksize);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &UDF_I(inode)->i_metadata_bhs);
 		return bh;
 	}
 
@@ -2011,7 +2011,7 @@ int udf_setup_indirect_aext(struct inode *inode, udf_pblk_t block,
 	memset(bh->b_data, 0x00, sb->s_blocksize);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &UDF_I(inode)->i_metadata_bhs);
 
 	aed = (struct allocExtDesc *)(bh->b_data);
 	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT)) {
@@ -2106,7 +2106,7 @@ int __udf_add_aext(struct inode *inode, struct extent_position *epos,
 		else
 			udf_update_tag(epos->bh->b_data,
 					sizeof(struct allocExtDesc));
-		mark_buffer_dirty_inode(epos->bh, inode);
+		mmb_mark_buffer_dirty(epos->bh, &iinfo->i_metadata_bhs);
 	}
 
 	return 0;
@@ -2190,7 +2190,7 @@ void udf_write_aext(struct inode *inode, struct extent_position *epos,
 				       le32_to_cpu(aed->lengthAllocDescs) +
 				       sizeof(struct allocExtDesc));
 		}
-		mark_buffer_dirty_inode(epos->bh, inode);
+		mmb_mark_buffer_dirty(epos->bh, &iinfo->i_metadata_bhs);
 	} else {
 		mark_inode_dirty(inode);
 	}
@@ -2398,7 +2398,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 			else
 				udf_update_tag(oepos.bh->b_data,
 						sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(oepos.bh, inode);
+			mmb_mark_buffer_dirty(oepos.bh, &iinfo->i_metadata_bhs);
 		}
 	} else {
 		udf_write_aext(inode, &oepos, &eloc, elen, 1);
@@ -2415,7 +2415,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 			else
 				udf_update_tag(oepos.bh->b_data,
 						sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(oepos.bh, inode);
+			mmb_mark_buffer_dirty(oepos.bh, &iinfo->i_metadata_bhs);
 		}
 	}
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 5f2e9a892bff..4ef2ff014170 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -638,7 +638,7 @@ static int udf_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		memset(epos.bh->b_data, 0x00, bsize);
 		set_buffer_uptodate(epos.bh);
 		unlock_buffer(epos.bh);
-		mark_buffer_dirty_inode(epos.bh, inode);
+		mmb_mark_buffer_dirty(epos.bh, &iinfo->i_metadata_bhs);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
 	} else
 		ea = iinfo->i_data + iinfo->i_lenEAttr;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 27f463fd1d89..e02775007c46 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -166,6 +166,7 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
 	inode_set_iversion(&ei->vfs_inode, 1);
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index b4071c9cf8c9..41b2bfd30449 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -186,7 +186,7 @@ static void udf_update_alloc_ext_desc(struct inode *inode,
 		len += lenalloc;
 
 	udf_update_tag(epos->bh->b_data, len);
-	mark_buffer_dirty_inode(epos->bh, inode);
+	mmb_mark_buffer_dirty(epos->bh, &UDF_I(inode)->i_metadata_bhs);
 }
 
 /*
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 312b7c9ef10e..fdaa88c49c2b 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -50,6 +50,7 @@ struct udf_inode_info {
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;
 	struct rw_semaphore	i_data_sem;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct udf_ext_cache cached_extent;
 	/* Spinlock for protecting extent cache */
 	spinlock_t i_extent_cache_lock;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index d159f20d61e8..6d951e05c004 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -137,6 +137,7 @@ static inline unsigned int udf_dir_entry_len(struct fileIdentDesc *cfi)
 
 /* file.c */
 extern long udf_ioctl(struct file *, unsigned int, unsigned long);
+int udf_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* inode.c */
 extern struct inode *__udf_iget(struct super_block *, struct kernel_lb_addr *,
-- 
2.51.0

