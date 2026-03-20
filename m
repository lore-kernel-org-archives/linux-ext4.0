Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988743BD64C
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014239; cv=none; b=k2W7JQCzPsUhK3dx4SgMu40FndO5SiF0pOW9Zmn+BF22YhMocmHEdwvgMtIE/oH97l4Q/FzINb2mTlAPM5uF3N4fAGXr/5zpyO03m9tLv6453HVOER73cF93BmbiDNI7IsC7F7srovVTGewm8AFkYwAklG6JCDKVDrv254x4qNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014239; c=relaxed/simple;
	bh=DJy04KzOTAHLt2Q8A41znoZw5jiuyyUoHyU/z/FMsN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8uG2+D7U20Q2BnGSlMx07kubpx/kZW4ffvgChYNazn6bKObjdFa/XHe5ZkAT3eocmOo0Bv/xsdgknO61CO4Lzslo8sEprd+mHbhhEVuMJv0opAsuAdCVikefsYDOJtENaiJoHr+m0lSUnM9fFo3sq16Sf0MgleCLyiNlfGcTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K7atea3O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x9kAHBeg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K7atea3O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x9kAHBeg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K7atea3O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x9kAHBeg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K7atea3O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x9kAHBeg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0B054D42B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15AyEt562Yj8xfCrU9lYdId+wQwRrF0p1KOr9Q3MCPA=;
	b=K7atea3O7rueqnmBBlRaANpaBogGZ9dEV19ncL9UpYCtUUMZ6/I/JjNhWABbymbmaMSrVk
	u6/rkYn+kDLQNqH2+z4+5Bajgh23BSDk0eSe3RzWFbWAvZBDhzOw+NpA9vUH2GlO6lt7MH
	8Lg6unjaAdLmBaLOE5YYXc/tQ03tHK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15AyEt562Yj8xfCrU9lYdId+wQwRrF0p1KOr9Q3MCPA=;
	b=x9kAHBeg31q7XIC87LXA2jkpWSEgr1GHsO1C36gZm3/f8EyN/EH4fwoYPU/d80yDzPXM6+
	XX8hvtTD/ZLSkcAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15AyEt562Yj8xfCrU9lYdId+wQwRrF0p1KOr9Q3MCPA=;
	b=K7atea3O7rueqnmBBlRaANpaBogGZ9dEV19ncL9UpYCtUUMZ6/I/JjNhWABbymbmaMSrVk
	u6/rkYn+kDLQNqH2+z4+5Bajgh23BSDk0eSe3RzWFbWAvZBDhzOw+NpA9vUH2GlO6lt7MH
	8Lg6unjaAdLmBaLOE5YYXc/tQ03tHK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15AyEt562Yj8xfCrU9lYdId+wQwRrF0p1KOr9Q3MCPA=;
	b=x9kAHBeg31q7XIC87LXA2jkpWSEgr1GHsO1C36gZm3/f8EyN/EH4fwoYPU/d80yDzPXM6+
	XX8hvtTD/ZLSkcAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C366242819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IQjGL5lOvWmXCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A00CA0B2E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 36/41] udf: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:31 +0100
Message-ID: <20260320134100.20731-77-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7289; i=jack@suse.cz; h=from:subject; bh=DJy04KzOTAHLt2Q8A41znoZw5jiuyyUoHyU/z/FMsN8=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+nU/OhbXI6Mw+5OJbs+LK70e29uPbM43CHmhbZV0X UHGP+JkJ6MxCwMjB4OsmCLL6siL2tfmGXVtDdWQgRnEygQyhYGLUwAm4h3EwTB5B8cHN5t0C8OC My6bHczO7rlz5cCrIpb1DOayz9cvDOtjaNDbqSNdtUhcpUxtzdoPc/ctmD5vcqDCuYanyxyK5h/ JCyycdqZBwEz37NGtOrp3c4wK+eVVCqx2eSgYaM1L+NrVwrfvVsI/jfJwK980sedn9SIykq7aLC uMUg3XFLDkXLSpNNmt2n2i3Jdkg5Mf12eJNXcFhjkflPnyS3G9nqzUq4Y514+ItfNI9/k8OL9y4 x+97hTTlymFxU37Us7nC8xtNM5N/PC+Yt5+92f7bNM3lRpk9zyTWr4rUGGRu+6JKuZ0pmf2z07N PjdPJ1AuKy+OY7oS691zJ1wPJm9k/fWVuaj2RQ+3V74CAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

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
index 627b07320d06..bce3667fa2d4 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -198,6 +198,13 @@ static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+int udf_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return generic_mmb_fsync(file,
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
index 739b190ca4e9..6b6b0116cf90 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -155,8 +155,8 @@ void udf_evict_inode(struct inode *inode)
 	}
 	truncate_inode_pages_final(&inode->i_data);
 	if (!want_delete)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync_buffers(&iinfo->i_metadata_bhs);
+	mmb_invalidate_buffers(&iinfo->i_metadata_bhs);
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

