Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890735DA65
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016512; cv=none; b=bzv8PnUxCmPCH7Jc1saXSYXAbxnT37McXnNZcgG8qJApv19Q0wEsjj629f20lohT3ZwWMJGRLrgb9SKsbsGrAf6VyxcO6hrwrLDPzpr2X1L/6XxxNqGK9d93ce4nXfp79kIB45rgDkI5qFEzDoMommHsyGUfNJc4ZZQdzBTtAo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016512; c=relaxed/simple;
	bh=306IMC3NSqquPI4G2IrQ+IhvqVXyd/3G4nlhBFqHrh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuYxlH2ziK+anLJ3HHSgg95pdUlEp46IdAsIDcINcGC8/9JWmGr+1j11kUQPYU1SV4JXgII1EtVHmH3kxVhW/9EGBlPlZ7REQXcI21dEoF69E0VTXeVbPr1aFj+XWEn0QTQuCTO9i1wmuKcwDVqQuZq1fk28NZ/0nn+KoD2DDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0604A760E4;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E98E7779AE;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wU0AOSCsRmr3FwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 23CBDA10A8; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 06/19] ext2: Avoid unnecessary inode buffer writeback for sync(2)
Date: Thu,  2 Jul 2026 20:21:03 +0200
Message-ID: <20260702182057.2832980-25-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1049; i=jack@suse.cz; h=from:subject; bh=306IMC3NSqquPI4G2IrQ+IhvqVXyd/3G4nlhBFqHrh0=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLLc1vB9qYlLE+mOk2N9eXsq2/wMAYFr0fx3+A9NFG1+3 /RZUXVTJ6MxCwMjB4OsmCLL6siL2tfmGXVtDdWQgRnEygQyhYGLUwAmkn6cg+HDF25jSyOx5QGL c0R6BLgEFjnp/y6Z51mbU50uobyleLKp41SJ8ncZrZGlh7REc3Xa39l/aslez5VnOGHFFKmeBzd CP8nMvrLWxv/83qiS7Ly1n5fnfHPSXSasbmBVHf1sc3NdUajDlMPnuj/9VZLgOs3JsFda24rtzM P936z2+rjsjVGar7NTK7jxX7PUA+7ljhYxKjX5r8IO6uWWqxZO+N+91/pISW/4lkWzV/7NTnk9p z/SNke0YJJ3zrOsSYFZQd/Xt18O4cjyF56648EWge2TJrU7avyffYU1RfTRFsZVLQ3p2xoCL12/ zuMWv7t+cVLhiciuO1NMGV9rZzt4K7osWO1zp2xfFz8jAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 0604A760E4
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]

For sync(2) the generic code calls sync_blockdev_nowait() and later
sync_blockdev() to persist all metadata buffers. Thus there's no need
for ext2_write_inode() to do that which speeds up sync(2) writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dc7003e21b12..48862e73610c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1563,7 +1563,11 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
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

