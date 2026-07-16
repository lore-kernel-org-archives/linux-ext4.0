Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF09F2F6911
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213805; cv=none; b=hTMtZ9TJ/y9Dl5Y1Jk6QXodlTFkqfZ8z91A0UZ/HBLTYnQ9DmVaiQLvt8q7G9AAaI950274zH1s7M5MBCzE1mCLwZr9kFUnSZ3aoZi2GzHBXuAyVR99KjcJwq9JPsNylujWj7dHU29+pfw6T34tOgwNNnJ6olnJIWUC80Dr+2cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213805; c=relaxed/simple;
	bh=NqF1la8D7hrJAzD3RQP0Ct0lZbdH0iJY40ANxTUg4PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geQybr+8s5MO6Kmd9a+YsmRBbYUMgiQt+8oqEYllG8RpN+ZJAGnqWoEhUP/wGPYxGhDYruGOaoYEe5byXUmhfD1b07YoPBzSGMEdZv0zzfqw6kXSZ9j7qSJ/VGOqHu3aZB5doNOV0ZRNkGIouFroX8Uf7HtLsxrTy+rYWj6Sgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uGeJ2IFl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kAWp8SJ2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uGeJ2IFl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kAWp8SJ2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uGeJ2IFl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kAWp8SJ2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uGeJ2IFl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kAWp8SJ2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B03AC3E45;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wc+8W5Abwdyfu5rcDaMkRAYBN92DMwK2wt8v/bWQj3M=;
	b=uGeJ2IFljhiK69I+0lRuJyaM/p460FuVLKKta8mhozmPqV7y49s2vsfPRf7NCwV7DRgtiG
	w66MCeIN7aYadXM8dvbRgkbg0V7tqWKfrrd6pyliTvVurKWkdcqUASzC9D2J54LhOC44XW
	6aJZ2UjBr9bJKKTqjB13KKd04BjYygg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wc+8W5Abwdyfu5rcDaMkRAYBN92DMwK2wt8v/bWQj3M=;
	b=kAWp8SJ20JmKI1edZlMiSYZVKlV85me57kkoTHiJJktpESRpGhATM2UMa4Tkmzs0FZ9GKw
	on+pIbT1Vc43HjCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wc+8W5Abwdyfu5rcDaMkRAYBN92DMwK2wt8v/bWQj3M=;
	b=uGeJ2IFljhiK69I+0lRuJyaM/p460FuVLKKta8mhozmPqV7y49s2vsfPRf7NCwV7DRgtiG
	w66MCeIN7aYadXM8dvbRgkbg0V7tqWKfrrd6pyliTvVurKWkdcqUASzC9D2J54LhOC44XW
	6aJZ2UjBr9bJKKTqjB13KKd04BjYygg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wc+8W5Abwdyfu5rcDaMkRAYBN92DMwK2wt8v/bWQj3M=;
	b=kAWp8SJ20JmKI1edZlMiSYZVKlV85me57kkoTHiJJktpESRpGhATM2UMa4Tkmzs0FZ9GKw
	on+pIbT1Vc43HjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4C87779B0;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0C84KAXxWGoFXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B8C7CA130D; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 20/21] fat: Replace fat_sync_inode() with sync_inode_metadata()
Date: Thu, 16 Jul 2026 16:55:42 +0200
Message-ID: <20260716145527.3580300-41-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8301; i=jack@suse.cz; h=from:subject; bh=NqF1la8D7hrJAzD3RQP0Ct0lZbdH0iJY40ANxTUg4PQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDwZbZpT7o6T1Oq0LguqWL3RLqQXBf2EIcDa +tBADPuvUaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw8AAKCRCcnaoHP2RA 2V2DB/4seGqrOImULhJ/O/DrrFnlB3gqhrRUtPQU2K5wTVfCbtRz8t85vPwibjIcJQvkpMCaJq2 lDB0vbUK4KIHr84HEHquBoV5DcWNupyIGM16LAbAVOkmMFr1yVtkI5D2tuzKJVbfOmrYMtcNWup UGubLe12JO81ynelISw0ymcCnGkcn9Jf3YqEl+CuW4xgDAH1YUyrbvVhTbD9bkLbW7yDdKalWvA c5v/fwJHvs/vpOcDX/t8HhyU0kIAiWmBosAxs5wnuN7VpT38+biSokfIEDm7sB8FF9rfkh0OU+p 3wJOGV9japcHCwN008hLOHmJSXD+pnT9tIirQrfwBidbOusw
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
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

Use generic sync_inode_metadata() instead of fat_sync_inode() for
persisting inode metadata changes for DIRSYNC inodes. This slightly
simplifies code and also addresses a theoretical race where
fat_sync_inode() could return before all metadata buffers associated
with the inode were properly written out when racing with fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         |  5 ++---
 fs/fat/fat.h         |  1 -
 fs/fat/file.c        |  6 +++---
 fs/fat/inode.c       | 15 ---------------
 fs/fat/misc.c        |  7 ++++---
 fs/fat/namei_msdos.c | 33 ++++++++++++++++-----------------
 fs/fat/namei_vfat.c  | 19 ++++++++++---------
 7 files changed, 35 insertions(+), 51 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 60f16154224b..916f5c4cdcf3 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1102,10 +1102,9 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 
 	fat_truncate_time(dir, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	err = 0;
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		err = fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		err = sync_inode_metadata(dir, 1);
 
 	return err;
 }
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 99ed9228a677..dcb5ba757073 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -421,7 +421,6 @@ extern void fat_detach(struct inode *inode);
 extern struct inode *fat_iget(struct super_block *sb, loff_t i_pos);
 extern struct inode *fat_build_inode(struct super_block *sb,
 			struct msdos_dir_entry *de, loff_t i_pos);
-extern int fat_sync_inode(struct inode *inode);
 extern int fat_fill_super(struct super_block *sb, struct fs_context *fc,
 			  void (*setup)(struct super_block *));
 extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 8a7585c25207..1c835ca5f21a 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -331,15 +331,15 @@ static int fat_free(struct inode *inode, int skip)
 	}
 	MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
 	fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(inode);
 	if (wait) {
-		err = fat_sync_inode(inode);
+		err = sync_inode_metadata(inode, 1);
 		if (err) {
 			MSDOS_I(inode)->i_start = i_start;
 			MSDOS_I(inode)->i_logstart = i_logstart;
 			return err;
 		}
-	} else
-		mark_inode_dirty(inode);
+	}
 
 	/* Write a new EOF, and get the remaining cluster chain for freeing. */
 	if (skip) {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index f6f847ff1b1c..e3bb7b4713f2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -955,21 +955,6 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
-int fat_sync_inode(struct inode *inode)
-{
-	int err;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-	};
-
-	err = __fat_write_inode(inode);
-	if (err)
-		return err;
-	return fat_sync_inode_metadata(inode, &wbc);
-}
-
-EXPORT_SYMBOL_GPL(fat_sync_inode);
-
 static int fat_show_options(struct seq_file *m, struct dentry *root);
 static const struct super_operations fat_sops = {
 	.alloc_inode	= fat_alloc_inode,
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 3027ef53af21..be18f6b5819b 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -146,16 +146,17 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 	} else {
 		MSDOS_I(inode)->i_start = new_dclus;
 		MSDOS_I(inode)->i_logstart = new_dclus;
+		mark_inode_dirty(inode);
 		/*
 		 * Since generic_write_sync() synchronizes regular files later,
 		 * we sync here only directories.
 		 */
 		if (S_ISDIR(inode->i_mode) && IS_DIRSYNC(inode)) {
-			ret = fat_sync_inode(inode);
+			ret = sync_inode_metadata(inode, 1);
 			if (ret)
 				return ret;
-		} else
-			mark_inode_dirty(inode);
+		}
+
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
 		fat_fs_error_ratelimit(
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 55095c172f0a..868ef091048e 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -252,10 +252,9 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 		return err;
 
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		err = fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		err = sync_inode_metadata(dir, 1);
 
 	return err;
 }
@@ -473,21 +472,20 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 				MSDOS_I(old_inode)->i_attrs |= ATTR_HIDDEN;
 			else
 				MSDOS_I(old_inode)->i_attrs &= ~ATTR_HIDDEN;
+			mark_inode_dirty(old_inode);
 			if (IS_DIRSYNC(old_dir)) {
-				err = fat_sync_inode(old_inode);
+				err = sync_inode_metadata(old_inode, 1);
 				if (err) {
 					MSDOS_I(old_inode)->i_attrs = old_attrs;
 					goto out;
 				}
-			} else
-				mark_inode_dirty(old_inode);
+			}
 
 			inode_inc_iversion(old_dir);
 			fat_truncate_time(old_dir, NULL, FAT_UPDATE_CMTIME);
+			mark_inode_dirty(old_dir);
 			if (IS_DIRSYNC(old_dir))
-				err = fat_sync_inode(old_dir);
-			else
-				mark_inode_dirty(old_dir);
+				err = sync_inode_metadata(old_dir, 1);
 			goto out;
 		}
 	}
@@ -526,12 +524,12 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		if (!new_inode)
 			inc_nlink(new_dir);
 	}
+	mark_inode_dirty(old_inode);
 	if (IS_DIRSYNC(new_dir)) {
-		err = fat_sync_inode(old_inode);
+		err = sync_inode_metadata(old_inode, 1);
 		if (err)
 			goto error_dotdot;
-	} else
-		mark_inode_dirty(old_inode);
+	}
 
 
 	err = fat_remove_entries(old_dir, &old_sinfo);	/* and releases bh */
@@ -540,10 +538,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		goto error_dotdot;
 	inode_inc_iversion(old_dir);
 	fat_truncate_time(old_dir, &ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(old_dir);
 	if (IS_DIRSYNC(old_dir))
-		err = fat_sync_inode(old_dir);
-	else
-		mark_inode_dirty(old_dir);
+		err = sync_inode_metadata(old_dir, 1);
 
 	if (new_inode) {
 		drop_nlink(new_inode);
@@ -571,8 +568,10 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	MSDOS_I(old_inode)->i_attrs = old_attrs;
 	if (new_inode) {
 		fat_attach(new_inode, new_i_pos);
-		if (corrupt)
-			corrupt |= fat_sync_inode(new_inode);
+		if (corrupt) {
+			mark_inode_dirty(new_inode);
+			corrupt |= sync_inode_metadata(new_inode, 1);
+		}
 	} else {
 		/*
 		 * If new entry was not sharing the data cluster, it
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e7b7d7c887fa..308158895b1d 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -678,10 +678,9 @@ static int vfat_add_entry(struct inode *dir, const struct qstr *qname,
 
 	/* update timestamp */
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		err = fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		err = sync_inode_metadata(dir, 1);
 cleanup:
 	kfree(slots);
 	return err;
@@ -904,9 +903,9 @@ static int vfat_get_dotdot_de(struct inode *inode, struct buffer_head **bh,
 
 static int vfat_sync_ipos(struct inode *dir, struct inode *inode)
 {
-	if (IS_DIRSYNC(dir))
-		return fat_sync_inode(inode);
 	mark_inode_dirty(inode);
+	if (IS_DIRSYNC(dir))
+		return sync_inode_metadata(inode, 1);
 	return 0;
 }
 
@@ -925,9 +924,9 @@ static int vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
 {
 	inode_inc_iversion(dir);
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
-	if (IS_DIRSYNC(dir))
-		return fat_sync_inode(dir);
 	mark_inode_dirty(dir);
+	if (IS_DIRSYNC(dir))
+		return sync_inode_metadata(dir, 1);
 	return 0;
 }
 
@@ -1024,8 +1023,10 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	fat_attach(old_inode, old_sinfo.i_pos);
 	if (new_inode) {
 		fat_attach(new_inode, new_i_pos);
-		if (corrupt)
-			corrupt |= fat_sync_inode(new_inode);
+		if (corrupt) {
+			mark_inode_dirty(new_inode);
+			corrupt |= sync_inode_metadata(new_inode, 1);
+		}
 	} else {
 		/*
 		 * If new entry was not sharing the data cluster, it
-- 
2.51.0

