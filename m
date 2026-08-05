Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF947ECEB
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944197; cv=none; b=G2T+oGVpZ1lGka8WOV/zEZBXh57oi4V5CKRDjko32Wj/cVlA6KLY2FEphXV6RoVWaJyEbzZkNOuJGjooUPVOsHPvKkZ/vKF96zdliAntns/D2ttpHLa0BVSe64sHx2P+BP5TQZc/4DE6XE/A0s4UGibXZL1vsdV5lTjHhUFTHiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944197; c=relaxed/simple;
	bh=oiVpudP7gWkB1qegOb3A9HyeBApYBvnm7lZV/lsXYBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C63r/B15seGUcGmVUNMUq/fjxUCw6h3JQIIIlUdpBUAQ2HOJG3sBqTLRYg3dU3sF189Tlfqu2OfFF3gR9+sVeiIvYRetlFUW7LfBpZGT+/LZVth429t/9tjE6glGdCqftffYv+Eh8GBV7BDVLjJy1n2274R1qX/+XsziILrt6os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hC9I3u7j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hwpSCzRH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X2+VH6zA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rzRwQVGh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hC9I3u7j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hwpSCzRH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X2+VH6zA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rzRwQVGh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ADE2C3DF2;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dho3obm/0YKAIQk9WzKD7QDxeomtaYil6iM2X62IAa0=;
	b=hC9I3u7jwAyQeVlmEsx0xU+/qZ8cgChNOpDJoKDdRUX4PFJLZlCp0Ms95MnNbwVXuBAuJE
	Hka2VOSaFZ0t77Kp3N+/kkn036uve8kIPBxP4xa4S2cZIDIs38+z2eQKfBoTYrF5yAxbav
	sZayBJde+K8pgl1bv1XFZB9HhXX0wXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dho3obm/0YKAIQk9WzKD7QDxeomtaYil6iM2X62IAa0=;
	b=hwpSCzRHwaIHLYihlv7fbq2nFoKgvLesPqzXuSped3xWntz/lTKkx1aWBW6YFhzVTu+veS
	4DESFEh5QRIj3/Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dho3obm/0YKAIQk9WzKD7QDxeomtaYil6iM2X62IAa0=;
	b=X2+VH6zAJN4ZPun1NOrGYNKPE7u3RdT1RhkFoFlwQxKvHBBRBW4LlkLns7T7d6EsAxipUY
	axaWQaeLyeJ/h6Y3qf/62xUm8pZnu7sXfkQDCKwzqzRCywo6Y2tzwWMnZ+KFv6FoGacH2P
	oHL66Vlonkl5StBPUA8oXouQf+kGV9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dho3obm/0YKAIQk9WzKD7QDxeomtaYil6iM2X62IAa0=;
	b=rzRwQVGhb8RTHdAaszOU1zHuEQFxQnixQxcWIt7Km1WhOurfH3hHjsT1BRgCIir039Qpjb
	wZMfx1JEpa2M5DCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9586E779C3;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s+1/JHJYc2r5LwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 15:36:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58BAAA13B1; Wed, 05 Aug 2026 17:36:18 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] ext4: Teach ext4_meta_trans_blocks() about number of allocated extents
Date: Wed,  5 Aug 2026 17:35:47 +0200
Message-ID: <20260805153605.166545-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260805153202.29814-1-jack@suse.cz>
References: <20260805153202.29814-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5016; i=jack@suse.cz; h=from:subject; bh=oiVpudP7gWkB1qegOb3A9HyeBApYBvnm7lZV/lsXYBk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqc1hl16jwuqSCPxfxrC4+QqZ510Wjwk9SosPFq Zi45wGJ4y+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanNYZQAKCRCcnaoHP2RA 2ULRCADQQNp5n7zV+GvxMICDedQQpbwyHMQcIovxnnI8KTAMcu62A3JbKNjrWoZlWJpBU35Cn4H EVXIpT4da+o2MZuhSz5ifWcSK6I3Dn3Z/k2byiVPrbTCp0kfU8mYKoDUNEPCo0p6zHag9R6rObt +23p6W4f+011ffpv92zlu1mbQF4MF8Ak2UvYs4M300gQQQVKAw678eatxRI9wyRsCQjtclnI2X4 iI0ESc7jwqDlIqP8HWQrlNjW0TVeyBrMLYw3/KpTUlfNIQJa8DoE83nbt7wPsazpHnPVAsVz2FZ 7ajIpq+vnIUj7tEP1TA7CRYVPCmbqdnIHxeCX10oxPD3y0I5
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux.alibaba.com,huawei.com,linux.ibm.com,gmail.com,suse.cz];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

So far ext4_meta_trans_blocks() expects that each extent counted in
@pextents will be allocated in the transaction we estimate credits for.
This is correct for the use in ext4_chunk_trans_blocks() and
ext4_chunk_trans_extent() however the use in atomic write path
(ext4_convert_unwritten_extents_atomic() and ext4_iomap_alloc() for
IOMAP_ATOMIC) unnecessarily overestimates the number of necessary
credits as neither of them allocates any data. Add argument to
ext4_meta_trans_blocks() for number of extents that are going to be
allocated in the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   | 32 +++++++++++++++++---------------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..6e0cc9b845ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3184,7 +3184,7 @@ extern int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
-				  int pextents);
+				  int pextents, int alloc_extents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
 				    loff_t length, bool *did_zero);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b31..44ab246a3176 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4976,7 +4976,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
 		 * it can tell if the extent in the cache is a split extent.
 		 * But for now let's assume pextents as 2 always.
 		 */
-		credits = ext4_meta_trans_blocks(inode, max_blocks, 2);
+		credits = ext4_meta_trans_blocks(inode, max_blocks, 2, 0);
 	}
 
 	if (credits) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..f324a54f1dae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3693,9 +3693,11 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 		if (ret < 0)
 			return ret;
 		if (map->m_len < orig_mlen) {
+			int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
+
 			map->m_len = orig_mlen;
-			dio_credits = ext4_meta_trans_blocks(inode, orig_mlen,
-							     map->m_len);
+			dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
+							     map->m_len, 0);
 		} else {
 			dio_credits = ext4_chunk_trans_blocks(inode,
 							      map->m_len);
@@ -6307,17 +6309,17 @@ static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
 }
 
 /*
- * Account for index blocks, block groups bitmaps and block group
- * descriptor blocks if modify datablocks and index blocks
- * worse case, the indexs blocks spread over different block groups
- *
- * If datablocks are discontiguous, they are possible to spread over
- * different block groups too. If they are contiguous, with flexbg,
- * they could still across block group boundary.
- *
- * Also account for superblock, inode, quota and xattr blocks
+ * Calculate number of credits needed in a transaction to:
+ *   * Allocate data blocks from @alloc_extents different groups - note that
+ *     with flexbg a single physical extent can span multiple groups but
+ *     single mballoc request only returns extent within one group.
+ *   * Allocate metatadata (extent tree blocks, indirect blocks) to store
+ *     pointers to @pextents data extents having @lblocks in total.
+ *   * Modify extent tree / indirect block tree, inode, superblock, quota
+ *     tracking, xattr blocks
  */
-int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
+int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents,
+			   int alloc_extents)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
@@ -6334,7 +6336,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
 	 * Now let's see how many group bitmaps and group descriptors need
 	 * to account
 	 */
-	groups = idxblocks + pextents;
+	groups = idxblocks + alloc_extents;
 	gdpblocks = groups;
 	if (groups > ngroups)
 		groups = ngroups;
@@ -6360,7 +6362,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
 {
 	int ret;
 
-	ret = ext4_meta_trans_blocks(inode, nrblocks, 1);
+	ret = ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
 	/* Account for data blocks for journalled mode */
 	if (ext4_should_journal_data(inode))
 		ret += nrblocks;
@@ -6378,7 +6380,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
  */
 int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
 {
-	return ext4_meta_trans_blocks(inode, nrblocks, 1);
+	return ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
 }
 
 /*
-- 
2.51.0

