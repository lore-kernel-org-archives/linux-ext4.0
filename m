Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA9E42CAF6
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213778; cv=none; b=pErGnCjrjRmsYaOwFBBfGmAhzVwZV8gt3TiIqMq7p8CMMgpv7GCrxbw2dFIq6egDtHZ028Czn8sUvYfm60MCN+kQL8K47x0wdPeHRaybzO7vthKJ1ZcNnF9W5PANkLbNRsZYXWVYkRCZ/TbqfjyJQ+yEh4/ykk4yXCvHhvdgDZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213778; c=relaxed/simple;
	bh=Qf++9qSSLCC+56CHUQkJQPTBeLBA818Dpw5k2OgttuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVKd9L8mEDT/qwP92Vg1ot0+5WbAGh3ZS8NS+5wSSTFwjbB95DiU7wLwJkp/Keh8aOwVVTTWajtLZVAKuu3oBy+IMkH4191AVlq6gZsx0lgAUE/6mmSqXgQFF3SOxhlw5gOPBVZDRqORuzw/2HO4lBPwn8TwwsPITAhuSqqzF3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rz+xBITU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=79Rk2Rxg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rz+xBITU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=79Rk2Rxg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rz+xBITU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="79Rk2Rxg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rz+xBITU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="79Rk2Rxg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 645E1789CE;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=Rz+xBITUitgeaUo2n/lj+T50fg4WPIKJ55Va5hRbK/51pf+weRkqEXcIkwLbfIQp0fztoK
	7y64GDdPqLnfQJ5r9KmqcUSoiAdX5n6g6ZmEnw8GMwUWxtYIRk+Y0YakB63+GrU912mln4
	pUT4RoF1gUzcHnl2wwwLaHkyUYRDSjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=79Rk2RxgJFU/ZtNUBhoqq2JnbnrDPv9yZzA7Xi/yDm+WNHj8tCAxv2LmPyRwbzqlKmxRSR
	qA4sY/m3Wf4tQ+CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=Rz+xBITUitgeaUo2n/lj+T50fg4WPIKJ55Va5hRbK/51pf+weRkqEXcIkwLbfIQp0fztoK
	7y64GDdPqLnfQJ5r9KmqcUSoiAdX5n6g6ZmEnw8GMwUWxtYIRk+Y0YakB63+GrU912mln4
	pUT4RoF1gUzcHnl2wwwLaHkyUYRDSjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=79Rk2RxgJFU/ZtNUBhoqq2JnbnrDPv9yZzA7Xi/yDm+WNHj8tCAxv2LmPyRwbzqlKmxRSR
	qA4sY/m3Wf4tQ+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C74F779AE;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kFiRFgXxWGr5XQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7CE4AA09F3; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 08/21] ext2: Avoid unnecessary inode buffer writeback for sync(2)
Date: Thu, 16 Jul 2026 16:55:30 +0200
Message-ID: <20260716145527.3580300-29-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1049; i=jack@suse.cz; h=from:subject; bh=Qf++9qSSLCC+56CHUQkJQPTBeLBA818Dpw5k2OgttuY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDmaNmujZfa5LKEk2KZ9A6uDQkGWBUoCaFTF m9f87EI7lGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw5gAKCRCcnaoHP2RA 2f1VCACRyBudQNPGwo/F4H4capHR0xQLy5OLb93sOPY6+1hYtLdeCJ6p62tqWvKP/krkFyOYLgY JoRFVoIi7VUzMrUlwKtBhY9N9SMGpH5/TDj67na4Ysg5Lvh0igDY3zTh8hfbhX/eT5nMk25jEUz MOHFAo6yQV9GkpkmSRZFWoPwJ9hTayNmyEcqakGQ7/rkwsgRAxUXzbirq0lxMTBCv6HslwG7X84 YqmzU6oYEr6enmnQ93S4amzAVjjUH/yrq35ui8CSTC6avjEftzjwWI7NxxYRqQ+qi3JJia2Hg68 ThpX4SydakNAYSqgcsmOv/d2WgeeLvcBALC/OWpde9RHOS0G
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

For sync(2) the generic code calls sync_blockdev_nowait() and later
sync_blockdev() to persist all metadata buffers. Thus there's no need
for ext2_write_inode() to do that which speeds up sync(2) writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 4dbe52e42d82..904e70f3140e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1560,7 +1560,11 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	/*
+	 * For sync(2) the generic code will call sync_blockdev() to write
+	 * all metadata more efficiently.
+	 */
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
-- 
2.51.0

