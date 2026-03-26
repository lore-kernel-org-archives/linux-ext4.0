Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3D13D567F
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519076; cv=none; b=b2/Jm2xoiVilYuLCmYe7G7tNxjHRcEpdU9aPPv0O/+pFME8bmMKOM1ID8vEPdU7kgGbynw44canbgz0596+yg0gsaW7j2xCCK6dQsuVGMj9sIrT0RTpF+5ChsK+QPMiQfps3MIGEe0znd+F4OeqXFG2aJso57hDXmCgrx3WRpfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519076; c=relaxed/simple;
	bh=kczFWBDrNXD3v3KL6CDNGVgTbHR96KS6ROCKzE1gdWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uazNm91nCosLEkH4YXqjdX8zaaZepln4ldMWzE+4cR9TDbuj6hzahue6ZmaVzgjtHDjybaDKgly+JFct8Zf9anlug79eV3atakxYWx57VJfteB80Oui0d8gDG8tBD8uCDQDNYn+DmUoV+7ApPteHKhCKAlCgzbJsCZKezttIhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FVyp+ez+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nsTHCMg7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FVyp+ez+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nsTHCMg7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FVyp+ez+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nsTHCMg7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FVyp+ez+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nsTHCMg7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B42865BDCF;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=FVyp+ez+pMXnzdK8+F8utbKsqM5bcKxnRZkMYp55wzeBBTWuW7YpiqAgz6Zx4A7cqe8N7P
	0uR1dGPHNKEr40u7REjNkC2j6+C4YUgCg0yvuDGj7mefYmIM0BME0USG4FZaD+EM7TND5T
	DLBl+VWWKfSpFSjysEuAGdmo9zW1sQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=nsTHCMg7rXVFSNZ2deRaR9Tm3u3K1LeEc43pVcZNaTSn3rfpRu5eYBzLvcyod+EC+57HtP
	LyMsIYAlPh0m43BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FVyp+ez+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nsTHCMg7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=FVyp+ez+pMXnzdK8+F8utbKsqM5bcKxnRZkMYp55wzeBBTWuW7YpiqAgz6Zx4A7cqe8N7P
	0uR1dGPHNKEr40u7REjNkC2j6+C4YUgCg0yvuDGj7mefYmIM0BME0USG4FZaD+EM7TND5T
	DLBl+VWWKfSpFSjysEuAGdmo9zW1sQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=nsTHCMg7rXVFSNZ2deRaR9Tm3u3K1LeEc43pVcZNaTSn3rfpRu5eYBzLvcyod+EC+57HtP
	LyMsIYAlPh0m43BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D6BC4A0AA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id seVuJnUCxWkDYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EA686A0C81; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 41/42] fs: Drop mapping_metadata_bhs from address space
Date: Thu, 26 Mar 2026 10:54:35 +0100
Message-ID: <20260326095354.16340-83-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4216; i=jack@suse.cz; h=from:subject; bh=kczFWBDrNXD3v3KL6CDNGVgTbHR96KS6ROCKzE1gdWE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJV5o6IhQrEyprnjrzgx9i6umdkI04WMsthz y6BQtWQz9SJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVQAKCRCcnaoHP2RA 2V46CADd713L2KLLzIfEKJGU0LzA/74iOc36KYxJhqKKYXzlsKKTXpOfQNuiar3EQvQN92933lL 91llF3raE4SWXiQ0ztwuLxNJO3aJkozBQgIk+8I/NS5h+LeR+8uGDktdnc7JrOwMUvKaaJCi3Jy s6oTPbILGYX/5lFLSLFt3b3wKgYqfNFLrJioDL9aj5A0lS4QRdQLNhchN4OhsqjPsemR7V5ulB2 2LqBZXulu/PJhWwP2HD8HK9yAOnj+vrMcgUAWi4O7Yh3kgkVD+DSHRGgB2wnBlNPkIT004ngu50 H3cBfVW+JZzvZ5uYnBPBFyfjRjFI3HoBQSf1iJc6KHVt916g
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: B42865BDCF
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Nobody uses mapping_metadata_bhs in struct address_space anymore. Just
remove it and with it all helper functions using it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                  |  3 ---
 include/linux/buffer_head.h | 28 ----------------------------
 include/linux/fs.h          |  1 -
 3 files changed, 32 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3874b933abdb..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -276,7 +276,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
-	mapping->i_metadata_bhs.mapping = mapping;
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
@@ -484,8 +483,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	spin_lock_init(&mapping->i_metadata_bhs.lock);
-	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e207dcca7a25..e4939e33b4b5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,28 +207,10 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
-					   struct inode *inode)
-{
-	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
-}
 int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 		      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync_noflush(struct file *file,
-						loff_t start, loff_t end,
-						bool datasync)
-{
-	return mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
-				 start, end, datasync);
-}
 int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
 	      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync(struct file *file,
-					loff_t start, loff_t end, bool datasync)
-{
-	return mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
-			 start, end, datasync);
-}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -537,14 +519,6 @@ void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate(struct mapping_metadata_bhs *mmb);
 int mmb_sync(struct mapping_metadata_bhs *mmb);
-static inline void invalidate_inode_buffers(struct inode *inode)
-{
-	mmb_invalidate(&inode->i_data.i_metadata_bhs);
-}
-static inline int sync_mapping_buffers(struct address_space *mapping)
-{
-	return mmb_sync(&mapping->i_metadata_bhs);
-}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -555,8 +529,6 @@ extern int buffer_heads_over_limit;
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync(struct mapping_metadata_bhs *mmb) { return 0; }
-static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
 static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fa2a812bd718..ccfa696253c8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -491,7 +491,6 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
-	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0

