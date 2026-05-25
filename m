Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39423CFF71
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699533; cv=none; b=umLqmJmR06jfYhLSNvdixEQqL+/kshYjnaWvedPimMocCaPuH9uW7QD6cPCgQD/Kcsd8sqF3erfETsVr7fduGLHC4FUlfeOLOrK7V6D9UqCnSVDPPk7D7XZ2TcMOlZsGmh1Tn4dbAF3HV2UtZkESj8N79uzOcNfdgvfz5Q+SlFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699533; c=relaxed/simple;
	bh=V0lvnGN4VQ3BCZdv7ZBs6E+Lwbc+lFVAMtQ5+XkEcsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1vE+Qjs6NHvsvLVlgqN113QQxMED2Eeua0/GKuKYzwwlAGTq1dZB5Uwe2eMUp0+8JTa8LGNAqaZpMWQVW1ZJGfu5xA+HYTE/F/xtncBiZPqeCHuRpaa45Y006EJUES32CuymEs8SvSuqrrnUzZ8LWcnHHToh0842G5/EHibzbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF7687591F;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A385A59B6E;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DBjqJz0PFGrObQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1D8FA0A79; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 08/10] bfs: Fix possibly missing inode write on fsync(2)
Date: Mon, 25 May 2026 10:58:14 +0200
Message-ID: <20260525085821.769119-18-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1204; i=jack@suse.cz; h=from:subject; bh=V0lvnGN4VQ3BCZdv7ZBs6E+Lwbc+lFVAMtQ5+XkEcsM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8zj7puw3ZNiHMJ4lWvAq3Ez2paSDbMPtrnM ZkiBPM5GcuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPMwAKCRCcnaoHP2RA 2eYDB/9RbglZpmZ6tdKkoZqavQ8lQy4Ba0P8qTy/Ucw45q+S50GTx1f7IUsttXhOkRY5NR4LQYR WqT+h6skd7lMz1ixA/Tnidz48IXoYIBcPPuTghzfM6tSnDyRlIykQ7LF4NdaUwQxThO1ZbHMWz0 1FK+y9G/m0dVyrVnL8Ujlj+uhPxqwAxbxiWttS8WLupogy7Q+M38hHPWVCb+8+wgLT+ABEk25Pw SoqibfJGYESzJhSsnAK8hCO4DhBQrV2eCwSUPD5j05DyuO8JYbxj05f2ENR6OsKghascUdqjaVO ltLPmyF+QKCcivQIOPF6Eybn5KmlK+mlXd/xx90/9zS4oexH
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: AF7687591F
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 19e49c8cf750..2506795c3f2c 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -136,7 +136,6 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned long i_sblock;
 	struct bfs_inode *di;
 	struct buffer_head *bh;
-	int err = 0;
 
 	dprintf("ino=%08x\n", ino);
 
@@ -164,15 +163,10 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	di->i_eblock = cpu_to_le32(BFS_I(inode)->i_eblock);
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
-	mark_buffer_dirty(bh);
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
-			err = -EIO;
-	}
+	mmb_mark_inode_buffer_dirty(bh, &BFS_I(inode)->i_metadata_bhs);
 	brelse(bh);
 	mutex_unlock(&info->bfs_lock);
-	return err;
+	return 0;
 }
 
 static void bfs_evict_inode(struct inode *inode)
-- 
2.51.0

