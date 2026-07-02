Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6812343884
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016489; cv=none; b=kNmuhXdDCMEombBr+h+aLmSfpSlQyEXhw+ZqelLjtD4k7iICpEAgGYNmwMLtt87yszmr4g7JqVrzpBho77KrVXlamrcsKB247QmgGp9RiD5XOuwhiG7E85N1QixJ0nENLKiqYAymQSVMZvotoD1MDRYRPHz/sSThVNeB0p0MJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016489; c=relaxed/simple;
	bh=pNt+x17Eu8+jKTh9bvvzTa3eWjG3eeQyj0YWCZVuk7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKb4uYhsQWltOQm54zO4rALxtiTAgdnNlTvHZkQ1776d+c2YsIv7IKHW9xwjz1wTKY7iO3AlC6tAP931Ap1R2RGiAx3APdFrzYieLHfQoYIOVb7v5T0qgdB2QtKwHUhlBoTl7WoEn2Paj9MFWJ1nkk74UNb6A+UFhBLMVHiAtZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA203760E2;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC7CE779AE;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SAgCLiCsRmrvFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 14949A10A5; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 03/19] fs: Fix missed inode writeback when racing with __writeback_single_inode
Date: Thu,  2 Jul 2026 20:21:00 +0200
Message-ID: <20260702182057.2832980-22-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1888; i=jack@suse.cz; h=from:subject; bh=pNt+x17Eu8+jKTh9bvvzTa3eWjG3eeQyj0YWCZVuk7E=; b=kA0DAAgBnJ2qBz9kQNkByyZiAGpGrAvI8v69dQI357uv6NukTswFof7W8vUmLcqZDbKVfH9St IkBMwQAAQgAHRYhBKtZ0SvWnjKKtVUoHJydqgc/ZEDZBQJqRqwLAAoJEJydqgc/ZEDZ4bgH+gLj 1cSV/bKdZqL7n+i2VK7uvUhVuB6tzLRr11iMZelajp0geRFVwbWZEYXm1DjuuNeWd1W3zSrWXiw K57jcB5pJmAZpYQNUi9UbbHh+fkWw/uoEHGxSNFWPnCYs29VjMAXsxFP7/xOUsec53rpyO5AOp8 AKJ31JwZxGGaHlvwPC0K/m8RGLD9xyhNfDRZOt5dkXr6I7qikiV0vs09BSGVUMtWUS5EPiWjqZt vJevGijaL52kQYYNZemGYKHCP4eh5TCa0wn8lMYDzMPd0441tdRiOvao22c9puS0y/Psn/yHJG/ I0xDc2cAiFvVPbmgAXTgY8/jLNGWroDM+Lhv5UQ=
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: CA203760E2
X-Rspamd-Action: no action

When mmb_fsync_noflush() or simple_fsync_noflush() race with another
writeback of the same inode, they can see inode dirty bits are already
clear and skip inode writeback although the racing
__writeback_single_inode() didn't yet get to writing anything. This can
result in fsync(2) returning without properly persisting the inode.

We already have I_SYNC bit for this synchronization and
writeback_single_inode() properly uses it so just fix
mmb_fsync_noflush() and simple_fsync_noflush() to take it into account
as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 5 +++--
 fs/libfs.c  | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index daaa6614a6d6..83ff53c9e6a2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -655,9 +655,10 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 
 	if (mmb)
 		ret = mmb_sync(mmb);
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
+	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
 		goto out;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
+	if (datasync &&
+	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC))
 		goto out;
 
 	err = sync_inode_metadata(inode, 1);
diff --git a/fs/libfs.c b/fs/libfs.c
index 5a0d276379d1..57e5971b6331 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1559,9 +1559,10 @@ int simple_fsync_noflush(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
+	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
 		goto out;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
+	if (datasync &&
+	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
 		goto out;
 
 	ret = sync_inode_metadata(inode, 1);
-- 
2.51.0

