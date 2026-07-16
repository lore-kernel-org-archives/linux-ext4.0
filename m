Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06B03290AD
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213809; cv=none; b=HVgArfUJPBa17l856rrWLP8EhuzvXGOjew2P1oKIJigl7sDcI/LeChwuII8CdVnLGLIuqzK/9iBZjZItZe8rOwUX51xqLkVq4AsCpanBkx4Hh5XEotAhhDyv3ur7IO5uMkFGUbsQaKNqJinM33MHW5OwBmgRU7mRKULignNb8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213809; c=relaxed/simple;
	bh=xAARkvzY7PQPpzB6mjGtZVRMuXm5tBZNG5zqyTpkuAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5eB/oEuA9ttSpY3ZZTcVpJtbtU4Qzpb6R0GoexRIpg92com882XMsCToDieeMcrOGRbepTPqK0b6FfjYRR1ZYtFRQqkt4jj4NFpY62u49Htt9UZT5KYkQ9AidQCCIcGzCTLIz7IrFNxEX80YQaUvh1HU8JhEHfkvs60iEOqRzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA77C789D6;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B356A779AF;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 69vHKwXxWGoOXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9079CA0B3B; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 12/21] udf: Drop udf_sync_inode()
Date: Thu, 16 Jul 2026 16:55:34 +0200
Message-ID: <20260716145527.3580300-33-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1944; i=jack@suse.cz; h=from:subject; bh=xAARkvzY7PQPpzB6mjGtZVRMuXm5tBZNG5zqyTpkuAw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDpmYSqx2h7bpqMyOUdYEBJ/T+rdYpeU4TWI dbNy5/kXQmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw6QAKCRCcnaoHP2RA 2eoDCADn/Fw55QG0h/CQs9kZgQPFxCIQvsBFq1MaWVjoxEA3aI+r0lKlM5n1C1xbJn55vLE/1vx E94S0TP5pUWjTmAop7FvjgEbdq+JqIYCVD79WGlP0krMcTBMZhpxiVRc6A0OXi4cpbetJU0VA6N V+bbGN4/4VA5y4UvEq8/jJzVU1a1gF4YOb24hh2xPBJCy4H4CSFbRoDFiFLvN8mjGZrIbur14Q0 3e6LJeQOyLGQ6/KcTu42K5DqhxKFQzFpoj2daAW/Kh7pej43SdGRnerT2gF4KcxB03uT0q2hDfj 409IPPEHDYFHAUTsv6YwKzE48OCBt0Hj+EsfHQ+T274ABRJO
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: BA77C789D6
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

The only place using udf_sync_inode() is now inode_getblk() for flushing
IS_SYNC inodes after write and page_mkwrite allocating blocks. For write
the flushing is actually taken care of by generic_write_sync() so it
isn't needed here. For page_mkwrite it does have effect however none of
the other filesystems seem to bother with flushing IS_SYNC inode on page
fault and properly synchronizing such writeback with standard inode
writeback would be slightly complex due to locking constraints. So just
drop IS_SYNC inode handling from inode_getblk().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 600705f5edf9..c751a02d865c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -52,7 +52,6 @@ struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
-static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -938,10 +937,7 @@ static int inode_getblk(struct inode *inode, struct udf_map_rq *map)
 	iinfo->i_next_alloc_goal = newblocknum + 1;
 	inode_set_ctime_current(inode);
 
-	if (IS_SYNC(inode))
-		udf_sync_inode(inode);
-	else
-		mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	ret = 0;
 out_free:
 	brelse(prev_epos.bh);
@@ -1733,11 +1729,6 @@ int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
-static int udf_sync_inode(struct inode *inode)
-{
-	return udf_update_inode(inode, 1);
-}
-
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)
 {
 	if (iinfo->i_crtime.tv_sec > time.tv_sec ||
-- 
2.51.0

