Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0BE3CBE93
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519048; cv=none; b=GuE8CY8hG3hdB+hFgcndvvzlVmqmIFjt4xwIsM7mbhciucuyyGLTO0hmSvggW/F3R2pTaCuGrBsn4Q7L7dWDRLe+ah0xZeoL2lVk4ZBT09ExxfxFsB686xZNMOXhVvjSmlsgV4KPTN9BjyosCfD9xuUx2kYGHz1ROwRwuPT15qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519048; c=relaxed/simple;
	bh=mPftk52N1tg292K+pLT6SWPCyjD9IykdNuzqZIbq9lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYzdsS9E2fGSj81H/bbRwFS6Qsdg9ak5LtVYF2AMZnDmSSbKuyqaKgt7bS9Rl6+kLiz2bgXm+jCb/ZWjnTdnARnHRbjKqYtSQ4n/hJnKZaUyI2Jw42qm8IVxhak/F/Q8QRfe3gpj5jS5tr3wZAjYygwOt2PHxZkW8sBVlEIF5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xzizY0qG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UzPDswGv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xzizY0qG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UzPDswGv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xzizY0qG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UzPDswGv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xzizY0qG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UzPDswGv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FEBD5BDC3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=xzizY0qGA2xxKwN/TTLRR8OgCKBqK+Hp8GoaoQcBFeaiMnndw7xrgGdyFcP1KoAMmIqKOx
	r7IFZPvnpN2bnctp0k1VY0mFbEWntnKdmcryA9H2/fUjzXAAru2KQDcOcO7/exuBAz4YAN
	afitD1Mb+apNMLK4m3AdMt3kG4pMk1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=UzPDswGv2QfHuXmQrwaIInfQoACYdtIzrOOFcS/Zll+eMuKWiFKcLgEJx9JDHlQUij+gBS
	dIMyE9fXpcWoYHDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=xzizY0qGA2xxKwN/TTLRR8OgCKBqK+Hp8GoaoQcBFeaiMnndw7xrgGdyFcP1KoAMmIqKOx
	r7IFZPvnpN2bnctp0k1VY0mFbEWntnKdmcryA9H2/fUjzXAAru2KQDcOcO7/exuBAz4YAN
	afitD1Mb+apNMLK4m3AdMt3kG4pMk1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=UzPDswGv2QfHuXmQrwaIInfQoACYdtIzrOOFcS/Zll+eMuKWiFKcLgEJx9JDHlQUij+gBS
	dIMyE9fXpcWoYHDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95EC44A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jwWZJHUCxWn/YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BD29FA0C7B; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 36/42] bfs: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:30 +0100
Message-ID: <20260326095354.16340-78-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3085; i=jack@suse.cz; h=from:subject; bh=mPftk52N1tg292K+pLT6SWPCyjD9IykdNuzqZIbq9lo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJRqNkHhgR7SXPvvfjYuN1uPILl7w2KvOz5A a9V2nOJOwCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUQAKCRCcnaoHP2RA 2ZhsB/9Ha9Xe4849znz4uZzqx+mAXqZLSVcVROsaSUM4SXsJX1uua3AmlshbsIRJILX75Lp1tCA 4hMK0sKdBawvmqpADO7cUNnkZwSAYzRuZ7DjqZOcePaAAsJh5/qqXaoIuL72quw9cv4QhXOzzHC XSxPTnrWFcSEMZxIIgpOjb6mSWXqCNyjPWTcQJqZ2AxU+P++baZaIe8+aqBkSSrHhY/yk6y1Hhm V9I1hEQE4K20ljtEUQOgM5E8hd/qSS4pgGIlmmaprD6MAh99NG3l8ka7RbizkWrlAP9l18TRjVL QqXNoNo8uWPZtO3iakLMWxKCnQR68mdwC7mrl56FS0Y/AdW4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/bfs.h   |  1 +
 fs/bfs/dir.c   | 16 ++++++++++++----
 fs/bfs/inode.c |  6 ++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 606f9378b2f0..b08afe733e63 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -35,6 +35,7 @@ struct bfs_inode_info {
 	unsigned long i_dsk_ino; /* inode number from the disk, can be 0 */
 	unsigned long i_sblock;
 	unsigned long i_eblock;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 1b140981dbf3..2848401e2bf1 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -68,10 +68,17 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	return 0;
 }
 
+static int bfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return mmb_fsync(file,
+			&BFS_I(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= bfs_fsync,
 	.llseek		= generic_file_llseek,
 };
 
@@ -186,7 +193,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		set_nlink(inode, 1);
 	}
 	de->ino = 0;
-	mark_buffer_dirty_inode(bh, dir);
+	mmb_mark_buffer_dirty(bh, &BFS_I(dir)->i_metadata_bhs);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	mark_inode_dirty(dir);
 	inode_set_ctime_to_ts(inode, inode_get_ctime(dir));
@@ -246,7 +253,7 @@ static int bfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		inode_set_ctime_current(new_inode);
 		inode_dec_link_count(new_inode);
 	}
-	mark_buffer_dirty_inode(old_bh, old_dir);
+	mmb_mark_buffer_dirty(old_bh, &BFS_I(old_dir)->i_metadata_bhs);
 	error = 0;
 
 end_rename:
@@ -296,7 +303,8 @@ static int bfs_add_entry(struct inode *dir, const struct qstr *child, int ino)
 				for (i = 0; i < BFS_NAMELEN; i++)
 					de->name[i] =
 						(i < namelen) ? name[i] : 0;
-				mark_buffer_dirty_inode(bh, dir);
+				mmb_mark_buffer_dirty(bh,
+						&BFS_I(dir)->i_metadata_bhs);
 				brelse(bh);
 				return 0;
 			}
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e0e50a9dbe9c..19e49c8cf750 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -188,8 +188,8 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_nlink)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync(&BFS_I(inode)->i_metadata_bhs);
+	mmb_invalidate(&BFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	if (inode->i_nlink)
@@ -259,6 +259,8 @@ static struct inode *bfs_alloc_inode(struct super_block *sb)
 	bi = alloc_inode_sb(sb, bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
+	mmb_init(&bi->i_metadata_bhs, &bi->vfs_inode.i_data);
+
 	return &bi->vfs_inode;
 }
 
-- 
2.51.0

