Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB47D3B19C8
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014225; cv=none; b=Q0w3Up5ILMTt2KKbKBuTgSQqaXozzlzc5qPvah472bgGx3Qs7cOoYlClHmYQPqw8wPBUSJqPZmR+iMMY2Srn80K//RbCf84YJQkzxbcufFgBIIU7FmGowY6/oc6xzAKVmLJEDR3e7ggzYhU0AGsdUkgWl7Zrp0dOl1EfQLdkYmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014225; c=relaxed/simple;
	bh=beWcTFMo3xvmeZcELnyVzz5p7d17vMDEbuj+XGoJTGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3w40jkY0pmeM3RIMxnbWuNINlK4SB3n6RfDnxVhr+QlSMgfHpjl6FzYHYqajsc5NxvOro2OXaMgiI7VAdeoQrh/ipH7tgOpDYYmZNmK8CKhuQJQfhTsUZfngu2Wc5ES7weUlzy5MKrsRQB39JinUhqyF8yvLkiPtHvoXh2sOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8E205BEED;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D36694281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9OaM5lOvWmdCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A2264A0B4E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 39/41] fs: Drop mapping_metadata_bhs from address space
Date: Fri, 20 Mar 2026 14:41:34 +0100
Message-ID: <20260320134100.20731-80-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4303; i=jack@suse.cz; h=from:subject; bh=beWcTFMo3xvmeZcELnyVzz5p7d17vMDEbuj+XGoJTGQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6N3nyo6jZfnTL8nbHGxRtbREYDoVsN0vFRJ hx52+5XCqOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjQAKCRCcnaoHP2RA 2dCRCADFC4KBTHW3tpd5qhQrVvE35UqOKOGz3dm5r9QSRXNIO2N9IYPLesVt6q5TcVyISeuPfds Gu85B8TMPuDiSWdWC6NhUU7ru3Jk31sLgIh7gT0PIUGLklwN6QSdIMUo95ZFHf+jD6Y7ggzgZw6 /t/jFK3Sy+spg0XTb/qERl+GbjjA6keBO4OUdoRMWqJLScJ+pU5LD1txYrHAovRm/Q0ey+Le8dG vjp7TBVAGCpLZQAZyAvZdbXLbQX0Pyu9km1OvcVBg80rekgaBC1VQEdm+e2SqlBj+dQw3d81Y1c /kH5tL5QbBRZXj29Ryy1oMZakHOKqCo/mLEOTvUkj28FqKU1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: E8E205BEED
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
index 399277c679eb..74fcc9a03c32 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,29 +207,11 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
-					   struct inode *inode)
-{
-	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
-}
 int generic_mmb_fsync_noflush(struct file *file,
 			      struct mapping_metadata_bhs *mmb,
 			      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync_noflush(struct file *file,
-						loff_t start, loff_t end,
-						bool datasync)
-{
-	return generic_mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
-					 start, end, datasync);
-}
 int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
 		      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync(struct file *file,
-					loff_t start, loff_t end, bool datasync)
-{
-	return generic_mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
-				 start, end, datasync);
-}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -538,14 +520,6 @@ void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb);
 int mmb_sync_buffers(struct mapping_metadata_bhs *mmb);
-static inline void invalidate_inode_buffers(struct inode *inode)
-{
-	mmb_invalidate_buffers(&inode->i_data.i_metadata_bhs);
-}
-static inline int sync_mapping_buffers(struct address_space *mapping)
-{
-	return mmb_sync_buffers(&mapping->i_metadata_bhs);
-}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -556,8 +530,6 @@ extern int buffer_heads_over_limit;
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync_buffers(struct mapping_metadata_bhs *mmb) { return 0; }
-static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
 static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4ab53ec36ab..d2122e1c9a3f 100644
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

