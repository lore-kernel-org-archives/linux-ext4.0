Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E63FB05A
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149474; cv=none; b=FYAvVS9fnKN2Fbv8FUlr4q0qeVJIQleQ2xuC/pGDtseL0FDYdvUQgqmKWmVyxFqeUtZPdRqtioGST7tc0l5BkocMApEKS2JdmNYQBofE6BY1VW0bltj3ALLu2QinpeJTFXzXd4xN0/g5jqWglQ7fl8EcZutSZGWCPSI9zzJabJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149474; c=relaxed/simple;
	bh=4hvWljMIG/+A9zv17lyzc5+iC0zKMdGfDa04pV9NXXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iuu+t0/oijwSN445yU/jVyOaHSxlz+f4POhohQKlCy9kO95h7l2v8ml4C3Yj0suk8a6D7M356yI97h2Vxy2SSIQZOxasDFIY7HgkUmqC02iwvCtmrcl4Y69CASQl8W/XdyjZWob+kPVbNIZC5BQCsFSiSlS7UdjVNvldkfv4uVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dv6URNrK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hIeern33; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qmCdapgM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dx/qP/IZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dv6URNrK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hIeern33";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qmCdapgM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dx/qP/IZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 73D083F44;
	Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKxZ5JSqVjWlP8xB0vsGPfMaNsi0U/aZlwSysVRkelc=;
	b=dv6URNrK45DbFN9PTN1gs2fCAPWviT+igGbJmY4yyc2MzE8XKU+leUUxUelpbuLLtKfIpp
	O4TONWJjYyRbPAPLFkLMbx5+M+Sp0WHwSr38VSmgtBs4kZ4wbF9iRO6McHPEQYsQn5iP11
	HRdlKH+UlYjUxl1rnQNE7TuZBBkqtWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKxZ5JSqVjWlP8xB0vsGPfMaNsi0U/aZlwSysVRkelc=;
	b=hIeern33Pb8TJjlJmeYzWILbAXiSk4gBo2vwu9KKA+GUOP0Glczkkrhk0UvnOPLVL/wBEX
	3BcaqJe9H5YZmvAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKxZ5JSqVjWlP8xB0vsGPfMaNsi0U/aZlwSysVRkelc=;
	b=qmCdapgMCwTWAZ36XIo+gUj7kEHNzqwx2Nf0Y0BNELh397hr9wZrDOeQ/LvLV39mMWaT4/
	DW0Nxkic/4e/ipOj8DgFC0JptFAVv7DsMcdnpK8Gz+/BBzAY65JQkXdjcw0ffhgOvyc0CR
	8d0KiPho01zEw3jrbWEnQCQ5VHVMAzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKxZ5JSqVjWlP8xB0vsGPfMaNsi0U/aZlwSysVRkelc=;
	b=Dx/qP/IZNAoZ+Y0X+E9e8pYI0B/Y/yN2xP3llT3yEEvGHF7ReqBrxnKXhnXp42QoCM2mTJ
	EPzIsF+wzebOrUBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FEAE779E9;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1awsI8w3Z2ovawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 88977A133F; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 19/20] fat: Replace fat_sync_inode() with sync_inode_metadata()
Date: Mon, 27 Jul 2026 12:49:37 +0200
Message-ID: <20260727104923.3828017-39-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8230; i=jack@suse.cz; h=from:subject; bh=4hvWljMIG/+A9zv17lyzc5+iC0zKMdGfDa04pV9NXXo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzfCA6Jwu1gOpG5n/H0n/rQMPluVcmEB1tNhY lAdRq4qz0eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3wgAKCRCcnaoHP2RA 2ST+CADUjiO8Frs9fvupbI60Ny2b+qFHYqDZqud0ONyjyGywPazUAxZrT7GSvABrQH+cuko9k20 WoiyRPw+V2yyt460Lv+DQKnxJvLpUn3+2197Qhng/gTbhKz0yqitw+3G7pzgJKlG3Tma4k/G8z1 puqMhzC+IyZTTWMjbXB55aCfqNc6aT4MS93GS+T0iHzACc+OyAWynpDD7+xCDZzHWAYV70TltYS VPmA++jEgcyyElO5zr3eguHVIqF+2P7zkuccsauCuqQkGyC5PCaegYbFwRX3iEqKMuXwTSlWtn/ r+mZkaHLBX95X3aEaTO+QFCTFtXLTqmkPMhktDDx6YP/yvZu
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Use generic sync_inode_metadata() instead of fat_sync_inode() for
persisting inode metadata changes for DIRSYNC inodes. This slightly
simplifies code and also addresses a theoretical race where
fat_sync_inode() could return before all metadata buffers associated
with the inode were properly written out when racing with fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         |  6 +++---
 fs/fat/fat.h         |  1 -
 fs/fat/file.c        |  6 +++---
 fs/fat/inode.c       | 15 ---------------
 fs/fat/misc.c        |  7 ++++---
 fs/fat/namei_msdos.c | 29 ++++++++++++++---------------
 fs/fat/namei_vfat.c  | 20 ++++++++++----------
 7 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index c6cca5d00ffd..35bdb62944a2 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1109,10 +1109,10 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 	}
 
 	fat_truncate_time(dir, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
+	err = 0;
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		(void)sync_inode_metadata(dir, 1);
 
 	return 0;
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
index 0fd2971ad4b1..91b8d2fc9407 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -252,10 +252,9 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 		return err;
 
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		(void)sync_inode_metadata(dir, 1);
 
 	return 0;
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
-				(void)fat_sync_inode(old_dir);
-			else
-				mark_inode_dirty(old_dir);
+				(void)sync_inode_metadata(old_dir, 1);
 			goto out;
 		}
 	}
@@ -519,7 +517,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	else
 		MSDOS_I(old_inode)->i_attrs &= ~ATTR_HIDDEN;
 	if (IS_DIRSYNC(new_dir)) {
-		err = fat_sync_inode(old_inode);
+		err = sync_inode_metadata(old_inode, 1);
 		if (err)
 			goto error_inode;
 	} else
@@ -545,10 +543,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		goto error_dotdot;
 	inode_inc_iversion(old_dir);
 	fat_truncate_time(old_dir, &ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(old_dir);
 	if (IS_DIRSYNC(old_dir))
-		(void)fat_sync_inode(old_dir);
-	else
-		mark_inode_dirty(old_dir);
+		(void)sync_inode_metadata(old_dir, 1);
 
 	if (new_inode) {
 		drop_nlink(new_inode);
@@ -577,8 +574,10 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
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
index e909447873e3..0670c80305c6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -678,10 +678,9 @@ static int vfat_add_entry(struct inode *dir, const struct qstr *qname,
 
 	/* update timestamp */
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		(void)sync_inode_metadata(dir, 1);
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
 
@@ -925,10 +924,9 @@ static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
 {
 	inode_inc_iversion(dir);
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
+	mark_inode_dirty(dir);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		(void)sync_inode_metadata(dir, 1);
 }
 
 static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -1024,8 +1022,10 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
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

