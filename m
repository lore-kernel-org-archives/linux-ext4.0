Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CD3BC664
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014201; cv=none; b=AxIkPJzq2+G9wmo1WTGniYLRGjzo6rlDewnjl+ix5jnPAmP+3W7A0MPxcYaq2BMYEc77zNZuMhQ8fDPzZxYSiIHUqQwgT8EY9scjj3kEectbJeLjb0O+npU4dLC2TAXOlzQuu855cOuIIFiiGU/9G75iivAgxmkqPDit7q4jSTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014201; c=relaxed/simple;
	bh=aRvj4AtIW+ddyd7UxwbPw41jZ9lNjYBY0OWJr0OT+ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/px+cjiwi5sY4qjtCkkLOu0doFbiurJMzkhcav8Sg5HJcKCQH6OVh29a8uFV+FqqfC1uY/qrDszkj/khH1f0XJAUx+Vw2bdZP+irrUnT7zcBUDwQUBqq5lMuN7VhMzXcDFYIVkLD8OJjhyGZFoCcs5COa/LlFbbx8oIr3+3vy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m8G9ent1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Do5n+BIc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m8G9ent1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Do5n+BIc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m8G9ent1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Do5n+BIc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m8G9ent1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Do5n+BIc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B68B04D428;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=m8G9ent18Hr51S1MO1GBbVci/SYlK4Kp8G1jWCTdhZ8frR9mmzB2sL2eIlN/GTCgNvujKx
	HModd3zoGtxodt/x5nsb0Yirzk5I4ze9y3T6Q2ey/Qz2H95v0PrE8HG2UDOAZDSA4WPC2C
	m6SVRclEgNeM7qyxf2U0NMpTusdZSXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=Do5n+BIcfQAoPpkKy3HZRs2YApSdH88Wfu4p+tkWC9Iikehe16RlRty+TsOfez5Pl3bM5R
	RAXC/iMOfHISsNDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=m8G9ent18Hr51S1MO1GBbVci/SYlK4Kp8G1jWCTdhZ8frR9mmzB2sL2eIlN/GTCgNvujKx
	HModd3zoGtxodt/x5nsb0Yirzk5I4ze9y3T6Q2ey/Qz2H95v0PrE8HG2UDOAZDSA4WPC2C
	m6SVRclEgNeM7qyxf2U0NMpTusdZSXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=Do5n+BIcfQAoPpkKy3HZRs2YApSdH88Wfu4p+tkWC9Iikehe16RlRty+TsOfez5Pl3bM5R
	RAXC/iMOfHISsNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EA5E4281F;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fCC6JplOvWmNCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A2DAA0B3C; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 32/41] ext2: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:27 +0100
Message-ID: <20260320134100.20731-73-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4156; i=jack@suse.cz; h=from:subject; bh=aRvj4AtIW+ddyd7UxwbPw41jZ9lNjYBY0OWJr0OT+ZQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6H7CaeB32tQjJNhqeawy4/l/6sm7mJJ+IL7 /s5ToIoGN+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhwAKCRCcnaoHP2RA 2QHZB/9+wZG/S4W1bL987nyIE4g21LzXGKf9ozYzcj8lrO9KHnal5LDi+7tfr41ET2QNORSkw59 VEih7xn49DZ6lmBCFxEVSI2NVIIay/Ua741x+g7dpohVclYnboKtLzwA/VA7f+uzLLabH/7kR0y ITGOB3aUTQtUGVad7mt6AtAnP8CjTx5DtJW3AHiLEneIBPz5JP0G9AwqJYJA5UgxdQ+fgqfnnsY gSMpr7IJ0BNofn+Yo8l4CsG90EJ+Qh3FLEFaG1IulNx5CfxHqKopZOgJ70HZ99wKMs6PtYQ+Tzn ZjfFJFrg0CDLrvhw3ZZs/Gm33X8VLAf9aZOn/OspsJ5fv1e0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  |  6 ++++--
 fs/ext2/inode.c | 16 +++++++++-------
 fs/ext2/super.c |  1 +
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e0c6c5fcb6c..3eb1f342645c 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -676,6 +676,7 @@ struct ext2_inode_info {
 #ifdef CONFIG_QUOTA
 	struct dquot __rcu *i_dquot[MAXQUOTAS];
 #endif
+	struct mapping_metadata_bhs i_metadata_bhs;
 };
 
 /*
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ebe356a38b18..629133f0e8ae 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -156,9 +156,11 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int ret;
-	struct super_block *sb = file->f_mapping->host->i_sb;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
 
-	ret = generic_buffers_fsync(file, start, end, datasync);
+	ret = generic_mmb_fsync(file, &EXT2_I(inode)->i_metadata_bhs,
+				start, end, datasync);
 	if (ret == -EIO)
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fb91c61aa6d6..dfed87fbbccd 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -95,9 +95,9 @@ void ext2_evict_inode(struct inode * inode)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync_buffers(&EXT2_I(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate_buffers(&EXT2_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	ext2_discard_reservation(inode);
@@ -527,7 +527,7 @@ static int ext2_alloc_branch(struct inode *inode,
 		}
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &EXT2_I(inode)->i_metadata_bhs);
 		/* We used to sync bh here if IS_SYNC(inode).
 		 * But we now rely upon generic_write_sync()
 		 * and b_inode_buffers.  But not for directories.
@@ -598,7 +598,7 @@ static void ext2_splice_branch(struct inode *inode,
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
-		mark_buffer_dirty_inode(where->bh, inode);
+		mmb_mark_buffer_dirty(where->bh, &EXT2_I(inode)->i_metadata_bhs);
 
 	inode_set_ctime_current(inode);
 	mark_inode_dirty(inode);
@@ -1211,7 +1211,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 		if (partial == chain)
 			mark_inode_dirty(inode);
 		else
-			mark_buffer_dirty_inode(partial->bh, inode);
+			mmb_mark_buffer_dirty(partial->bh,
+					      &EXT2_I(inode)->i_metadata_bhs);
 		ext2_free_branches(inode, &nr, &nr+1, (chain+n-1) - partial);
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
@@ -1220,7 +1221,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 				   partial->p + 1,
 				   (__le32*)partial->bh->b_data+addr_per_block,
 				   (chain+n-1) - partial);
-		mark_buffer_dirty_inode(partial->bh, inode);
+		mmb_mark_buffer_dirty(partial->bh,
+				      &EXT2_I(inode)->i_metadata_bhs);
 		brelse (partial->bh);
 		partial--;
 	}
@@ -1303,7 +1305,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (inode_needs_sync(inode)) {
-		sync_mapping_buffers(inode->i_mapping);
+		mmb_sync_buffers(&EXT2_I(inode)->i_metadata_bhs);
 		sync_inode_metadata(inode, 1);
 	} else {
 		mark_inode_dirty(inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 603f2641fe10..4118a3a1f620 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -215,6 +215,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
-- 
2.51.0

