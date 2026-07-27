Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC83F8ED6
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149426; cv=none; b=WvQU3jC5ycqx6+jRRLIwOfZTJQy0bleskPkWKZCqMuFnmHjXUQcgx2w8RSZ36QSXaOZ0fbMvY3gOCLWLbYO+Ksmy25R/rlMgmxuB1eZOh+CQS1H2snbdoeSpXuEhkFQpcXt8pyPbl5/FRsYCpUVJV3lslozVnL641u1XVfcS2QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149426; c=relaxed/simple;
	bh=pc7NSyXUa2dRxQ+Ye8ddqTw3582ro7LVRcHjsWqLW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brvqKxWbHbB9qBAyslu/8fy/6MA65sV6+CNzF8G1MPFo4Do4KCUNcdLibwT6gspvQjGPtUZZbFJC+cIkFTfIfprZJyogXfKJ8BBjvQhDVt5GZeD4XLKKdWRYE4NFtgyoQ/8zJQaNvw04osDslMLU/pE7dyS63KHOrWzFAdJ5oIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1AOL8tnl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rl68Y1tK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QsPfgPhE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ChTes6Y/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1AOL8tnl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rl68Y1tK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QsPfgPhE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ChTes6Y/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F18B5214;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKGDtzKcdxLGKPX5+LwcaPd3eUF/+3It9Z9vsd8GGlA=;
	b=1AOL8tnl7k+gyQvKfTG+COPEXFu436sGhFMFBVPBFf35sWYk+wcVhR8Gc1tkJNgowgQjNn
	8+CVT7G/bj2C7/BY5ANrUjTKdpKa6AVCAQ0hXnL9hd48dst2lkmO9qY01LQCgNuTpFsXeG
	PCHZ09Nq/o4TOZ43c3gi0Mm6zSFK7BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKGDtzKcdxLGKPX5+LwcaPd3eUF/+3It9Z9vsd8GGlA=;
	b=rl68Y1tKBJdVdiDqsRm8sCepB8eViX1BHHUeUriLSDswRb2kMZt2cgYTO5P5u3ygowvSbY
	gZYMNqinlHfMu6DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKGDtzKcdxLGKPX5+LwcaPd3eUF/+3It9Z9vsd8GGlA=;
	b=QsPfgPhEekfoCmrKv3bjcL3TbXs3M4FQZFot9ON+pScTokMoQslP3X+UW0isL6jFg1EewT
	zFeWrojcaX6p9hAhm3kyYUNdh/QYgdkloFs1uHFlZlbraS02eHjshovX8B/gOcuK50v6DV
	iPELkpwZWHEAjmymOs5ecEAM5JAm0ec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKGDtzKcdxLGKPX5+LwcaPd3eUF/+3It9Z9vsd8GGlA=;
	b=ChTes6Y/LhE+neKQl7dLFbTvJpAluUmkr58QTKHM3ea7Vx2cjtmZ8/pbtUmOVD743T3tWL
	R8bUwILUboTjNODQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 054F5779CF;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FABLAcw3Z2oUawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 46277A1326; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH v5 06/20] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Mon, 27 Jul 2026 12:49:24 +0200
Message-ID: <20260727104923.3828017-26-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1941; i=jack@suse.cz; h=from:subject; bh=pc7NSyXUa2dRxQ+Ye8ddqTw3582ro7LVRcHjsWqLW88=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze3+stpQtY37/eaHutcWJHpabz5KYFr/6V2Y fcUiRSRn7OJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3twAKCRCcnaoHP2RA 2VJKCADnOsDoUmJhfDwREplXpB9FDKkcjJ8E2gcM/eLUV55ax1LZWNWH+BWzomve8qQMEo5mjhF 7n0rF8bKAvR1mE13V7hNJf3Epyz5I7HQrGjChUL0w2AoZ1vWtMhU8I8BQY7y3YnFPG1ILZ62Nqs iHSOagj7nhmJ20JyPUQ0pCSOTIdOWosSpqsD+Byta5pVLWluVFbTwfGS+AD3pNybyCEOCShBmw9 bTzIs5tbRv38F8TQSWzyZD/f9VUOH1B2A/v4y8rOpoHNICsrqz6MVXvjNDeRHeqCacpcYyeuNWa eKzImd9u4pS3ODcYNnJUix09//5rtwyw4ei8aGdKiBldZH0U
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

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

