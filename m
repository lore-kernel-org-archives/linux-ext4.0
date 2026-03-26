Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B23C3453
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519048; cv=none; b=NzZJdDHDPsfmJIJSAxLyhhoHect/O0jM0cmZq54fsRPXv/On2seVyzqFvRafFZcjjkyPmy0MOIgejlV121Vi0y/nYiGmZ8NkTxMs9HZGST6OEQTdgwZngYJAlBWK/mL5EccI32i3RTYpmYIN0nqYeGPYcDIyUrHmAar0ABYUj3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519048; c=relaxed/simple;
	bh=9xBH/IqErKiIiNqWXJjy809lW/6/4LgxYE6Bk76CpFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb8pP9m5wV0HHlQgVIMUKW+soSLICHJk6Oxan8O5m4ayA3fSxtk7kBbJIpmqyD6fqJ1zZh43sXJepdM/O/kwARG0LlYwyZBmyfuwzMVWE7Y41DjJhOwcqdMw4soglfD/p+dPWqyCjN/FtfP2h0lVfwzbk3n8L4SRFvLY8Y5ensY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yjkZaXGO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKCdYjPu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yjkZaXGO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKCdYjPu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yjkZaXGO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKCdYjPu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yjkZaXGO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKCdYjPu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A79DB4D2AD;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=yjkZaXGOf8YRShUXbyxUW7cbiFEoOK+76pi6ZrmpY0lnRn0QZQ/hgyHjpUcw1l7jrD2GqS
	5qzct4bTvOfzLIydO+6bE0bx75qEmS8ylgIa0LgtP3M+o6/0MPgSWUpr1vgrHuf/BS6E+M
	0xsKWDxYtCdZ1uISd/mhg1QBVEIwgK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=XKCdYjPu1A+14grGsWLA549acStjCWsj38dAoJd3igr7p1zts8guCf6yPs21oSj4UnmPNV
	2GY07oSk2Yx0nvBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=yjkZaXGOf8YRShUXbyxUW7cbiFEoOK+76pi6ZrmpY0lnRn0QZQ/hgyHjpUcw1l7jrD2GqS
	5qzct4bTvOfzLIydO+6bE0bx75qEmS8ylgIa0LgtP3M+o6/0MPgSWUpr1vgrHuf/BS6E+M
	0xsKWDxYtCdZ1uISd/mhg1QBVEIwgK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=XKCdYjPu1A+14grGsWLA549acStjCWsj38dAoJd3igr7p1zts8guCf6yPs21oSj4UnmPNV
	2GY07oSk2Yx0nvBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D2B14A0A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zwBeJnUCxWkBYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0CECA0C80; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 40/42] ext4: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:34 +0100
Message-ID: <20260326095354.16340-82-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3926; i=jack@suse.cz; h=from:subject; bh=9xBH/IqErKiIiNqWXJjy809lW/6/4LgxYE6Bk76CpFo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJUDID/ZAUL5XAy2UizNNky/Yki15nrbCzj2 38rMkVQuT6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVAAKCRCcnaoHP2RA 2Q2WB/9Y928g9eFz58LRsc7RHaB+gGxibmuIx9F4zAB0qmKEX9gGTCMxnwDKNE/J7SLaANuTjQ+ wvjW0OF0ds2gDehs56OIrYWGMpaBdqvzevym1o7KzaxxETjrgxj30OVGsWktpoyVFa0LBkvi84q n0cJ7AOIx0+nhwv9zXYIdX4mzhNjaym5qZXiK6zx4+mHr0O5Zimy0L4O2BdnnXCRcVZZAMhDHc8 xnlbnSIgtS7bC1QYftSWEnHPj/futMxcn/hV0gk4ovjAi/4bUHeTn+xXzbAJk2k9GA4jJ+skwcN MZdLjqeBm6eOr8AIIdhljKhyPfNmFfyqCVnQxyj0YDx77YIF
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

Track metadata bhs for an inode in fs-private part of the inode. We need
the tracking only for nojournal mode so this is somewhat wasteful. We
can relatively easily make the mapping_metadata_bhs struct dynamically
allocated similarly to how we treat jbd2_inode but let's leave that for
ext4 specific series once the dust settles a bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      | 1 +
 fs/ext4/ext4_jbd2.c | 3 ++-
 fs/ext4/fsync.c     | 5 +++--
 fs/ext4/inode.c     | 4 ++--
 fs/ext4/super.c     | 3 ++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..8df3617fd0e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1121,6 +1121,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
+	struct mapping_metadata_bhs i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 05e5946ed9b3..9a8c225f2753 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -390,7 +390,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 	} else {
 		if (inode)
-			mark_buffer_dirty_inode(bh, inode);
+			mmb_mark_buffer_dirty(bh,
+					      &EXT4_I(inode)->i_metadata_bhs);
 		else
 			mark_buffer_dirty(bh);
 		if (inode && inode_needs_sync(inode)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e476c6de3074..aa80af2b4eea 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -68,7 +68,7 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		ret = sync_mapping_buffers(inode->i_mapping);
+		ret = mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
 		if (ret)
 			break;
 		ret = sync_inode_metadata(inode, 1);
@@ -85,7 +85,8 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	struct inode *inode = file->f_inode;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = mmb_fsync_noflush(file, &EXT4_I(inode)->i_metadata_bhs,
+				start, end, datasync);
 	if (!ret)
 		ret = ext4_sync_parent(inode);
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 011cb2eb16a2..c9fd1d17b492 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -187,7 +187,7 @@ void ext4_evict_inode(struct inode *inode)
 		truncate_inode_pages_final(&inode->i_data);
 		/* Avoid mballoc special inode which has no proper iops */
 		if (!EXT4_SB(inode->i_sb)->s_journal)
-			sync_mapping_buffers(&inode->i_data);
+			mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
 		goto no_delete;
 	}
 
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
+	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea827b0ecc8d..31f787a65fac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,6 +1428,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 	return &ei->vfs_inode;
 }
 
@@ -1525,7 +1526,7 @@ void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
 	if (!EXT4_SB(inode->i_sb)->s_journal)
-		invalidate_inode_buffers(inode);
+		mmb_invalidate(&EXT4_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0

