Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEAB3C060E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518979; cv=none; b=dLc8OMgzRDhZfipnEFg5VJCukJCxtWNYWzk55QRCiZvjDYrS/UngN49i8R/1ft4kD3cdaLxt/OJluU/GfNZqpWK7eYWtyZ0XxFaWxBdYjxATdHVPc+gUo4/05OJyr/fI4in3lExgYEHDX8PCs1ShhW6WBkotRXlIqWDD8OB5kkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518979; c=relaxed/simple;
	bh=TBJAp1vgW97AnNsMKdc/36W2ae98JPtniWixMTAK+B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz1nXSYOOZoXHhPJ8oe8o/fl6bM/k2JbpyrsVvvbzUZhVSj6h6GH0aElv6rmypL0aQcLpFWBV5zXiUAk5HLI6Xd0ZwJjDacJ0PHFGd8AA0L/rgyrRSKqbfCj1g5XYKGVsvuRFp0EXQxCzpNXIto6n0OAvhovLcSg/mbmrk8eU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g/uLEo7r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1pa9WfLm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g/uLEo7r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1pa9WfLm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g/uLEo7r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1pa9WfLm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g/uLEo7r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1pa9WfLm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6953D4D283;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=g/uLEo7rXGrXHjkOzxqornYwO8D55hnybzSnvHf833t+3wYkpRy9Xo8XKdJahdOSvFwIWD
	VXeCcf7JE6FctkRkxZ53+CkZumAI5qtGdkniM/WZKLrjx2csNiHapmKERHPcNyV6svYgZK
	YuZYsIW+LgxeZTS7+JqMXWFI9n0278I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=1pa9WfLmFomg1L5oozQ22D1QK+lBooEk1mMezvcCzeBd+FqvWHJk0BeIWAc8GYsqDJyxa/
	vSfxw7SImiU1PYAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/uLEo7r";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pa9WfLm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=g/uLEo7rXGrXHjkOzxqornYwO8D55hnybzSnvHf833t+3wYkpRy9Xo8XKdJahdOSvFwIWD
	VXeCcf7JE6FctkRkxZ53+CkZumAI5qtGdkniM/WZKLrjx2csNiHapmKERHPcNyV6svYgZK
	YuZYsIW+LgxeZTS7+JqMXWFI9n0278I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=1pa9WfLmFomg1L5oozQ22D1QK+lBooEk1mMezvcCzeBd+FqvWHJk0BeIWAc8GYsqDJyxa/
	vSfxw7SImiU1PYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F3AC4A0AC;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sng+F3UCxWniYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C273A0C6B; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/42] hugetlbfs: Stop using i_private_data
Date: Thu, 26 Mar 2026 10:54:18 +0100
Message-ID: <20260326095354.16340-66-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3180; i=jack@suse.cz; h=from:subject; bh=TBJAp1vgW97AnNsMKdc/36W2ae98JPtniWixMTAK+B0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJGM589kUVC1RTs2x8EL+jKz9oU8EvkUQbFu rSC+eSRsTWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRgAKCRCcnaoHP2RA 2WjUCADE/11pgV1euunYPZejUo+EZ2IERerdr6bsaog5c+u38VVLzeV0BYVat0T9gAevVwwCkqM 1CqsKuiU9mK1rhYsqnlUI/NuF1zX0AGuGuf2HCnG+VqAE3GzgVDfEISrOpTWIxuIKCaWNwhytTi 3LP+HW/e4zs+18qAZnQvCvQdbGS1TxzqOJowuX3nmePKSxNsUnNZ9ty2jzeIWsJ5FuF0tWFoFVc 9/vV2Z3SUGFzejWTV1tl9PrTz4Itm4p5gOex4oO0EHOKi/fN25s4s0bsGV1JPYeJ+Jcw3CGD964 GiXNOqg6RfLB9u0KfhHYVum8ltGUKOwfWHLwbxpn8vvN79Lz
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,lst.de];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6953D4D283

Instead of using i_private_data for resv_map pointer add the pointer
into hugetlbfs private part of the inode.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c    | 11 +++--------
 include/linux/hugetlb.h |  1 +
 mm/hugetlb.c            | 10 +---------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..6ad02493adfd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -622,13 +622,7 @@ static void hugetlbfs_evict_inode(struct inode *inode)
 	trace_hugetlbfs_evict_inode(inode);
 	remove_inode_hugepages(inode, 0, LLONG_MAX);
 
-	/*
-	 * Get the resv_map from the address space embedded in the inode.
-	 * This is the address space which points to any resv_map allocated
-	 * at inode creation time.  If this is a device special inode,
-	 * i_mapping may not point to the original address space.
-	 */
-	resv_map = (struct resv_map *)(&inode->i_data)->i_private_data;
+	resv_map = HUGETLBFS_I(inode)->resv_map;
 	/* Only regular and link inodes have associated reserve maps */
 	if (resv_map)
 		resv_map_release(&resv_map->refs);
@@ -907,6 +901,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		inode->i_op = &hugetlbfs_dir_inode_operations;
 		inode->i_fop = &simple_dir_operations;
+		HUGETLBFS_I(inode)->resv_map = NULL;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
 		lockdep_annotate_inode_mutex_key(inode);
@@ -950,7 +945,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 				&hugetlbfs_i_mmap_rwsem_key);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		simple_inode_init_ts(inode);
-		inode->i_mapping->i_private_data = resv_map;
+		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
 		switch (mode & S_IFMT) {
 		default:
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..fc5462fe943f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -518,6 +518,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
+	struct resv_map *resv_map;
 	unsigned int seals;
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..2ced2c8633d8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1157,15 +1157,7 @@ void resv_map_release(struct kref *ref)
 
 static inline struct resv_map *inode_resv_map(struct inode *inode)
 {
-	/*
-	 * At inode evict time, i_mapping may not point to the original
-	 * address space within the inode.  This original address space
-	 * contains the pointer to the resv_map.  So, always use the
-	 * address space embedded within the inode.
-	 * The VERY common case is inode->mapping == &inode->i_data but,
-	 * this may not be true for device special inodes.
-	 */
-	return (struct resv_map *)(&inode->i_data)->i_private_data;
+	return HUGETLBFS_I(inode)->resv_map;
 }
 
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
-- 
2.51.0

