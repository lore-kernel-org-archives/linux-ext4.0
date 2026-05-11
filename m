Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE637E2E1
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501689; cv=none; b=h2C8almLAGjnQK514Yy9fymEn5AZaeVbg8XMvNHA5jDaZwe0v2hhL6VzOGzjHbjSpMdO9WWzMv/zkTxM+njzIkIptvuC+yj7PHAy52bl8y1qqgVIXvFGfJ07TAwen4AhOyPqx5pjRbkjfJ8bLcCQrZMD0M3VFMNjf3S3mQgEnfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501689; c=relaxed/simple;
	bh=JR66G7BuuWXlP5ApW208Gob36LAzFXhDVGJsRhntN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvEnUSNWPrW9G0krP1QJmCuMg5cw8o8Rcj03lDqZtz4g3veEZ2/40oqCJ8VNS2AkA07M1w/hhagyYMIpNTjmq/uGdH0dh3yrOSHRurh4hiz9XHVmHdKP2rMaFE+YqDR5AdWFPqSYJCckodJ4Lk3hoA1/eIOTLO2vcuNynvD1iAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0Eqy8gx9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ufZTr9VB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0Eqy8gx9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ufZTr9VB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Eqy8gx9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ufZTr9VB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Eqy8gx9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ufZTr9VB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1529767F1F;
	Mon, 11 May 2026 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHZ8NrriNcQB1ocdLbMs1wRoQiwQjofAO8/6onjoWCU=;
	b=0Eqy8gx9sl6Aq1Ikn9dAuWse/7X/W7TVWMf+zTVXDJ8QgpjczdBgyP4Wqp3wfEHIvoYfp7
	PUOptK8l5u9Lzxw4sR17pmlYY9wNuT2UA+ZUFRHNo+8XGs3q4zLeXBlL44Ngi6WwYAPBcj
	fLYgGX6+6NRRqJ8yI0D6zKZXx2OhPGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHZ8NrriNcQB1ocdLbMs1wRoQiwQjofAO8/6onjoWCU=;
	b=ufZTr9VBdxNT5MJWbE3MHSbSWcQk/FTuDfiOlwOR3D00HyfC5/0JqPePcA9n0QRmDGZB8C
	wYcn6JiiWhXY/pBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0Eqy8gx9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ufZTr9VB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHZ8NrriNcQB1ocdLbMs1wRoQiwQjofAO8/6onjoWCU=;
	b=0Eqy8gx9sl6Aq1Ikn9dAuWse/7X/W7TVWMf+zTVXDJ8QgpjczdBgyP4Wqp3wfEHIvoYfp7
	PUOptK8l5u9Lzxw4sR17pmlYY9wNuT2UA+ZUFRHNo+8XGs3q4zLeXBlL44Ngi6WwYAPBcj
	fLYgGX6+6NRRqJ8yI0D6zKZXx2OhPGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHZ8NrriNcQB1ocdLbMs1wRoQiwQjofAO8/6onjoWCU=;
	b=ufZTr9VBdxNT5MJWbE3MHSbSWcQk/FTuDfiOlwOR3D00HyfC5/0JqPePcA9n0QRmDGZB8C
	wYcn6JiiWhXY/pBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 542CB593AE;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BJiLFBPIAWrdWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8E430A0913; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7/9] minix: Fix possibly missing inode write on fsync(2)
Date: Mon, 11 May 2026 14:13:57 +0200
Message-ID: <20260511121356.241821-16-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=jack@suse.cz; h=from:subject; bh=JR66G7BuuWXlP5ApW208Gob36LAzFXhDVGJsRhntN4g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgJJ0SecCgo12DJwqoyNS1LrpfZgVXoHzXPx Fx2mJ5loFKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHICQAKCRCcnaoHP2RA 2UtiB/9Up35qSyzH7Dkwk6oaWpRCh1ok7+hTFScrB7FH82pVuUbd8F2TAl80PcHU9+Gw//oT9lR F2fwFk2mMm68cqdJesZe0TYoGeyofnn8/GTcgLdvR3cy9NxBKM0egTVyWZTC2BEuFLLtQa79a+E y/LF9CBLTSwyveBhngYs8b4XyHBMuUw5alWG5bQJ94DndwtzKKFhYYEABVIwGQ1bTtdvktQfmoP H8Yqcs5exHWBP75MYe2++C1H4bu8Dd3F4/3gCUrR5DIp3Mxjygk/pXQA5AvLf8y9vxj4uJVhsjK /jO2Q5T6Tr53wHb6dJV0NMbnezrABlrq+mXzR4BmSTaOo7md
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
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
X-Rspamd-Queue-Id: 1529767F1F
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/inode.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 9c6bac248907..e3e05c9308bd 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -693,14 +693,7 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
 		bh = V2_minix_update_inode(inode);
 	if (!bh)
 		return -EIO;
-	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08llx]\n",
-				inode->i_sb->s_id, inode->i_ino);
-			err = -EIO;
-		}
-	}
+	minix_i(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
 	brelse (bh);
 	return err;
 }
-- 
2.51.0

