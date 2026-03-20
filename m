Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9203A5446
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014215; cv=none; b=WXyvdB2aL+FzlT5TkhuJXd1+/7iRXy2E7mEgH5B3+iN+ax77yeFnr3dnJmnluBC38WYToe47jCgIIDOb7X1FIF0dcR7GubVndCb0m3I79BeD3USskXo8H226WeLRZUlcpQbXDwYE6nHY6OwORMF1EM3barXv5lFLyIgxPn33yJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014215; c=relaxed/simple;
	bh=VGn/pIRcK5eqeKsls80+M3Fo5nsCbthSQy6MRfgwTJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTavHSUP+BJ0QeL9msIXW47xdX31Fe2la0n0VYvTOXstZTdzNS4BKrXJa3FgY6PVQahUe4ToOtZ88d1DMbDRiRVg6jyGaQccUMIoXXmra8+qllEKmuYSNMR1lsXbylEYBiNnId2Z0Cvq99wTb8TblSPoY6rSJjb6M7wWA2ot1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ATv3OKAS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ta9pKvWw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ATv3OKAS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ta9pKvWw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ATv3OKAS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ta9pKvWw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ATv3OKAS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ta9pKvWw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BDFE05BEEB;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=ATv3OKASBdjf3U3vWdPgZTIqL3LcgfgQct9p6SRk3HXoNzeT/C5fdMGz+BPLRUS0tqn2z4
	qsJ9NU7iQ/KBGLBTN8mVSBHGu+9JE+mhaoCh3PK8bsAksvbZxbLqVbp+EmvGIeTO/wOEQ7
	Dnp4bI84IvnYtvx/phLsVdie6gaR/Lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=Ta9pKvWwDUyDVYWN1RAuw/0strxWRgpZVe8N9pwCIM3JD4M2RrkZmOeio74Bc9EdNizSNA
	nRrDMMFjPsPV51Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=ATv3OKASBdjf3U3vWdPgZTIqL3LcgfgQct9p6SRk3HXoNzeT/C5fdMGz+BPLRUS0tqn2z4
	qsJ9NU7iQ/KBGLBTN8mVSBHGu+9JE+mhaoCh3PK8bsAksvbZxbLqVbp+EmvGIeTO/wOEQ7
	Dnp4bI84IvnYtvx/phLsVdie6gaR/Lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=Ta9pKvWwDUyDVYWN1RAuw/0strxWRgpZVe8N9pwCIM3JD4M2RrkZmOeio74Bc9EdNizSNA
	nRrDMMFjPsPV51Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B468842817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +zoJLJlOvWmSCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7AD97A0AFD; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 34/41] bfs: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:29 +0100
Message-ID: <20260320134100.20731-75-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3109; i=jack@suse.cz; h=from:subject; bh=VGn/pIRcK5eqeKsls80+M3Fo5nsCbthSQy6MRfgwTJE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6JkoTdFIeB5g6YyXAUMYBxuc0lm0vwR57wS 9b2iHYsY0uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OiQAKCRCcnaoHP2RA 2XhVCAC+YJifHwYZzLl6Oueau4kUtprTKTXcIWWXJushrDVu/nuZDc/4AETd6K4Z0O18UbR7bk6 FsPN6YSkCxd2ivtBVfR9hajkKNv25qeR8JDLdgYyL+hv5p/iFQfjKpZCiopmbCjXMP8qewnqqN1 oZiQVUEfmztaP7RdRwsLOeF/sP46FCRMPdlDo58NkES0loHaVoBhrDemn3NreeUgiBLPFmkkzyU C68I5VkKhwq3V1D4tKOoASV/nqGFP3k6GXF9+HACH4ZaF4ibWuxpQoGOIVPPg+DnzdDirzQCm16 fABzxAx06tQ3kU1y/raCptDEpbnODHcVOgkyOKEqdWDPWHXH
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

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
index 1b140981dbf3..1dbce745d1ad 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -68,10 +68,17 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	return 0;
 }
 
+static int bfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return generic_mmb_fsync(file,
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
index e0e50a9dbe9c..89f3da14e8c6 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -188,8 +188,8 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_nlink)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync_buffers(&BFS_I(inode)->i_metadata_bhs);
+	mmb_invalidate_buffers(&BFS_I(inode)->i_metadata_bhs);
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

