Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938603BB9F0
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014204; cv=none; b=dYlR2wnYHtedYwv2dDn6EkVXTaOJsF/oIAuSBSYsUcIMTVr0vLfDpty8h2+gV6UPEsfqlFobnRJne4YP+k6ScNyaM/M8c8weyYEHlIpm0D60a+rrzt60eDkttyxFPPqToYj2CCOvet01vs+20OKErT3DmgeKSSkyP+FbKllZbKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014204; c=relaxed/simple;
	bh=xBY2Mm+/VMqLFvDbzz3/FawAAeTJnZRG1KDfb/3GiL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gISU7UldSVDH8xcRb1t5dCDoHta8nJZsyGye7CtS9rO0t11QYYQpPuppRjd/EOGtECsIwli+RR4P+C9f7yU18ut43P4EFja06CuTy6SKV63Yb8zGKFdTbfEJ3Dkmwj2REnU3qbBYVC2kT59lRXd8bEszTbfzXihDgZrxzT1CwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B637E5BEE9;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A962F42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id btRaKZlOvWmQCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 72C3DA0A81; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 33/41] affs: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:28 +0100
Message-ID: <20260320134100.20731-74-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10976; i=jack@suse.cz; h=from:subject; bh=xBY2Mm+/VMqLFvDbzz3/FawAAeTJnZRG1KDfb/3GiL8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6IyXvlF8UM49m12fr6Fpn7sL83gLmOU4cRl WPD5VuywE+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OiAAKCRCcnaoHP2RA 2eSwB/9BMh8YOe9XdDgzdBJI4fqGP3y8GNqIld4OdGQdkLQOCRK3vOqWx5qERnpAGupq5UXVrvy HV+MTm2lWFqKOQBl/e3JfL6ZCyCUeulB63kzcBUzVZpQQSaM9CrVY/S/QXpiJyeyz672uDnwK+n yIfNhYAbUXPgKF9hwIurSZU/rEt0p4+OdnqrhEW3dXm/O7JCBEdAec26GC1syEI9OyJjpCd10lR CFTLAzJuibdVPq1EArmIAnt6xxmPmOYblvwiR4YbWzxmIVnsPInpefsiVflF04OGm//PN5I9/rh OG0p3z0oC/s/hOhpXDeOCYFe6Wv2Nje6OO1/ukLghFigF/Qn
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: B637E5BEE9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h     |  2 ++
 fs/affs/amigaffs.c | 12 ++++++------
 fs/affs/file.c     | 25 ++++++++++++++-----------
 fs/affs/inode.c    | 14 +++++++-------
 fs/affs/namei.c    |  9 +++++----
 fs/affs/super.c    |  1 +
 6 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index ac4e9a02910b..a1eb400e1018 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -44,6 +44,7 @@ struct affs_inode_info {
 	struct mutex i_link_lock;		/* Protects internal inode access. */
 	struct mutex i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
+	struct mapping_metadata_bhs i_metadata_bhs;
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -151,6 +152,7 @@ extern bool	affs_nofilenametruncate(const struct dentry *dentry);
 extern int	affs_check_name(const unsigned char *name, int len,
 				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
+struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode);
 
 /* bitmap. c */
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index fd669daa4e7b..13a914c1d8b7 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -57,7 +57,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 		AFFS_TAIL(sb, dir_bh)->hash_chain = cpu_to_be32(ino);
 
 	affs_adjust_checksum(dir_bh, ino);
-	mark_buffer_dirty_inode(dir_bh, dir);
+	mmb_mark_buffer_dirty(dir_bh, &AFFS_I(dir)->i_metadata_bhs);
 	affs_brelse(dir_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -100,7 +100,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 			else
 				AFFS_TAIL(sb, bh)->hash_chain = ino;
 			affs_adjust_checksum(bh, be32_to_cpu(ino) - hash_ino);
-			mark_buffer_dirty_inode(bh, dir);
+			mmb_mark_buffer_dirty(bh, &AFFS_I(dir)->i_metadata_bhs);
 			AFFS_TAIL(sb, rem_bh)->parent = 0;
 			retval = 0;
 			break;
@@ -180,7 +180,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mark_buffer_dirty_inode(link_bh, inode);
+		mmb_mark_buffer_dirty(link_bh, &AFFS_I(inode)->i_metadata_bhs);
 
 		memcpy(AFFS_TAIL(sb, bh)->name, AFFS_TAIL(sb, link_bh)->name, 32);
 		retval = affs_insert_hash(dir, bh);
@@ -188,7 +188,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 		affs_unlock_dir(dir);
 		iput(dir);
@@ -203,7 +203,7 @@ affs_remove_link(struct dentry *dentry)
 			__be32 ino2 = AFFS_TAIL(sb, link_bh)->link_chain;
 			AFFS_TAIL(sb, bh)->link_chain = ino2;
 			affs_adjust_checksum(bh, be32_to_cpu(ino2) - link_ino);
-			mark_buffer_dirty_inode(bh, inode);
+			mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 			retval = 0;
 			/* Fix the link count, if bh is a normal header block without links */
 			switch (be32_to_cpu(AFFS_TAIL(sb, bh)->stype)) {
@@ -306,7 +306,7 @@ affs_remove_header(struct dentry *dentry)
 	retval = affs_remove_hash(dir, bh);
 	if (retval)
 		goto done_unlock;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	affs_unlock_dir(dir);
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6c9258359ddb..606630d6f5f7 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -140,14 +140,14 @@ affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext)
 	AFFS_TAIL(sb, new_bh)->parent = cpu_to_be32(inode->i_ino);
 	affs_fix_checksum(sb, new_bh);
 
-	mark_buffer_dirty_inode(new_bh, inode);
+	mmb_mark_buffer_dirty(new_bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	tmp = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 	if (tmp)
 		affs_warning(sb, "alloc_ext", "previous extension set (%x)", tmp);
 	AFFS_TAIL(sb, bh)->extension = cpu_to_be32(blocknr);
 	affs_adjust_checksum(bh, blocknr - tmp);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	AFFS_I(inode)->i_extcnt++;
 	mark_inode_dirty(inode);
@@ -581,7 +581,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
 		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		size += tmp;
 		bidx++;
 	} else if (bidx) {
@@ -603,7 +603,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_fix_checksum(sb, bh);
 		bh->b_state &= ~(1UL << BH_New);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		if (prev_bh) {
 			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 
@@ -613,7 +613,8 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-			mark_buffer_dirty_inode(prev_bh, inode);
+			mmb_mark_buffer_dirty(prev_bh,
+					      &AFFS_I(inode)->i_metadata_bhs);
 			affs_brelse(prev_bh);
 		}
 		size += bsize;
@@ -732,7 +733,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
 			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -765,12 +766,13 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mark_buffer_dirty_inode(prev_bh, inode);
+				mmb_mark_buffer_dirty(prev_bh,
+					&AFFS_I(inode)->i_metadata_bhs);
 			}
 		}
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += bsize;
 		from += bsize;
 		bidx++;
@@ -799,13 +801,14 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mark_buffer_dirty_inode(prev_bh, inode);
+				mmb_mark_buffer_dirty(prev_bh,
+						&AFFS_I(inode)->i_metadata_bhs);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -942,7 +945,7 @@ affs_truncate(struct inode *inode)
 	}
 	AFFS_TAIL(sb, ext_bh)->extension = 0;
 	affs_fix_checksum(sb, ext_bh);
-	mark_buffer_dirty_inode(ext_bh, inode);
+	mmb_mark_buffer_dirty(ext_bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(ext_bh);
 
 	if (inode->i_size) {
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 84afa862f220..e62c5a79efd6 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -206,7 +206,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	affs_fix_checksum(sb, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 	affs_free_prealloc(inode);
 	return 0;
@@ -268,10 +268,10 @@ affs_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		affs_truncate(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync_buffers(&AFFS_I(inode)->i_metadata_bhs);
 	}
 
-	invalidate_inode_buffers(inode);
+	mmb_invalidate_buffers(&AFFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
@@ -306,7 +306,7 @@ affs_new_inode(struct inode *dir)
 	bh = affs_getzeroblk(sb, block);
 	if (!bh)
 		goto err_bh;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 
 	inode->i_uid     = current_fsuid();
@@ -394,17 +394,17 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		AFFS_TAIL(sb, bh)->link_chain = chain;
 		AFFS_TAIL(sb, inode_bh)->link_chain = cpu_to_be32(block);
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
-		mark_buffer_dirty_inode(inode_bh, inode);
+		mmb_mark_buffer_dirty(inode_bh, &AFFS_I(inode)->i_metadata_bhs);
 		set_nlink(inode, 2);
 		ihold(inode);
 	}
 	affs_fix_checksum(sb, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	dentry->d_fsdata = (void *)(long)bh->b_blocknr;
 
 	affs_lock_dir(dir);
 	retval = affs_insert_hash(dir, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_unlock_dir(dir);
 	affs_unlock_link(inode);
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index f883be50db12..23d00d85cf21 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -373,7 +373,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	*p = 0;
 	inode->i_size = i + 1;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
 
@@ -443,7 +443,8 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/* TODO: move it back to old_dir, if error? */
 
 done:
-	mark_buffer_dirty_inode(bh, retval ? old_dir : new_dir);
+	mmb_mark_buffer_dirty(bh,
+			&AFFS_I(retval ? old_dir : new_dir)->i_metadata_bhs);
 	affs_brelse(bh);
 	return retval;
 }
@@ -496,8 +497,8 @@ affs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = affs_insert_hash(old_dir, bh_new);
 	affs_unlock_dir(old_dir);
 done:
-	mark_buffer_dirty_inode(bh_old, new_dir);
-	mark_buffer_dirty_inode(bh_new, old_dir);
+	mmb_mark_buffer_dirty(bh_old, &AFFS_I(new_dir)->i_metadata_bhs);
+	mmb_mark_buffer_dirty(bh_new, &AFFS_I(old_dir)->i_metadata_bhs);
 	affs_brelse(bh_old);
 	affs_brelse(bh_new);
 	return retval;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8451647f3fea..079f36e1ddec 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -108,6 +108,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
+	mmb_init(&i->i_metadata_bhs, &i->vfs_inode.i_data);
 
 	return &i->vfs_inode;
 }
-- 
2.51.0

