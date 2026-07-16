Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F338236F
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213796; cv=none; b=Yt1Xu8rW8g0UVfSR19fTSYOIyn24zh+elejK040530wh2ksE6KebDVh+KSQCrEyP7WnqA7oi2kV2NHyWEYqDIfKmou63715tMvL4VUm3Dm270xygmkXed0dmR6L054E0jDtXyEZq8e4Zwme8xEXIKqH0zrykPVm55OBEAsA5wfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213796; c=relaxed/simple;
	bh=Pkpz16IvgAtXR5fxiDWJhnO9e5X0ON03Igzn5/lfZLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz1WDr0rk6qplDfKPKteliwBnLC0Xz7gHuumrqmX2kcB6dADOQuvzYnv5yduznYOP7XzhBnfTVomrWtjkiuEHT7e8PoQr65hPjSrQlQqOHN1NgqZiefZd/w2jQFc5lxOJKT91ce/hmkjfpY/ZIjZmHGmYNmZUxZsba6LB/AnEO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d4JRqJ/8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LenPnwhG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d4JRqJ/8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LenPnwhG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d4JRqJ/8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LenPnwhG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d4JRqJ/8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LenPnwhG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A05AD789D4;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lov3SElfIFXeUAQpj9xeBemI28jQCiPa2rAunX825JI=;
	b=d4JRqJ/8ApH9B72eCPyJie38P6aH6jeAxs02xyLFQ+MvBgFapUDhTy+RDzCAA1JbPx9ukD
	LRheHKoA3eK2w45sr0PJ5b9jivn/S4Bg7Zi/wb8qddxDee9d4XIXr0DNRprz5czHQwMb7L
	UABQ6Hf6dqFMI2qCwJwFmvBUZRsNLx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lov3SElfIFXeUAQpj9xeBemI28jQCiPa2rAunX825JI=;
	b=LenPnwhGwc495AoP0Mxk0eSNsmnCUGTq8iiKedKvoGTaPi92J5p2BPd/BsHHznpTug5DUV
	01bwK8MLVtA+rhAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lov3SElfIFXeUAQpj9xeBemI28jQCiPa2rAunX825JI=;
	b=d4JRqJ/8ApH9B72eCPyJie38P6aH6jeAxs02xyLFQ+MvBgFapUDhTy+RDzCAA1JbPx9ukD
	LRheHKoA3eK2w45sr0PJ5b9jivn/S4Bg7Zi/wb8qddxDee9d4XIXr0DNRprz5czHQwMb7L
	UABQ6Hf6dqFMI2qCwJwFmvBUZRsNLx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lov3SElfIFXeUAQpj9xeBemI28jQCiPa2rAunX825JI=;
	b=LenPnwhGwc495AoP0Mxk0eSNsmnCUGTq8iiKedKvoGTaPi92J5p2BPd/BsHHznpTug5DUV
	01bwK8MLVtA+rhAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9714D779AF;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1USAJAXxWGoBXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4163A12F7; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 19/21] fat: Remove some superfluous sync_dirty_buffer() calls
Date: Thu, 16 Jul 2026 16:55:41 +0200
Message-ID: <20260716145527.3580300-40-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6672; i=jack@suse.cz; h=from:subject; bh=Pkpz16IvgAtXR5fxiDWJhnO9e5X0ON03Igzn5/lfZLM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDvNVh7aIr5mZLK8NM6kY+MXY6SlNc5Zw/rz 1hl/sHLTP6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw7wAKCRCcnaoHP2RA 2SGKB/9BHJmtMol0Q+gBzPQCO0Gdgy0mPYrW4aiAXVMuy43XPOg4q3TIcUD1ahiB2tdlUkolqUD rv2WrbzwLQMh5f3ZlEIrfcBdIW2UVQUeXj9RelS3qYx02my2uzv+0JkPEp1m+YzRel9wWooRT+/ nJAAZdU1TvmXlMBecCv92Ij1rv7lsxk7Z4nDhxANXwBbJ3sxgk70lHBIV4QXUs5ngAru3bBGqOe VVXuhxAyNGeKVQxa82tdyDvZdkXDm2ei/fxggJYtpbXgzsbbV27RZHovdZYBz0pnJrIA7fOqvZn 7tOzWduUJ3WBhvh3ZBudxK39njd7IvN9tPq9zD+rd1/6RxFM
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Now that fat_sync_inode() ends up writing all metadata buffers
associated with the inode, it isn't necessary to write them out
explicitely using sync_dirty_buffer(). Remove the unnecessary calls. To
maintain proper detection of IO errors when writing buffers, make sure
errors from fat_sync_inode() get propagated to the callers.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         | 23 +++--------------------
 fs/fat/namei_msdos.c | 28 +++++++++++-----------------
 fs/fat/namei_vfat.c  | 21 ++++++++++++---------
 3 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index c6cca5d00ffd..60f16154224b 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1053,11 +1053,7 @@ static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 			nr_slots--;
 		}
 		mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
-		if (IS_DIRSYNC(dir))
-			err = sync_dirty_buffer(bh);
 		brelse(bh);
-		if (err)
-			break;
 
 		/* pos is *next* de's position, so this does `- sizeof(de)' */
 		pos += ((orig_slots - nr_slots) * sizeof(*de)) - sizeof(*de);
@@ -1088,11 +1084,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		nr_slots--;
 	}
 	mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
-	if (IS_DIRSYNC(dir))
-		err = sync_dirty_buffer(bh);
 	brelse(bh);
-	if (err)
-		return err;
 	inode_inc_iversion(dir);
 
 	if (nr_slots) {
@@ -1109,12 +1101,13 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 	}
 
 	fat_truncate_time(dir, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
+	err = 0;
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
+		err = fat_sync_inode(dir);
 	else
 		mark_inode_dirty(dir);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(fat_remove_entries);
 
@@ -1144,21 +1137,11 @@ static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
 		n++;
 		blknr++;
 		if (n == nr_bhs) {
-			if (IS_DIRSYNC(dir)) {
-				err = fat_sync_bhs(bhs, n);
-				if (err)
-					goto error;
-			}
 			for (i = 0; i < n; i++)
 				brelse(bhs[i]);
 			n = 0;
 		}
 	}
-	if (IS_DIRSYNC(dir)) {
-		err = fat_sync_bhs(bhs, n);
-		if (err)
-			goto error;
-	}
 	for (i = 0; i < n; i++)
 		brelse(bhs[i]);
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 0fd2971ad4b1..55095c172f0a 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -253,11 +253,11 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
+		err = fat_sync_inode(dir);
 	else
 		mark_inode_dirty(dir);
 
-	return 0;
+	return err;
 }
 
 /***** Create a file */
@@ -485,7 +485,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 			inode_inc_iversion(old_dir);
 			fat_truncate_time(old_dir, NULL, FAT_UPDATE_CMTIME);
 			if (IS_DIRSYNC(old_dir))
-				(void)fat_sync_inode(old_dir);
+				err = fat_sync_inode(old_dir);
 			else
 				mark_inode_dirty(old_dir);
 			goto out;
@@ -518,26 +518,21 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		MSDOS_I(old_inode)->i_attrs |= ATTR_HIDDEN;
 	else
 		MSDOS_I(old_inode)->i_attrs &= ~ATTR_HIDDEN;
-	if (IS_DIRSYNC(new_dir)) {
-		err = fat_sync_inode(old_inode);
-		if (err)
-			goto error_inode;
-	} else
-		mark_inode_dirty(old_inode);
-
 	if (update_dotdot) {
 		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
 		mmb_mark_buffer_dirty(dotdot_bh,
 				      &MSDOS_I(old_inode)->i_metadata_bhs);
-		if (IS_DIRSYNC(new_dir)) {
-			err = sync_dirty_buffer(dotdot_bh);
-			if (err)
-				goto error_dotdot;
-		}
 		drop_nlink(old_dir);
 		if (!new_inode)
 			inc_nlink(new_dir);
 	}
+	if (IS_DIRSYNC(new_dir)) {
+		err = fat_sync_inode(old_inode);
+		if (err)
+			goto error_dotdot;
+	} else
+		mark_inode_dirty(old_inode);
+
 
 	err = fat_remove_entries(old_dir, &old_sinfo);	/* and releases bh */
 	old_sinfo.bh = NULL;
@@ -546,7 +541,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	inode_inc_iversion(old_dir);
 	fat_truncate_time(old_dir, &ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(old_dir))
-		(void)fat_sync_inode(old_dir);
+		err = fat_sync_inode(old_dir);
 	else
 		mark_inode_dirty(old_dir);
 
@@ -571,7 +566,6 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
-error_inode:
 	fat_detach(old_inode);
 	fat_attach(old_inode, old_sinfo.i_pos);
 	MSDOS_I(old_inode)->i_attrs = old_attrs;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e909447873e3..e7b7d7c887fa 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -679,7 +679,7 @@ static int vfat_add_entry(struct inode *dir, const struct qstr *qname,
 	/* update timestamp */
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
+		err = fat_sync_inode(dir);
 	else
 		mark_inode_dirty(dir);
 cleanup:
@@ -921,14 +921,14 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 	return 0;
 }
 
-static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
+static int vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
 {
 	inode_inc_iversion(dir);
 	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
-		(void)fat_sync_inode(dir);
-	else
-		mark_inode_dirty(dir);
+		return fat_sync_inode(dir);
+	mark_inode_dirty(dir);
+	return 0;
 }
 
 static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -996,7 +996,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	vfat_update_dir_metadata(old_dir, &ts);
+	err = vfat_update_dir_metadata(old_dir, &ts);
 
 	if (new_inode) {
 		drop_nlink(new_inode);
@@ -1123,10 +1123,13 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
 			vfat_move_nlink(new_dir, old_dir);
 	}
 
-	vfat_update_dir_metadata(old_dir, &ts);
+	err = vfat_update_dir_metadata(old_dir, &ts);
 	/* if directories are not the same, update new_dir as well */
-	if (old_dir != new_dir)
-		vfat_update_dir_metadata(new_dir, &ts);
+	if (old_dir != new_dir) {
+		int err2 = vfat_update_dir_metadata(new_dir, &ts);
+		if (!err)
+			err = err2;
+	}
 
 out:
 	brelse(old_dotdot_bh);
-- 
2.51.0

