Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248342A783
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213773; cv=none; b=pG24brsSS/XxjYwGuKtWSPApbDBmVNfxpm1Wq6im39hNiVLIZINvj23PnwTSDNigKdvgBjXxrIeQeuiWoHllIvq+r+qbHiB36PeOtZTpQ79+T93klFBHJHXeN8J5j1yPgmhGNhJ8fpAkOC+OKFttx6a8IFNiq/dD29HDQOl950A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213773; c=relaxed/simple;
	bh=pc7NSyXUa2dRxQ+Ye8ddqTw3582ro7LVRcHjsWqLW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wr+pZE9CK8kVzr9w+h8k7uT3BFkmHh/yBwmFll1YhU3Zk3i2hVeoCknHPijoZZnuugrImxeLkISRSD+wezA3YW0nNrrhZG++Wf2u2LFkbEHDpE/HH2PRk5dzvmlgUJ/BAhge1r/SfQNx+ZZQd0IiT/Y+GyCRoxNuoQvwONE/FEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4EEBE3E41;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FBF0779AF;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oo2GD/3wWGrqXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 731E2A09B7; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH v4 06/21] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Thu, 16 Jul 2026 16:55:28 +0200
Message-ID: <20260716145527.3580300-27-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1941; i=jack@suse.cz; h=from:subject; bh=pc7NSyXUa2dRxQ+Ye8ddqTw3582ro7LVRcHjsWqLW88=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDk+stpQtY37/eaHutcWJHpabz5KYFr/6V2Y fcUiRSRn7OJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw5AAKCRCcnaoHP2RA 2TnNB/9qOc8a0qJWhcohEex1kd1fUPbRe7DhfmlsQSxP4ovmZCbCV08f3+KQJQqUyb7vd5iMBq4 BWykjRRVqJhAgc/iYlLwUFV06ncCWCLkKUKwpueaUqd5M90xFJfZs9hEidQSz0JiwuYlQ/3EDPw 12Im6Pekrqr2+OwUX5LY+oqzvWBuo+gofhnHRP07yZwZMp8S+HqbF+CQ15xDorG7mlnchQWcP/p TAhqUKwq9FiyXx1pSGS8aF4BA4Qi/+Z0iw4/geGmvWLo340z2EXi51wAJm6sXscVBO3SJE3LhGq PL2m1KyWvtWxV97YAnke010I8404ZaWDyHBj/719YNchHzdM
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
X-Rspamd-Queue-Id: 4EEBE3E41
X-Rspamd-Action: no action

ext2_setsize() and ext2_xattr_set2() had a construct like:

	if (IS_SYNC(inode)) {
		sync_inode_metadata(inode, 1);
	} else {
		mark_inode_dirty(inode);
	}

which leads to lost inode updates for IS_SYNC inodes because
sync_inode_metadata() does anything only if the inode is already dirty
and hence inode updates may be simply lost. Fix the problem by
unconditionally marking the inode dirty and *then* call
sync_inode_metadata().

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 7 ++-----
 fs/ext2/xattr.c | 4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..269b1c9fba5f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1258,12 +1258,9 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (inode_needs_sync(inode)) {
-		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
+	mark_inode_dirty(inode);
+	if (inode_needs_sync(inode))
 		sync_inode_metadata(inode, 1);
-	} else {
-		mark_inode_dirty(inode);
-	}
 
 	return 0;
 }
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index e55d16abf422..be63f89402a3 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -777,6 +777,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 	/* Update the inode. */
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode_set_ctime_current(inode);
+	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
@@ -789,8 +790,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			}
 			goto cleanup;
 		}
-	} else
-		mark_inode_dirty(inode);
+	}
 
 	error = 0;
 	if (old_bh && old_bh != new_bh) {
-- 
2.51.0

