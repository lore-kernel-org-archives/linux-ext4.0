Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D503F8EB3
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149420; cv=none; b=pT0CasYpm2opkCsSx/dMceKIY3zKRfBW2R1Fo9xsF2p+p899/dLpMK0/HlmvilfmVpBgIn82o4T3+7eiKacvUxBJeXQlHDI9UT8CtLqjI9xTFlu5WiS1pGeNeZstpaBMsnun+YW2Vtxjxf11r/Bazc1CAx7z7gvYNXKSr1NYdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149420; c=relaxed/simple;
	bh=Yil4w48BycuQIKgI+xNv1jvmKY/5rw/Ydw21WXteCv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPWJNtJFThTKFXn6stuSZT2okxUwwjbnTWuo/zIwTQbroXD5uho9Vo8FbXifpKfqmJuPh2XbIb1M+6B96oDr8UVhPAcBlhCP5FmnmbWXiCzG0eL0ArzvRPrnS+KbIH3m36983TpA7BnoGh1lE/QWTfWtPeYv4gX+jSzedXsvChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RaH/vIFQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NeHi4Ab5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3HEsvTTH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9UzRmLdV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RaH/vIFQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NeHi4Ab5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3HEsvTTH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9UzRmLdV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D9D6522A;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wenKM2mCN8fWVvsBiyjI9Qb5311L5pdksrRyuapjyqk=;
	b=RaH/vIFQn7pTAjpEehDvp6ryem3FrI9HhycXWPifCItOSYm4YmXrTpd0nDtWhRmF5nnHbe
	gWPUsYSkcsZhqwG+GzK5lL+h3ttwr9gZsEXlPKyVQtG6sDRtdoTFwwAx+C6XiDCH9KA0hG
	AQ8hXVaKJNZuV8d42UqAPorScv8zKrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wenKM2mCN8fWVvsBiyjI9Qb5311L5pdksrRyuapjyqk=;
	b=NeHi4Ab5Sn7BFYMV6Tp3Nbv6YGyopOnN11FG6b19jtLe8g4MFn68Y6mOJO9tHrwkawcFsv
	5/9v4XDZIcFApNDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3HEsvTTH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9UzRmLdV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wenKM2mCN8fWVvsBiyjI9Qb5311L5pdksrRyuapjyqk=;
	b=3HEsvTTHVkCc42uCdfhs60j1wfQX7kcL+M/a9QiwPGdT93uH6HDmjlwzsgsSSn2xGdQt+/
	8uXqD+3IFkq3ICjlHnJ33EINhvjpp35dZ7IRYJ36s9EHP4u1lWra7i12d142fvV/4kzkAb
	iiLdEQ6+rgSTpN/0VIy82rCnhGfs/Is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wenKM2mCN8fWVvsBiyjI9Qb5311L5pdksrRyuapjyqk=;
	b=9UzRmLdVj6+MhcvOL+PEqh76RPriKxM1sWh/zrpmeVVQOjFCuGRnl3X7KRCj5l+zC8IsWI
	JoeAbezIUUIDycBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A51E779D0;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LTyEAsw3Z2oVawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4BF5EA1329; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 07/20] ext2: Drop __ext2_write_inode()
Date: Mon, 27 Jul 2026 12:49:25 +0200
Message-ID: <20260727104923.3828017-27-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2385; i=jack@suse.cz; h=from:subject; bh=Yil4w48BycuQIKgI+xNv1jvmKY/5rw/Ydw21WXteCv0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze40RtQDMsio3azPtXr+EEqmaSG4uG6rvafe ok1Rx15ssiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3uAAKCRCcnaoHP2RA 2ZXPCACWJ+V3TQkJ+XjT/hxWeQ4Mw8huZ/hoFUt6Wb64VeTgjYkJrsyF4opB+HJUzeIWJBHxGXy v7x6bjGDnj7/xuRxI7AmVdW8cQOeJyjqi9MyW5L9PdA+Qvlt/0ATXzaKksemsRLBY65rPLLAmue aqyFsTntvhbRKDuLnVWcwcxrfmcMZQbYvMRvpL+o7vrgZ6gjtbrlo7wfqqkkd2a3Q249oAJMJuL vWy55iuKOg6B6xFK4WTBO7uEgC1DLUAnYpIXr05Cax2J362P3TvZ0hSForc3zlg0mX0XchRPKq0 lnFOvoFcOUkZYQ23RL1i0JQN2sYxrQaTcf7Tb5cwzVh+f54p
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1D9D6522A
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:email,suse.cz:dkim];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Fold special helper __ext2_write_inode() into ext2_write_inode() and
just learn the single caller of __ext2_write_inode() to pass proper wbc
instead. No functional changes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 269b1c9fba5f..4dbe52e42d82 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -39,8 +39,6 @@
 #include "acl.h"
 #include "xattr.h"
 
-static int __ext2_write_inode(struct inode *inode, int do_sync);
-
 /*
  * Test whether an inode is a fast symlink.
  */
@@ -83,11 +81,16 @@ void ext2_evict_inode(struct inode * inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	if (want_delete) {
+		struct writeback_control wbc = {
+			.sync_mode = inode_needs_sync(inode) ? WB_SYNC_ALL :
+							       WB_SYNC_NONE,
+		};
+
 		sb_start_intwrite(inode->i_sb);
 		/* set dtime */
 		EXT2_I(inode)->i_dtime	= ktime_get_real_seconds();
 		mark_inode_dirty(inode);
-		__ext2_write_inode(inode, inode_needs_sync(inode));
+		ext2_write_inode(inode, &wbc);
 		/* truncate to 0 */
 		inode->i_size = 0;
 		if (inode->i_blocks)
@@ -1466,7 +1469,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	return ERR_PTR(ret);
 }
 
-static int __ext2_write_inode(struct inode *inode, int do_sync)
+int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -1557,7 +1560,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	if (do_sync) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
@@ -1570,11 +1573,6 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	return err;
 }
 
-int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-}
-
 int ext2_getattr(struct mnt_idmap *idmap, const struct path *path,
 		 struct kstat *stat, u32 request_mask, unsigned int query_flags)
 {
-- 
2.51.0

