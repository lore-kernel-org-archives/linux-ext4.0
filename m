Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E73783BB
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501700; cv=none; b=c73wrJhCtuzSCIPUlBxZJoIX+ky37k1AHBbJTM5W4m2VHtr053DUm0p0D/NSa+eZi9MeykWrjSuquEzsSxMKFWEfkfmIOHIZEVWBvHTVhDXDnMqRs3JaBpKLJ8maXeVbU8GwsukNHrkYNB9C4hTR2L45vp3h0LFU3+0R6nd6sWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501700; c=relaxed/simple;
	bh=stUG94migTo99fJuoy5nGwSPVkBCch/iyaWO7GWVsCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNjpG3srl64lYEiBnpJ+ivnZ2AVuAgpq1ehid40DpruWDuPJjVYSVbo4sVp7KdvoV+qsi17RkQljHRHrQE3dCY2t82dF1EvFDxR2MikABDMq2fD0Mc2j4u6wUJkPtOYTN+tYag2F2+v/FYN+70IGHzyMV6EJyt8Y0XWaSo5l690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UyfjnaQJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uxW4rb4e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UyfjnaQJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uxW4rb4e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UyfjnaQJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uxW4rb4e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UyfjnaQJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uxW4rb4e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2032367FCB;
	Mon, 11 May 2026 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Y0UCuUMEYa69Iu7Sxj4Abfa/UjfKZKajA7MJlEpId0=;
	b=UyfjnaQJ6ZVvZTsOHkf0TAsHzpje07bzgrUTj1kCNC8HCzvIdeRkEtwgcep+boQh74ZCq/
	UOvGxmGz3F/OMTP4prZUJWDyLTyf25+E9n/V18xuQ2HU09I681OBqmKJsrUE5kdV42KpYb
	Bg7zEsSlBWOJrlsV6ABlKFGWW7Od1Ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Y0UCuUMEYa69Iu7Sxj4Abfa/UjfKZKajA7MJlEpId0=;
	b=uxW4rb4e0ovHkuIS7sF7oUfanldBVCNWaRM1zckaCNU9KzFBVOQ5HR+gJ5JqBqQK42k5Vd
	a0tnOu7+Qgmct1Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UyfjnaQJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uxW4rb4e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Y0UCuUMEYa69Iu7Sxj4Abfa/UjfKZKajA7MJlEpId0=;
	b=UyfjnaQJ6ZVvZTsOHkf0TAsHzpje07bzgrUTj1kCNC8HCzvIdeRkEtwgcep+boQh74ZCq/
	UOvGxmGz3F/OMTP4prZUJWDyLTyf25+E9n/V18xuQ2HU09I681OBqmKJsrUE5kdV42KpYb
	Bg7zEsSlBWOJrlsV6ABlKFGWW7Od1Ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Y0UCuUMEYa69Iu7Sxj4Abfa/UjfKZKajA7MJlEpId0=;
	b=uxW4rb4e0ovHkuIS7sF7oUfanldBVCNWaRM1zckaCNU9KzFBVOQ5HR+gJ5JqBqQK42k5Vd
	a0tnOu7+Qgmct1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72197593B0;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wZ3bGxPIAWrhWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 98682A093C; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 9/9] ext4: Use mmb infrastructure for inode buffer writeout
Date: Mon, 11 May 2026 14:13:59 +0200
Message-ID: <20260511121356.241821-18-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3897; i=jack@suse.cz; h=from:subject; bh=stUG94migTo99fJuoy5nGwSPVkBCch/iyaWO7GWVsCo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgLixK2FE7z1wFDFJ9+CwNBuv5v4LWHG4qc3 5I8F0thpvyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHICwAKCRCcnaoHP2RA 2QYRB/9WcT6AuTzcLr4SYizDkNP2CmihWZ6wm7zzkZg7/tY6eawfUza8GLRaqPwszyREw536RJO ipb/m1jTFsC6FZCje8L8xo19D4y64F37E3NbVAs4QbHNPQA+Kcxc4pJH/n9RxNNvCCLYbqyvtSc xSgbMdETncy4C0Jce9TYWkPNb9OKKEfvBIQAJYmBD/7JBoIuBzvrUNJkZUOq+kmq13YmPsIFKWW qgJ7FAfPv+997x38X8UiLcbEvrPe5CZ2WdHh5oI9hcavVqdOxdvUKrcYAkowOd81JDPq6ql9NDB gJKkI815EJkRDRbKwEDnIOT70KchqS7hzwbQjWpXhzQi0I+t
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2032367FCB
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's inode table block on fsync(2) in nojournal mode (from
ext4_sync_parent() and ext4_fsync_nojournal()). This significantly
simplifies the code as we don't have to explicitely handle inode buffer
writeback in ext4_write_inode() and thus we can also remove
sync_inode_metadata() calls from ext4_sync_parent() and
ext4_write_inode() call from ext4_fsync_nojournal().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c |  2 +-
 fs/ext4/ext4_jbd2.h |  2 ++
 fs/ext4/fsync.c     | 12 ------------
 fs/ext4/inode.c     | 24 +++++-------------------
 4 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 74f05bd0cdde..6bbaf72108fd 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -350,7 +350,7 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 	return 0;
 }
 
-static void ext4_inode_attach_mmb(struct inode *inode)
+void ext4_inode_attach_mmb(struct inode *inode)
 {
 	struct mapping_metadata_bhs *mmb;
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 63d17c5201b5..2a01b8279c88 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -122,6 +122,8 @@
 #define EXT4_HT_EXT_CONVERT     11
 #define EXT4_HT_MAX             12
 
+void ext4_inode_attach_mmb(struct inode *inode);
+
 int
 ext4_mark_iloc_dirty(handle_t *handle,
 		     struct inode *inode,
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e25d365e1179..af84489e57c6 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -75,9 +75,6 @@ static int ext4_sync_parent(struct inode *inode)
 			if (ret)
 				break;
 		}
-		ret = sync_inode_metadata(inode, 1);
-		if (ret)
-			break;
 	}
 	dput(dentry);
 	return ret;
@@ -87,10 +84,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 				int datasync, bool *needs_barrier)
 {
 	struct inode *inode = file->f_inode;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = 0,
-	};
 	int ret;
 
 	ret = mmb_fsync_noflush(file, EXT4_I(inode)->i_metadata_bhs,
@@ -98,11 +91,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	if (ret)
 		return ret;
 
-	/* Force writeout of inode table buffer to disk */
-	ret = ext4_write_inode(inode, &wbc);
-	if (ret)
-		return ret;
-
 	ret = ext4_sync_parent(inode);
 
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e66e9510909..09506b4de1b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5786,24 +5786,6 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 						EXT4_I(inode)->i_sync_tid);
-	} else {
-		struct ext4_iloc iloc;
-
-		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
-		if (err)
-			return err;
-		/*
-		 * sync(2) will flush the whole buffer cache. No need to do
-		 * it here separately for each inode.
-		 */
-		if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
-			sync_dirty_buffer(iloc.bh);
-		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
-			ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
-					       "IO error syncing inode");
-			err = -EIO;
-		}
-		brelse(iloc.bh);
 	}
 	return err;
 }
@@ -6348,7 +6330,11 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
-
+	if (!ext4_handle_valid(handle)) {
+		if (!EXT4_I(inode)->i_metadata_bhs)
+			ext4_inode_attach_mmb(inode);
+		EXT4_I(inode)->i_metadata_bhs->inode_blk = iloc->bh->b_blocknr;
+	}
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
 	err = ext4_do_update_inode(handle, inode, iloc);
 	put_bh(iloc->bh);
-- 
2.51.0

