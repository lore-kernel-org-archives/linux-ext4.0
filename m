Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0E3E0248
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699527; cv=none; b=dkW5/heSn2EBJ8x2eG3E54iByfF1m/ojcm+y3qrwIVtwXgxOr84APXibMtBcb0MZQH82Vb0+mvA4jU647ZTj9+N/ibxfz3NohkQTDzVLNUZ0IlhIj2K8tuKsAmuhweHEN5NsDYszatnY1jegbpScqu0EXAfkZAiHXpZyYUsVQxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699527; c=relaxed/simple;
	bh=rOovffRFNzx/yAJRIUhw/vrE5yBkA4AFFfmkbGqAzcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOsKdyv6OOtFcneq1j8uTtu+Wh+RY1D/xL4AhjGp31tOVohsCahq2Zr347BxvIUDKdGP+IPbabfckUY4l7YMAy/ro3XnlpjWvhAMf1vgEWMuxfJJPQboTajydSB6gfcFOKuoN3f7OMiE+lpRSbDtNzGnLPsILFAj1uqPFg71dSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 69FCE7591D;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60E6F59B6E;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZHCmFz0PFGrEbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BEF2CA093C; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 04/10] ext2: Fix possibly missing inode write on fsync(2)
Date: Mon, 25 May 2026 10:58:10 +0200
Message-ID: <20260525085821.769119-14-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1095; i=jack@suse.cz; h=from:subject; bh=rOovffRFNzx/yAJRIUhw/vrE5yBkA4AFFfmkbGqAzcA=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLJE+A3i2zhyv1ulHGucr6Topje/bpJv0rE7VXsENthkO uryNBh3MhqzMDByMMiKKbKsjryofW2eUdfWUA0ZmEGsTCBTGLg4BWAiWQIcDPdM+X2ZLB0dZjPU 7XCWzdnuaK+SZXm3aO5JhVSeD2nzQ0Nkppu1lVW/VV9eKFLx5zeHTq7rvC8n82zKQrwVWAJq7uk mrc7inVn6RJ71dPHZy7vP2vB67PP+lpOu3fbjXfymiTWOh6vfBUc8+dbKasepu+xMyYr904VDF9 Su6rmxN+/i0zNPdl440Ov32K/XtEnkRkPuctX7T29wpM48XLLWsMPzh9fCT1azQ1OLDmw9m7FUS k/v4weZ8Gj/eDUji/JjvEppkftDRW0j12x0cbm9ntWILeNJx+GQFTG9P7q3/pXdtPr25NNXgt2r c8vTsmSnG905kip/ZenvSfsXyGQ0Nm7knLPjV6f+V9EdAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 69FCE7591D
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's inode table block on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 74aca5eb572d..d7a812b84b6b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1611,7 +1611,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 		}
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
-	mark_buffer_dirty(bh);
+	mmb_mark_inode_buffer_dirty(bh, &ei->i_metadata_bhs);
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
@@ -1627,7 +1627,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 
 int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return __ext2_write_inode(inode, 0);
 }
 
 int ext2_getattr(struct mnt_idmap *idmap, const struct path *path,
-- 
2.51.0

