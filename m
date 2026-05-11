Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166253242B8
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501677; cv=none; b=TUHD9RDTyBY0QG8OTF2vm6MHESnVH5SlpzkECC2TE4L5vcEdmlB/N/fXszA0S6yTvIGBOIjddDiONCNdY54UYCZNUP4qJCswqMvVlEOzDDMyEl7B2S44DLAC+7UcvfUXe4paJ49S+leIp95hEJdN+TiMd3Oisv/YoeZsiNsu2H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501677; c=relaxed/simple;
	bh=8MKQjFaZrU677ZpwRUhbtFfgfHQ41cBxwUdUOWg2JqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/gNRnX4DK8ytxcqSYTZTKa97FVd6JVv7WS/trPI7i6WIQ2PuMUzVZVNMEh/9Kru0DYSnbZusRKdQCfePatyv4vIfGzdePecKWChIE7JgXyn3kLQMjGfFgtQb3QCFVh2IT6Hq8qERNKrsqteWcIv1I96sI5RLVrgl6JDrjJ9UT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=E4hY6hcy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u/QfyDmh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VdsOJsMB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cAo2WxVv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="E4hY6hcy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u/QfyDmh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VdsOJsMB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cAo2WxVv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3619567F15;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuFXtudYvkPmrHQz91zpeEUhQIbv58mxF1KjpLD9B8A=;
	b=E4hY6hcyoLrDfk4HH2kGnK/xdOf77V7ZT1wfKX6TYf68PJl2LnBmjGCAPRiA+8vYxnhmVF
	fZtslLcIYT7/EFhczut771KY2BQJRdoKMe0L6ZSRBxBNWLCc5BImBAyGVoHiVzMYLRxd4/
	xA8ADP3XlK45fff3QIht0qkIY4IMyMA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuFXtudYvkPmrHQz91zpeEUhQIbv58mxF1KjpLD9B8A=;
	b=u/QfyDmhBJ04zhQjoMVEwQxAFylEz7GBSY11A/n763SEa/1DXlPT4JN7DQy/2+b/TGs+SF
	sDmJH8G7hP/+KBBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VdsOJsMB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAo2WxVv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuFXtudYvkPmrHQz91zpeEUhQIbv58mxF1KjpLD9B8A=;
	b=VdsOJsMBBKDXc3pTe+VKlTfYqBlBaK1ZFr9ImbhzZ6WBKeL8BJW2+u/XkVb0SAdZ1NnD9x
	Mb4z/6nYPhA094lb1V5raWwF08b9WJQBxaOI5JK7nXmFvNYKkctYi70+xFDGVbTZwC/SYb
	aJApeRKOYkHbJGpcPB6qLxaEdpgluSI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuFXtudYvkPmrHQz91zpeEUhQIbv58mxF1KjpLD9B8A=;
	b=cAo2WxVvyzVueUfrLC0udtapBKeMilFK3SLxf0jneOyqumIKt+tSpBYR9DHENBJ2R48k+7
	Ggs0NN7i1zgW9DAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24E89593AB;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4XwFCRPIAWrTWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 80005A08F7; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4/9] ext2: Fix possibly missing inode write on fsync(2)
Date: Mon, 11 May 2026 14:13:54 +0200
Message-ID: <20260511121356.241821-13-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1079; i=jack@suse.cz; h=from:subject; bh=8MKQjFaZrU677ZpwRUhbtFfgfHQ41cBxwUdUOWg2JqU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgGJmTwTnJPTV0qy+aeIPy0RrYy1Yf4rsNel IRLIboUZueJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHIBgAKCRCcnaoHP2RA 2b9cB/9NmBeDuuRew6nHZAVvz64Ja2NddjlBnNPO3ZBrQAXIxHP/pvzztBHm5ndcXAHsxQ3l9i2 Gorsu68m+XWaG7P8ltXUCoPDHJcj9N5tdHCbaTEaSe3dIj8uWhOGRmc5SEbMAllahfuJQfmHGJ+ vN7y8kP/qMPSyGGxYNAkTQa4+wQVabr4KatchXbZTbZ8O5PzfENh1Z9RFgJkYB+EdpMcxvNspC9 jsKR0giPJgGs9SDA/aDgjy3q67gGqahRNXdVDDPi5mV1xqLhjYRnCiuX1zPJ2TRUoKt36L3xu8a goj/w2dh412gt/Pi8k5iS+GDAy3OyNYM6jtZpofO1x3l46uV
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
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
X-Rspamd-Queue-Id: 3619567F15
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.51

Use mmb inode buffer writeout infrastructure to reliably write out
inode's inode table block on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 74aca5eb572d..6ce832da944f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1612,6 +1612,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
+	ei->i_metadata_bhs.inode_blk = bh->b_blocknr;
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
@@ -1627,7 +1628,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 
 int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return __ext2_write_inode(inode, 0);
 }
 
 int ext2_getattr(struct mnt_idmap *idmap, const struct path *path,
-- 
2.51.0

