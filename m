Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B774339D6D4
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534167; cv=none; b=tUpRH5VM2LnrkKd6Of9EqRTQxeIIGVDrMx3lcOlrrnuERf+0UHMVJjma+0iZEO4Chmg3T6DmN5aFmJNJ6ru/gFGNQ2/KcE8dVCN7dcZzfKY9MXQrcGzpM3mYArJUGPjpnmzoBpGfKf5VL5MhY6XJitZe2i/kXKj3ouaKkXODNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534167; c=relaxed/simple;
	bh=t1ZJ98uKW/mjTlAtf9li2hXoonFOHXZVBOd5Czf0muc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZO++ZlYQ7HYs/eodlHCKUq45kJAJFG5w8YX90jXN7ctWFDEq74TlIswaBJp6uadRBk42KpunTIFB+ANTk5PsFknzyVIBlwwFGo5rnlAWOyAPiD/jMkEwviAlY+moFeVJFRNG1SSn7tRyTB0ZqCpR7VG/Kz2gEEepayUXHqhiL1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B47A5BE33;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EC693EA6C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nHwKG0W5pmmfFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 463E1A0B7F; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 30/32] vfs: Drop mapping_metadata_bhs from address space
Date: Tue,  3 Mar 2026 11:34:19 +0100
Message-ID: <20260303103406.4355-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2964; i=jack@suse.cz; h=from:subject; bh=t1ZJ98uKW/mjTlAtf9li2hXoonFOHXZVBOd5Czf0muc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk32Wxql2wtTkldVHgQyouf3CalCsOswKYUJ sSpBtaI5ZGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NwAKCRCcnaoHP2RA 2SkZCADLjRuMocQoKB6Huvda5j98SKmeWKpdEXSnbq26Ng0XEuFXFEkxnuwzhg3/zoIHhmJ4hc6 V2x3XgNJZSxtORfX7CMU9xit+xaKCRcpNW9XK+JYjmdSi1y+fpqzHqbceOtPnNoQ9mzDrwKvdlL ve8qnUNotEyH3DKsaPJZrUlEzq3PhCKJT7eyQysuSqgketXfzetTdLN/njPfReA9nq313q4VcY1 fu8RNYPFC3XPNFCxJ4zzXqLgd1zNmR0LYEx+DY0QIx2tVT1cXHujtkjbfRUTxHLUcv762X7+ynw CGVtg9VV4BMqYPOi2NyaIcF1JYncPuqXu1OiAsCjU8N9DXpc
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 7B47A5BE33
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Nobody uses mapping_metadata_bhs in struct address_space anymore. Just
remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c        | 16 ++++++++++------
 fs/inode.c         |  2 --
 include/linux/fs.h |  1 -
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 096a8d9e3280..02176e0acfe1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -501,9 +501,13 @@ EXPORT_SYMBOL(mmb_init);
 
 static struct mapping_metadata_bhs *inode_get_metadata_bhs(struct inode *inode)
 {
+	/*
+	 * We can get called for various half-initialized or bad inodes so
+	 * verify .get_metadata_bhs callback exists.
+	 */
 	if (inode->i_op->get_metadata_bhs)
 		return inode->i_op->get_metadata_bhs(inode);
-	return &inode->i_mapping->i_metadata_bhs;
+	return NULL;
 }
 
 static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
@@ -544,7 +548,7 @@ static void remove_assoc_queue(struct buffer_head *bh)
 
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&mmb->list);
+	return mmb && !list_empty(&mmb->list);
 }
 EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
@@ -552,10 +556,10 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
  *
- * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
- * that I/O. Basically, this is a convenience function for fsync().  @mapping
- * is a file or directory which needs those buffers to be written for a
- * successful fsync().
+ * Starts I/O against the buffers tracked in mapping_metadata_bhs for the
+ * mapping and waits upon that I/O. Basically, this is a convenience function
+ * for fsync().  @mapping is a file or directory which needs those buffers to
+ * be written for a successful fsync().
  *
  * We have conflicting pressures: we want to make sure that all
  * initially dirty buffers get waited on, but that any subsequently
diff --git a/fs/inode.c b/fs/inode.c
index 393f586d050a..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -483,8 +483,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	spin_lock_init(&mapping->i_metadata_bhs.lock);
-	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b4d9be1fefa4..1611d8ce4b66 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -490,7 +490,6 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
-	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0

