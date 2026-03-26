Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9D3C6616
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519000; cv=none; b=tLgLpjooLC2aDNKPpRNcgUn/lt+KqnjQewvp/8Ql5AysrTzxnaXB4m7gfsBSXv2QCQf0SMAKOff0JXMoUNY7rJvWXlKZ0Jd56LasaG3zEPV4n4wo8pdjUgT6omXxj+Bo6ZagC6Q9S60zxS00sZyzDJ/wLkQ/IR65yfAD977xzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519000; c=relaxed/simple;
	bh=1Pb/adcwW6xrIXddFLxPoaBb/An4k4KZgPxdu6Dhu5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOcAgDKKGUmwq8OnnTmL7r5Y8BKenuC1n9m3rHwa8oA8m2PYv5ptgHU4d2ABzKPD/IpFSOZUfOH5sB47xz3Ld1NXoMNH0bD49QlPa2ndNVhvO4PLpnbnxzG4izd4nw8xrPywfGH+rzTWtwqzcjWbBgCScTyW8PxK8gSffRA54oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PchJBn/u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aIlNik5a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PchJBn/u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aIlNik5a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PchJBn/u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aIlNik5a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PchJBn/u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aIlNik5a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DB974D28C;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=PchJBn/uiTvq9JPs5YdpwIpkGADAGywcq/XzSfN5A7bIcADmY5EWFUSCRI+46yQ97gsr2Q
	ihOXWFEHPrMiKIy2YR375+wv2hN84FzbSR4sC4OAW5GSkSkOu2RPjJkdQPD+hjAQWg/dq2
	TVp38BnsaShR2F8A10l6IIcE4DdG3NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=aIlNik5at9LkIhV28LQPBrMgymP0PX67T/TWqbRKdECkYcZR1k/97LdqV+W8M8E6hzEylR
	dJnaNV8NL2QKYmCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=PchJBn/uiTvq9JPs5YdpwIpkGADAGywcq/XzSfN5A7bIcADmY5EWFUSCRI+46yQ97gsr2Q
	ihOXWFEHPrMiKIy2YR375+wv2hN84FzbSR4sC4OAW5GSkSkOu2RPjJkdQPD+hjAQWg/dq2
	TVp38BnsaShR2F8A10l6IIcE4DdG3NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=aIlNik5at9LkIhV28LQPBrMgymP0PX67T/TWqbRKdECkYcZR1k/97LdqV+W8M8E6hzEylR
	dJnaNV8NL2QKYmCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57F924A0AA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BRF/FXUCxWndYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 38E91A0C69; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 22/42] fs: Ignore inode metadata buffers in inode_lru_isolate()
Date: Thu, 26 Mar 2026 10:54:16 +0100
Message-ID: <20260326095354.16340-64-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5025; i=jack@suse.cz; h=from:subject; bh=1Pb/adcwW6xrIXddFLxPoaBb/An4k4KZgPxdu6Dhu5I=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJFtk+WjKSBCWGAdpRK2Za/U9zFgKL/kcR2N V0iH9fht2mJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRQAKCRCcnaoHP2RA 2SnUCACuln/mI/PxPsTv31M30XutA1/xSOjmZ6AQO5K2A1ahrTHIc0T70YSIapvlrknLfBNNsEM pUmqJhBfFrBLrRIr2GxeChP5WbLAx33I8aSZ6pP1F5Xu1Ph8NDy1nHWGd2WDJXV1Ro51K4Fqipo Z7wUaHwo+fMOL4UlMdl1dUh14YMPFGWUbwFNac9YgfNoyE/zRXTE3UHHluxIKPba9kxbTgsq7a8 IlPCMFbgoV7W7WTFtBbFS4/lhyAnK9nZ6ZKLkTAgSmWZi5R05jR+o0yn4eSCa4LVI1haR/vKgfw eTFQcSXs+/djg9oah1jPy1yABt2NMFqxn5ZtEkTR5mgUS4w4
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
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such the logic to reclaim tracked metadata
buffer heads in inode_lru_isolate() doesn't bring a benefit big enough
to justify intertwining of inode reclaim and metadata buffer head
tracking. Just treat tracked metadata buffer heads as any other metadata
filesystem has to properly clean up on inode eviction and stop handling
it in inode_lru_isolate(). As a result filesystems using generic
tracking of metadata buffer heads may now see dirty metadata buffers in
their .evict methods more often which can slow down inode reclaim but
given these filesystems aren't used in performance demanding setups we
should be fine.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 29 -----------------------------
 fs/inode.c                  | 21 +++++++++------------
 include/linux/buffer_head.h |  3 ---
 3 files changed, 9 insertions(+), 44 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1bc0f22f3cc2..bd48644e1bf8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -878,35 +878,6 @@ void invalidate_inode_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL(invalidate_inode_buffers);
 
-/*
- * Remove any clean buffers from the inode's buffer list.  This is called
- * when we're trying to free the inode itself.  Those buffers can pin it.
- *
- * Returns true if all buffers were removed.
- */
-int remove_inode_buffers(struct inode *inode)
-{
-	int ret = 1;
-
-	if (inode_has_buffers(inode)) {
-		struct address_space *mapping = &inode->i_data;
-		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
-
-		spin_lock(&buffer_mapping->i_private_lock);
-		while (!list_empty(list)) {
-			struct buffer_head *bh = BH_ENTRY(list->next);
-			if (buffer_dirty(bh)) {
-				ret = 0;
-				break;
-			}
-			__remove_assoc_queue(bh);
-		}
-		spin_unlock(&buffer_mapping->i_private_lock);
-	}
-	return ret;
-}
-
 /*
  * Create the appropriate buffers when given a folio for data area and
  * the size of each buffer.. Use the bh->b_this_page linked list to
diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..4f98a5f04bbd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -17,7 +17,6 @@
 #include <linux/fsverity.h>
 #include <linux/mount.h>
 #include <linux/posix_acl.h>
-#include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
 #include <linux/iversion.h>
@@ -367,7 +366,6 @@ struct inode *alloc_inode(struct super_block *sb)
 
 void __destroy_inode(struct inode *inode)
 {
-	BUG_ON(inode_has_buffers(inode));
 	inode_detach_wb(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
@@ -994,19 +992,18 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * page cache in order to free up struct inodes: lowmem might
 	 * be under pressure before the cache inside the highmem zone.
 	 */
-	if (inode_has_buffers(inode) || !mapping_empty(&inode->i_data)) {
+	if (!mapping_empty(&inode->i_data)) {
+		unsigned long reap;
+
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&lru->lock);
-		if (remove_inode_buffers(inode)) {
-			unsigned long reap;
-			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
-			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
-			else
-				__count_vm_events(PGINODESTEAL, reap);
-			mm_account_reclaimed_pages(reap);
-		}
+		reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
+		if (current_is_kswapd())
+			__count_vm_events(KSWAPD_INODESTEAL, reap);
+		else
+			__count_vm_events(PGINODESTEAL, reap);
+		mm_account_reclaimed_pages(reap);
 		inode_unpin_lru_isolating(inode);
 		return LRU_RETRY;
 	}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e..631bf971efc0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -517,7 +517,6 @@ void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
 int inode_has_buffers(struct inode *inode);
 void invalidate_inode_buffers(struct inode *inode);
-int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
@@ -528,9 +527,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
-static inline int inode_has_buffers(struct inode *inode) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
-- 
2.51.0

