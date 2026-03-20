Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E9C2BDC2C
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014219; cv=none; b=ijjTLcgqd+Sy6lsJbVmRVvWUZm/DFkzeU1B8IzB3OBn+l3k8JdC2qsLOtF8oyJCbYEQFo83TKazTLrETVrjMW7c8TOHUOeTmvN+XKcRUc+M8OmL3TkpJlkKZHiR83WGqsBH+zfEAto9PwhixLH6Gf35/K3kGd98q1XvevQoloj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014219; c=relaxed/simple;
	bh=kco4mMHMCu2Pwd3rYZWTfCMsG7pi8zl424DiRirRcYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e07p/5cHBg4lWITUKPS4btvaoEaIg9P3TK9MPjR0sidVxPIakAXmibfOkf9+LnnKc64eTnbW6/FGOI/ziYl1ycK6zVMBy6p14yy4TO8utBaTFx89RDBmvwhg7wsrbkCqmat2VPtiBOFS2TNGya5EvwRt0ieHYWyb29scp0gH7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8C2D4D42C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF2074281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yUqPMplOvWmbCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9B113A0B39; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 38/41] ext4: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:33 +0100
Message-ID: <20260320134100.20731-79-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3959; i=jack@suse.cz; h=from:subject; bh=kco4mMHMCu2Pwd3rYZWTfCMsG7pi8zl424DiRirRcYE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Nre7P5GSgcR81h46uXaYRZ3y8iudX4lYbQ HtS2Pl3DaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjQAKCRCcnaoHP2RA 2apACADlaFBjlOXx5jrVVABkN1BRkBxU7ssZcdHQ1iKN6Ov0pNwjjPprzPqlG0G7e1JGZ3Dzkaa iO3GzHmneAuYbk4ADjXONW8UCdbYjzu1tLSZCuG5r2M39x/ls9Zt9h6O1Qv/2YqDKBcIZdstb7u zgzdqx8buKuOC3KpgkEONigG7bRMcHB2Im6hj283rg1pI2tocljGuAOCH5XtfsZIP4jXW5VRXBR /oHZQKFPIF6jZib9eMJ9PCVsl6XVk72s/qJd9rszpVDphy7eWUx98LvpBu3GA1kH6+zmv5gFDHi OIM7+KFlc0KlQdl1YN+OoHXLkPv7Eyvobd3Z6WAb4bIEs87O
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: D8C2D4D42C
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9)]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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
index e476c6de3074..709c403273aa 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -68,7 +68,7 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		ret = sync_mapping_buffers(inode->i_mapping);
+		ret = mmb_sync_buffers(&EXT4_I(inode)->i_metadata_bhs);
 		if (ret)
 			break;
 		ret = sync_inode_metadata(inode, 1);
@@ -85,7 +85,8 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	struct inode *inode = file->f_inode;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = generic_mmb_fsync_noflush(file, &EXT4_I(inode)->i_metadata_bhs,
+					start, end, datasync);
 	if (!ret)
 		ret = ext4_sync_parent(inode);
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 011cb2eb16a2..abc17ef0c9ee 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -187,7 +187,7 @@ void ext4_evict_inode(struct inode *inode)
 		truncate_inode_pages_final(&inode->i_data);
 		/* Avoid mballoc special inode which has no proper iops */
 		if (!EXT4_SB(inode->i_sb)->s_journal)
-			sync_mapping_buffers(&inode->i_data);
+			mmb_sync_buffers(&EXT4_I(inode)->i_metadata_bhs);
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
index ea827b0ecc8d..1b2b4ad62a10 100644
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
+		mmb_invalidate_buffers(&EXT4_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0

