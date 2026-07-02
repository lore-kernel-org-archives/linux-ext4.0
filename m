Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FC37A83C
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016507; cv=none; b=uPUozleu95cwDvCRpx7XEaYTC6Tn5YvVwuTWImadDApETLmP8A1DSu4PaqnoH12afiVe/2fOcGOOR0/rz5Biw8NEWmr1Y8bO+k04L7mIZh7FjxMa1hVV79jKaHqU/DzCap1CYS5Uf5nDg5kHqQtSCgJtyTpqbYwE2iDtp/GI8pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016507; c=relaxed/simple;
	bh=tdvdeE5R112+HIPeKE7/vLa+iLiHnIPUkYmKg6TmJO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5QkJEzKeBkIvEBRMHm3XaOOTCOhfD465wROnTA5rfUX4jzhAx7GPd5c8ZDWZQ+Pj1L6T97lXTAiPxH+zFCF95OFAGOiRBwx07WWi/5jtY6k0cdgKdL6zQZqA6ZsFYrfynPqBvyalpLfmSnedZoT2YOcKNl6CtgQTaZlhgXnbuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ECA06760E3;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF800779AC;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4eItNiCsRmr0FwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1EAECA10A7; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 05/19] ext2: Drop __ext2_write_inode()
Date: Thu,  2 Jul 2026 20:21:02 +0200
Message-ID: <20260702182057.2832980-24-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2385; i=jack@suse.cz; h=from:subject; bh=tdvdeE5R112+HIPeKE7/vLa+iLiHnIPUkYmKg6TmJO0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwNzP51JWV7qWkFTDzcLo3nG2hXCj3nPr677 ccI4wmPRPiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasDQAKCRCcnaoHP2RA 2bM8B/sEJEuu5aMziBvaz2ZVqUhO/ehjtWpR3tA/jAaGMRamBlRgCcXeRafWPlGXb/PZPlDOfgJ cW1OZ6c2s1gj4IqB4VG+vZEIk33O9WQC/civXmrd3mCciOjpKNl3TVGGHF8YvTD9uf+3BE+gNfh 1pRJea7+ahq77BYwnlUZes2Z5WASkZqO6NG48u8dRfRr8rFtBQcWqRPl+j+/QpynIjzbymJFs/y a+mB3uV0atFQ9I9pCeFuH/X4Ba6uO7LtWgVRknPQxcqGKsD20dAW+2kObVCnqtQTX7hpJVTFerh R/s+Ts68IpbVC7W8bde7BRQIT6bZ1qNR/qlqDxwxMvj74Lho
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: ECA06760E3
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

Fold special helper __ext2_write_inode() into ext2_write_inode() and
just learn the single caller of __ext2_write_inode() to pass proper wbc
instead. No functional changes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..dc7003e21b12 100644
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
@@ -1469,7 +1472,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	return ERR_PTR(ret);
 }
 
-static int __ext2_write_inode(struct inode *inode, int do_sync)
+int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -1560,7 +1563,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	if (do_sync) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
@@ -1573,11 +1576,6 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
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

