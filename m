Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FEC3F9F35
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149432; cv=none; b=eMBuIKy4/3BaAl/5t+czAUBORy5OEphBhk/8MGT9UJxGLHMRxsi4zWBENpbBUwxWZMIcCOTsWzKZ1l/0+/Ud3TTsEzibK8uGCwvhJcCa0ZRSaUZGzcTPry/QGOBYSdL5KxGrW8BDuctVYlUTuls0823gXI+R4s0Wb7O5CyNV2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149432; c=relaxed/simple;
	bh=Qf++9qSSLCC+56CHUQkJQPTBeLBA818Dpw5k2OgttuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgkX4z678QzgwghmbWqjkd1t48XeDkF0Ybhm5k+HECAlPvl9LE9DQSFyMlYt3V+cQ2MtQeLf+SIdt7X7Dggz4UBD7JhK5kruGxfkYQGVn56JqzQs7h0V1eXnQkSTd5+nPaviGTnqZuS94qWYxgdHLZucoU/2ohWGpOgi37oPfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2y5L4uPy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=73Ny01Em; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kPwEtV+w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7DNUwdBk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2y5L4uPy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="73Ny01Em";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kPwEtV+w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7DNUwdBk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 714BA7DADF;
	Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=2y5L4uPygUYY73VjCY/3QcgX+hi7RpCmAOi4M8C+N1aN5P/XfJsABT8a/rDGf4ohb+P9mm
	pkWeFZGjKFxZN3+GpaBwtMmiswHFGK1aL0cMny3YzZgyXnkNBZt+Uk8kiFBZ9sYG81MAaM
	010cRERW6n8MjND0N1tdxeAWoaCN0Jo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=73Ny01Em+ML+6kznYPTCiIEsYjrxKPCOiQw8wUi3NK5ade/bN3jXD8x56U3ZPEm0oKvl9o
	XMFJllwByMu4IGDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=kPwEtV+wJsLrUqE7ifmyx8LGS85NJUtSxyi/tN0a04puiqP4EDec2+a6eHcVI1WQU3I188
	oW7j+hiNktngfuE49+ZsbdkZHZ3rJcDpbzUmM3HkUxfc5DrmlMj/kfKSewY8gq/e4EbHCw
	/gTS8wvqdjcA2q3HGNBw/IMNizAPFn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQGq05ldMEjAs+Ex3l61YsLHZUtknsICMU/G7w0Ox4=;
	b=7DNUwdBkA+6s5OXt8RmtyY7xESVvvvnCoCM/8DUdwKnwS+A004LJWJlkvyDwnR1XdjZZwc
	PQf0HKjtVx3rcfCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 64876779D8;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BUqMGMw3Z2omawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 508DCA132B; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 08/20] ext2: Avoid unnecessary inode buffer writeback for sync(2)
Date: Mon, 27 Jul 2026 12:49:26 +0200
Message-ID: <20260727104923.3828017-28-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1049; i=jack@suse.cz; h=from:subject; bh=Qf++9qSSLCC+56CHUQkJQPTBeLBA818Dpw5k2OgttuY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze5aNmujZfa5LKEk2KZ9A6uDQkGWBUoCaFTF m9f87EI7lGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3uQAKCRCcnaoHP2RA 2bfHCAC7F1co9F5tXaC6n26+FhIk9tjYlay0OxbKSMar+aVdW9vvvlxF2kt6ORrjzR7FVeMsBej DV9ddLqrqNvn8ifb6IXM+nt3uzn4/HBpKy7N2z72weMeH1U12GJwL7yr8PVlLATTE8simcxvwGE y1tuosf7feS4EdP89hW62c76q54sUsZDw0OKDEgjBaQKL2iZOeVKLw8Gfq9RUI0nLidlmLobZOk eARAW896tHjc9lwmedcqIo25E5jNItKQyqz+3b4kGdmy+gAsY+i0zEwMT4hvJTEKd+4E6MdZ85x 33TRZotfheqcaCEAfmJcdvT+V92Pq4tLIjlAZgUqbvGVWFoG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

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

