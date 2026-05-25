Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC94280335
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699535; cv=none; b=exYOHdIOgI+e91BUzXrR3Oj6wh30D60t+imIkaaZ5BdIYKcDpghm6XTci7Kx5uKpaewBrhFquMLnD3gcNHunNi0xvgfk/xZTrs+wzUDaipz1Axv3sWM9cVVQsUj+6Wmwg64/mmLPeyUla7hMv0kBj+zAvdEA8MkTfOF+MgR+Lnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699535; c=relaxed/simple;
	bh=KHDTSSKOTWhA7TMyqMOL96sXwMhLS33QY11aTNlYK/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSJ7QVbMbF6FOF332mPmTV+L3l2uN7ZhWPFCQ9SPHZsb9LvZ1QB+ZiweCU8MK8aKRyTOQcsnW2ZtMoist7yjNHvPPQmvSrImAERpdSVVzbDiKT+cvD47kG/gV8T23gYeeGRcuVIfJGLpzS0lN2winVhhZsEOC9WdlSh6JKr3AlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PP9cs0Cw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eLNvwRXe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PP9cs0Cw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eLNvwRXe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PP9cs0Cw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eLNvwRXe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PP9cs0Cw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eLNvwRXe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CC8B64AF1;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVzmCOn0ueKOe0tSOFrRNfYBjWpBLazUnpXJEUHvxsI=;
	b=PP9cs0CwIU+ThTUpg4GevqlnYi/BkfD+4ouRsT2+3pekYCHqQ+RWUeLXBuuVZBxtOH4bKx
	6KhyOYRbBQfNZqS1Zpvu35L+Im4HcWM/Q+nwcE5pbYCd1qO0vFgqVoZZxXwxk/OFEAe7wS
	CrQnv499r5NSYkLPWsjYbjHkUwkb4HQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVzmCOn0ueKOe0tSOFrRNfYBjWpBLazUnpXJEUHvxsI=;
	b=eLNvwRXes41Yv4rMvjSTyzKattFKMDQsOovCGSGTZiGm2dL80BjguZEOQsKSUcM9zSz0mZ
	DEA8HbnYhQ7n0JBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVzmCOn0ueKOe0tSOFrRNfYBjWpBLazUnpXJEUHvxsI=;
	b=PP9cs0CwIU+ThTUpg4GevqlnYi/BkfD+4ouRsT2+3pekYCHqQ+RWUeLXBuuVZBxtOH4bKx
	6KhyOYRbBQfNZqS1Zpvu35L+Im4HcWM/Q+nwcE5pbYCd1qO0vFgqVoZZxXwxk/OFEAe7wS
	CrQnv499r5NSYkLPWsjYbjHkUwkb4HQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVzmCOn0ueKOe0tSOFrRNfYBjWpBLazUnpXJEUHvxsI=;
	b=eLNvwRXes41Yv4rMvjSTyzKattFKMDQsOovCGSGTZiGm2dL80BjguZEOQsKSUcM9zSz0mZ
	DEA8HbnYhQ7n0JBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 754F459B6E;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XY6iHD0PFGrIbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C3A1BA09C2; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 05/10] udf: Fix possibly missing inode write on fsync(2)
Date: Mon, 25 May 2026 10:58:11 +0200
Message-ID: <20260525085821.769119-15-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1001; i=jack@suse.cz; h=from:subject; bh=KHDTSSKOTWhA7TMyqMOL96sXwMhLS33QY11aTNlYK/g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8xAJEGHsnW8EZfHzTTDO0+bf+a6k2e0bLtT Lmx0izgREWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPMQAKCRCcnaoHP2RA 2TaqB/49o8bBVpEiNIzafu4jQqfMnlhEvykJNPFxv8EqGQ19SHdL3sXlgrx36euCcol9DE2W5Ec b5ffniCHTEb4ZPdXeS8TZ6GwUM/6co6EfYLpnaMIU2xQojbqLn+/ZJPQzDBcA6tFDQQ56mH5L+/ vP0cJKeg+2zwC7deXAemFaiLE2MMPdRCL7VnszlN2T/WyRKHvPf55QZZdYwo84yO3WQOZyW3KcN m1FFaKezw1PFBYt3tPvJA4st3rVvnWecWs4zycTL0LeIM2VoiUF9BQDGG1Pr/aawf3wWzyFNj7s e4SAyCFa6/W1my6+yoigXno0Vefg/MHL8VTqYNYKw8YGsLEM
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO

Use mmb inode buffer writeout infrastructure to reliably write out
inode's block on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 67bcf83758c8..861400152261 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1707,7 +1707,7 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
 
 int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return udf_update_inode(inode, 0);
 }
 
 static int udf_sync_inode(struct inode *inode)
@@ -1936,7 +1936,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	unlock_buffer(bh);
 
 	/* write the data blocks */
-	mark_buffer_dirty(bh);
+	mmb_mark_inode_buffer_dirty(bh, &iinfo->i_metadata_bhs);
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-- 
2.51.0

