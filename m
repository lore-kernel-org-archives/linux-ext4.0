Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7353E51CA
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699548; cv=none; b=tZ/LwCgCSlT2EoV3gnQCGjiV2W8CjRfmX5ka2MGL10nc2UFbBoTgHWT2B+QwTrKjFt328V44vR+alRm7KO5bR4QBSanl+ev8SF2xXrDaFsL2k3tTWWeXfLv2oOSISV0bHv+jq/bjF5NhZxUpOMSSilngAeg67z52lmlkIoya4E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699548; c=relaxed/simple;
	bh=8+Tkwxt9ToG9f7uuAos6IuHdE01oneUAlv/iRCQGpv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ooboff+uGzzRbLKc4Q1TzOvmNxruH5yLdceSKzO+JyPDtxv+DlBlft2CW43Zf8ADaUtFGe7S0eELky5DNCU3rCA7a51JDRRX/QTJkQqLkzXAxR341usI1JGqwXfuFBUfbr9ZZD9tRp2Q4HNA45BtnKTxxld6iY2ZLPhg1F56X7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD9986B2D5;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4D6F59B70;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H970Mz0PFGrSbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DBE23A0A8A; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 10/10] fs: Fix missed inode writeback when racing with __writeback_single_inode
Date: Mon, 25 May 2026 10:58:16 +0200
Message-ID: <20260525085821.769119-20-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1898; i=jack@suse.cz; h=from:subject; bh=8+Tkwxt9ToG9f7uuAos6IuHdE01oneUAlv/iRCQGpv4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA81i2TR8yBJW9ZvfmA5YogcIA2YgLuhJ56fq zNW6VxfRfyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPNQAKCRCcnaoHP2RA 2fkNCACvOxNMatv6qdp/rMohNSHy17yS1uscl8vvIeSUaX8jP4ge9wgOLxytmPJEjitF+TXJSx0 Wp78qx90XdzcxQOjlCU3Qc/kgDpQzep2jTjCnDRpPFr2fzysYCI/GtseycU7UWDD7Og9CGwfxjY fM3nCULZyiCKmTPGSdvJNbkMV6zBpg+tKfaHBWi01MXMuaYbfU+6eOivr74KU2ApElooUsOAZK/ 0KAfqNGKKg6SdbpuT+7LaHzZ+LOCanBQqWRewAFD20OoJe1Od7jhaW9/Tu0eQBDcXGbBsd1NXjo wgRzgecgDWXeS/RPPI/YJXHn0MhJwIZQCaOqqDB6l8cdA07e
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: DD9986B2D5
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

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
index f83fb3cdc6ac..01e17a287a42 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -662,9 +662,10 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 	if (err)
 		return err;
 
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
+	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
 		goto sync_buffers;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
+	if (datasync &&
+	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
 		goto sync_buffers;
 
 	ret = sync_inode_metadata(inode, 1);
diff --git a/fs/libfs.c b/fs/libfs.c
index 1bbea5e7bae3..3a98dacd81b2 100644
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

