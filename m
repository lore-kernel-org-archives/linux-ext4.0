Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5B43A5438
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016553; cv=none; b=PPxVa30mI9+Ge0LEYt+R/BXA2ws/63AYRoIv5u//nbLhxsUWvOWdmAc7THOUyvTah/c/c5LluBVnhY5sE7Azw3TmywSKGOFdW7jI0qcqa4BG3/nyNr4412Ezwdyc83uB4/ueKPWayWVc7llBsTPAHmWji2Jib04NaDdRRYCebDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016553; c=relaxed/simple;
	bh=3rUAGRBlH6pbOg5H+zr9aiNgqW2tNOpXc5J+3GzLS9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXYl9yTLZPwGpE2/nnXJVUK4vxenS8j5xNTWVHXUsboyo2lNP1A0Wr2g1fGe0VLBkm7Cm3HCH2h8WPQBedgU6QIoKTyWa7xumrzjuaHSYT7vkNS7Pp6PpHCe+pYLnAWfDrn8qWCvqOWg/xDlwGfB2DELy5Ta1kvXtC30OIPUzOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pEb8s7on; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DdmnaVOM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pEb8s7on; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DdmnaVOM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pEb8s7on";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DdmnaVOM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pEb8s7on";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DdmnaVOM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 927E9760ED;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOFT3GwU7tFpKUflZG9SVR8abv0ydCJBeLhHh89rT7k=;
	b=pEb8s7on10YtnpwItK8/Aa0vZpjohIRRfbfe4tOIeLubIxpdAJmtGDpLfhx4FDlSinl3C2
	f9d8BoiatVPf9zNfmLD+4qPh2OwU+cgUIALPBt5zwLW0D4N1Qnrg+5SwlDfnlCGmBk70G6
	rAhN4QdBDL7ZwnmNA4XdlnsRfGSPt9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOFT3GwU7tFpKUflZG9SVR8abv0ydCJBeLhHh89rT7k=;
	b=DdmnaVOMzlfxq0LpMlB8/Cfb+67tVup6COcylhqTf0lswZ/bB6M5Jgdgk4ReRljMqXr9zk
	nQ+7KqxKzzUDpWDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOFT3GwU7tFpKUflZG9SVR8abv0ydCJBeLhHh89rT7k=;
	b=pEb8s7on10YtnpwItK8/Aa0vZpjohIRRfbfe4tOIeLubIxpdAJmtGDpLfhx4FDlSinl3C2
	f9d8BoiatVPf9zNfmLD+4qPh2OwU+cgUIALPBt5zwLW0D4N1Qnrg+5SwlDfnlCGmBk70G6
	rAhN4QdBDL7ZwnmNA4XdlnsRfGSPt9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOFT3GwU7tFpKUflZG9SVR8abv0ydCJBeLhHh89rT7k=;
	b=DdmnaVOMzlfxq0LpMlB8/Cfb+67tVup6COcylhqTf0lswZ/bB6M5Jgdgk4ReRljMqXr9zk
	nQ+7KqxKzzUDpWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7358C779AC;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yRjEGyGsRmoUGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5DF14A12AD; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 17/19] fat: Remove some superfluous sync_dirty_buffer() calls
Date: Thu,  2 Jul 2026 20:21:14 +0200
Message-ID: <20260702182057.2832980-36-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3000; i=jack@suse.cz; h=from:subject; bh=3rUAGRBlH6pbOg5H+zr9aiNgqW2tNOpXc5J+3GzLS9o=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwX/l3sCpV6GFAomZGIekiG2vSqzluDkvZvN NN//Rx/BFmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasFwAKCRCcnaoHP2RA 2e+7B/9Sz72LFDla2R8Q1BBIih+Mtn8fXN/NPtcDq3GXDtcP5wlbDom96zLEtmadB0uO+3fpVXY MFTN0sp/3WGxcYh+mgVmV/Kc1MVzk2lj4cKX/DpO4oV44Un4PEwildL3XerOW6tLT55+G65eJjB 7pqrgbsQuqUsSr7UOisLEsixLtySaOqMtGaNHByoUGsesVsZM9bPbt1rEPpHSE0Mtf7bCX29zUZ EC1YO8CFbkBQHzHPwvmyM3sAO0cmxeMFZksjrZvq7110JZPNpVTVzU1u9BtPitR9m+JGiE8Mkqg 2m2MFQWHr1uh0f+W/G3VO7N6XYGM+wWUnmc9PwRDaVFSdeGX
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

Now that fat_sync_inode() ends up writing all metadata buffers
associated with the inode, it isn't necessary to write them out
explicitely using sync_dirty_buffer(). Remove the unnecessary calls.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         | 14 --------------
 fs/fat/namei_msdos.c | 20 +++++++-------------
 2 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 4f6f42f33613..a54e6d125794 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1028,8 +1028,6 @@ static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 			nr_slots--;
 		}
 		mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
-		if (IS_DIRSYNC(dir))
-			err = sync_dirty_buffer(bh);
 		brelse(bh);
 		if (err)
 			break;
@@ -1063,8 +1061,6 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		nr_slots--;
 	}
 	mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
-	if (IS_DIRSYNC(dir))
-		err = sync_dirty_buffer(bh);
 	brelse(bh);
 	if (err)
 		return err;
@@ -1119,21 +1115,11 @@ static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
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
index 0fd2971ad4b1..4e20f8498938 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
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
@@ -571,7 +566,6 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
-error_inode:
 	fat_detach(old_inode);
 	fat_attach(old_inode, old_sinfo.i_pos);
 	MSDOS_I(old_inode)->i_attrs = old_attrs;
-- 
2.51.0

