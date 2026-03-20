Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70897317171
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014164; cv=none; b=lqNL0/bEy5m7AejQqoT4e35tC9fMSykIp25cVkIElwSdn7RrTWk+mwFZ9fYrudkxc/8uLQN89i0AHJZY5yx6aD7oQ/59kzbSRvrwdFjA0vg14vxvVD96TEZXl4HTZoXSFHyp1uTTGGn8xb5dB7AYGyzL45ZtmfTt70kyIGSPcZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014164; c=relaxed/simple;
	bh=ei9DWvxNUOA+Oc2Fqc3sajLvM+z4f9VHF0jmEE/iXJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd2aGvcLLyblPr/TD+H46vBhXV4oyv8HImXJiCC3gFWrPqYjz8bMFcyG2xRAkwehtI299VgZQFB8GWbUPjcKLhtKsewYbHw9Qa6xt2eEoq/Durqnj1Xj33QwpKTSxP2KxA3dXH8RxvG4TG41b8RM4DFOHL40fazEi4pSE+J5kj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iGDkbC3T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UW/nILKd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iGDkbC3T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UW/nILKd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iGDkbC3T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UW/nILKd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iGDkbC3T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UW/nILKd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D6724D295;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=iGDkbC3TguVpc9x2TaHn3C7kICYSCScxr2q3PEBd81G4txT8jDRVEbn0SzfvjnIpuEmPex
	Dr4rj8NR0FeddJtcodZKchExNMeyUhPVIeHhhviU/FHwai7za0xeqQr63kpBdhUFEyfegq
	tj+nBH2Bue8Fpk6ifPm9hCwIlYrbxwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=UW/nILKdQOU42hie44SeI16+UAR74nyedUhHNm7ncdtBWOEmlJWXRgZI62MMsh6iwAAMP8
	o5nutzcZxYLtogBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=iGDkbC3TguVpc9x2TaHn3C7kICYSCScxr2q3PEBd81G4txT8jDRVEbn0SzfvjnIpuEmPex
	Dr4rj8NR0FeddJtcodZKchExNMeyUhPVIeHhhviU/FHwai7za0xeqQr63kpBdhUFEyfegq
	tj+nBH2Bue8Fpk6ifPm9hCwIlYrbxwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=UW/nILKdQOU42hie44SeI16+UAR74nyedUhHNm7ncdtBWOEmlJWXRgZI62MMsh6iwAAMP8
	o5nutzcZxYLtogBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63ECB4281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZPViGJlOvWl7CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11880A0A81; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 22/41] hugetlbfs: Stop using i_private_data
Date: Fri, 20 Mar 2026 14:41:17 +0100
Message-ID: <20260320134100.20731-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3135; i=jack@suse.cz; h=from:subject; bh=ei9DWvxNUOA+Oc2Fqc3sajLvM+z4f9VHF0jmEE/iXJU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5/W3YOBHarNBWcT2Vha4q+EAh76n0VqIP38 rGiDPH41pCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfwAKCRCcnaoHP2RA 2WZYCAC/vIK/RR/oIV+YY1l6eoQR1fUYsao5JPpNuTmerMjTswzrkcs7cTugxN70XNnb0AFZUWQ 4QDYqKN0CPvnS6XxBo+HeqfNoVSqGpeC95J9MsvxoTxRS8PibHe/LkhA5mh525XIZCDPLbwFA38 9xaLnCgO7UM42NZ5oawYmhNWSdpMBVQArUc51iV/NBjIljAafSPy0Y0OySfCWPQ0flpvl2CAdYK 7/ufeo6278Is9wxFmbj8nny5zIpCgnPFnXUZ7NuU1KWtyhxDZ11MxXxEr/RKgQ4+iRHqOczCA2p xHp4MxixPmQ9hfaeM1q5PAkPMuYuBw5DICxFJ8Bk0t2O2O73
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
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

Instead of using i_private_data for resv_map pointer add the pointer
into hugetlbfs private part of the inode.

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

