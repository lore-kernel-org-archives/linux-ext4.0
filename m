Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FECC3C6602
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519009; cv=none; b=KY8QzNFBXCw9CggbduCnKtnc6ET98fKh68PVANIlsVkGKHG1+SRU1XKJcRtlLYIl/z1jOhqZZ2YZwJ3+THlHWJ54AsG/RN8FnmcOwxKH3WjdO+UrOwhFA9SwxSvdLdaxOYRBV3W4FcD7sWB5nSSDi3WyR1G44B6LDJ0ftEZ8T2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519009; c=relaxed/simple;
	bh=uVsvQms5MSP6UW8c94a/Bcx7tH8LCDpqwFuYUMFVOS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpHFIbq3CwjA1Toy3vdmXlIScctrKLnY9DpVxxHAegEXvT0nSBR2hT4cM29NlyokjGFzqumFpMHyOTCkk0rWH10eqeAuWXYnvJA8AILGnSUHhwl+o6IU2k6DHWpXoY0Hp30BSW1TQdPf21cTDz6MhviGipB3PhPceifZeGT+PJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lzzUdzV2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EOzE3ciK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lzzUdzV2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EOzE3ciK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lzzUdzV2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EOzE3ciK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lzzUdzV2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EOzE3ciK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 734C15BDB2;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=lzzUdzV2vdw2G2ghZ3B7l+mibIyjeFDNh5AsYT0cktGv0jpIy6vBaVi5/LQZqy3O9at1oT
	qjl/55Blgpz4alFlLiAA5ZD52rXg3HcQQ4hjS7BwPVFSR2EaQ2UAPySHnCkp4d0KgVwkun
	V074UuMFTZUqnniaTVPZlQQkgmN4Al4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=EOzE3ciKzBBY4WRr+N5saYe2MAEvWXgadAbymraGD22syxh0/EIw0TmojrYNzjR2e0n+Qi
	QiCgtYUt1HM4WgDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lzzUdzV2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EOzE3ciK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=lzzUdzV2vdw2G2ghZ3B7l+mibIyjeFDNh5AsYT0cktGv0jpIy6vBaVi5/LQZqy3O9at1oT
	qjl/55Blgpz4alFlLiAA5ZD52rXg3HcQQ4hjS7BwPVFSR2EaQ2UAPySHnCkp4d0KgVwkun
	V074UuMFTZUqnniaTVPZlQQkgmN4Al4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=EOzE3ciKzBBY4WRr+N5saYe2MAEvWXgadAbymraGD22syxh0/EIw0TmojrYNzjR2e0n+Qi
	QiCgtYUt1HM4WgDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B7664A0AB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vdNUFnUCxWnfYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5524AA0C6F; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 25/42] aio: Stop using i_private_data and i_private_lock
Date: Thu, 26 Mar 2026 10:54:19 +0100
Message-ID: <20260326095354.16340-67-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4933; i=jack@suse.cz; h=from:subject; bh=uVsvQms5MSP6UW8c94a/Bcx7tH8LCDpqwFuYUMFVOS0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJHfYlHyc9pyzhKqNzmG959AJLLRBSkxfd4J Ho8ddDoFKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRwAKCRCcnaoHP2RA 2e8LCADcX1JyhPYjfxFhFW3duvVAeolbUfDR/BpFBNlNo5wZwydfZeev+OUkldm98o5mdtThpsL v0jrRtf8BmUmm0MxMdnBUPIVz9boOFYRhsUI3I9h1V3E0T2ZODwmJnJDbnWuhiHHJLkfBzuFnaV RM1nmxsYeCqhY2NuIEDD7GRDZGbp2sFH0pg/HtcYtnZX5F1XDsVvQFlVM374jifOKCbXiq2TBNZ EBxAtmpfnPCWGnEEU5aOUI45y2rjH504PTJsYKT3vMTyiH8OLckfHoC8tJJozjKipdkjahiroy6 AYavddh5lPgcPMd0KN/CFO0xMAbxdrjdUl5KEG4Iyf6gTp7A
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
X-Rspamd-Queue-Id: 734C15BDB2

Instead of using i_private_data and i_private_lock, just create aio
inodes with appropriate necessary fields.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index a07bdd1aaaa6..ba9b9fa2446b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -218,6 +218,17 @@ struct aio_kiocb {
 	struct eventfd_ctx	*ki_eventfd;
 };
 
+struct aio_inode_info {
+	struct inode vfs_inode;
+	spinlock_t migrate_lock;
+	struct kioctx *ctx;
+};
+
+static inline struct aio_inode_info *AIO_I(struct inode *inode)
+{
+	return container_of(inode, struct aio_inode_info, vfs_inode);
+}
+
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 static unsigned long aio_nr;		/* current system wide number of aio requests */
@@ -251,6 +262,7 @@ static void __init aio_sysctl_init(void)
 
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
+static struct kmem_cache	*aio_inode_cachep;
 
 static struct vfsmount *aio_mnt;
 
@@ -261,11 +273,12 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 {
 	struct file *file;
 	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
 	inode->i_mapping->a_ops = &aio_ctx_aops;
-	inode->i_mapping->i_private_data = ctx;
+	AIO_I(inode)->ctx = ctx;
 	inode->i_size = PAGE_SIZE * nr_pages;
 
 	file = alloc_file_pseudo(inode, aio_mnt, "[aio]",
@@ -275,14 +288,49 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	return file;
 }
 
+static struct inode *aio_alloc_inode(struct super_block *sb)
+{
+	struct aio_inode_info *ai;
+
+	ai = alloc_inode_sb(sb, aio_inode_cachep, GFP_KERNEL);
+	if (!ai)
+		return NULL;
+	ai->ctx = NULL;
+
+	return &ai->vfs_inode;
+}
+
+static void aio_free_inode(struct inode *inode)
+{
+	kmem_cache_free(aio_inode_cachep, AIO_I(inode));
+}
+
+static const struct super_operations aio_super_operations = {
+	.alloc_inode	= aio_alloc_inode,
+	.free_inode	= aio_free_inode,
+	.statfs		= simple_statfs,
+};
+
 static int aio_init_fs_context(struct fs_context *fc)
 {
-	if (!init_pseudo(fc, AIO_RING_MAGIC))
+	struct pseudo_fs_context *pfc;
+
+	pfc = init_pseudo(fc, AIO_RING_MAGIC);
+	if (!pfc)
 		return -ENOMEM;
 	fc->s_iflags |= SB_I_NOEXEC;
+	pfc->ops = &aio_super_operations;
 	return 0;
 }
 
+static void init_once(void *obj)
+{
+	struct aio_inode_info *ai = obj;
+
+	inode_init_once(&ai->vfs_inode);
+	spin_lock_init(&ai->migrate_lock);
+}
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
@@ -294,6 +342,11 @@ static int __init aio_setup(void)
 		.init_fs_context = aio_init_fs_context,
 		.kill_sb	= kill_anon_super,
 	};
+
+	aio_inode_cachep = kmem_cache_create("aio_inode_cache",
+				sizeof(struct aio_inode_info), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_ACCOUNT),
+				init_once);
 	aio_mnt = kern_mount(&aio_fs);
 	if (IS_ERR(aio_mnt))
 		panic("Failed to create aio fs mount.");
@@ -308,17 +361,17 @@ __initcall(aio_setup);
 static void put_aio_ring_file(struct kioctx *ctx)
 {
 	struct file *aio_ring_file = ctx->aio_ring_file;
-	struct address_space *i_mapping;
 
 	if (aio_ring_file) {
-		truncate_setsize(file_inode(aio_ring_file), 0);
+		struct inode *inode = file_inode(aio_ring_file);
+
+		truncate_setsize(inode, 0);
 
 		/* Prevent further access to the kioctx from migratepages */
-		i_mapping = aio_ring_file->f_mapping;
-		spin_lock(&i_mapping->i_private_lock);
-		i_mapping->i_private_data = NULL;
+		spin_lock(&AIO_I(inode)->migrate_lock);
+		AIO_I(inode)->ctx = NULL;
 		ctx->aio_ring_file = NULL;
-		spin_unlock(&i_mapping->i_private_lock);
+		spin_unlock(&AIO_I(inode)->migrate_lock);
 
 		fput(aio_ring_file);
 	}
@@ -408,13 +461,14 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 			struct folio *src, enum migrate_mode mode)
 {
 	struct kioctx *ctx;
+	struct aio_inode_info *ai = AIO_I(mapping->host);
 	unsigned long flags;
 	pgoff_t idx;
 	int rc = 0;
 
-	/* mapping->i_private_lock here protects against the kioctx teardown.  */
-	spin_lock(&mapping->i_private_lock);
-	ctx = mapping->i_private_data;
+	/* ai->migrate_lock here protects against the kioctx teardown.  */
+	spin_lock(&ai->migrate_lock);
+	ctx = ai->ctx;
 	if (!ctx) {
 		rc = -EINVAL;
 		goto out;
@@ -467,7 +521,7 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 out_unlock:
 	mutex_unlock(&ctx->ring_lock);
 out:
-	spin_unlock(&mapping->i_private_lock);
+	spin_unlock(&ai->migrate_lock);
 	return rc;
 }
 #else
-- 
2.51.0

