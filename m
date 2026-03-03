Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1279039B966
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534161; cv=none; b=SdMgn6K4AajKI08qdQhrZBsGttKjiDwlzTNLno+AL+fW1OpZA3+6PZOt7rpLMhsut5kgoSQ3MQFElEj1IS+7ie2t4W3z5zYzHzBtDvVC8UKCWjPogG8brBszySpCltJrKlxSUvupeVeZvx24saRiG0KmB71xG94ojA7ESgj05Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534161; c=relaxed/simple;
	bh=jRmpGnBIbXf3zwY1aurODz7DyXpIxnDKpqd2BEFflmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLt5+cIaO1z95cqZhlY36OpKGOFche26At2cfntzzGuudUAPYaXHbejIfECVFd4oAHMliSGZpNsgVQoyggn+wVsx+ZOcI4euhS1lmb6KhuQvYx1Ir3Cg2hZTjvM9UWj5zAYJybtuT7fMq73VOIO0U5COWMzVOflVX9M7A69aBdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 799795BE32;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F60B3EA6D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X3QwG0W5pmmkFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4FCEEA0B80; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 31/32] kvm: Use private inode list instead of i_private_list
Date: Tue,  3 Mar 2026 11:34:20 +0100
Message-ID: <20260303103406.4355-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=jack@suse.cz; h=from:subject; bh=jRmpGnBIbXf3zwY1aurODz7DyXpIxnDKpqd2BEFflmQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk4KwaWC8zyZ0s7V4lXzGzsQQHzPJJwD80C1 Zy1LnL7DwCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5OAAKCRCcnaoHP2RA 2bSEB/4h+viVsZtNldyok/qfyaKtPMr65DkOGhl1KBx7viW8XI3Jg99sH6b3b3LJxhWsD9vznvj UsjvvKMXRVTrRUop/xmuCm0BR1+F43XCOLruCIBpImghBT+yCdN6hwjrSt8o0FV+rt0vQw8vx/f RHup/w4Zcn4OtRHiDFDeXptIhUSdoXGB8f8kPQdk84DfGagyjnHpMuGomYGOCIBxeBkSz5Lr1ab aBP6abWoi4dzSvs94Obdaa2A/Mh9W55p8/Y0fG3fuiiUL3gISlSfYdTHFWqlUTqCBIGT9vLdJ/A 8rK1AUNHQXNplQIZTpWM1Gjo94jV/z0zzc/zI4qnNuETqgbt
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 799795BE32
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

Instead of using mapping->i_private_list use a list in private part of
the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 virt/kvm/guest_memfd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..6d36a7827870 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,7 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+	struct list_head gem_file_list;
 
 	u64 flags;
 };
@@ -39,8 +40,8 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
-#define kvm_gmem_for_each_file(f, mapping) \
-	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+#define kvm_gmem_for_each_file(f, inode) \
+	list_for_each_entry(f, &GMEM_I(inode)->gem_file_list, entry)
 
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
@@ -202,7 +203,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
@@ -223,7 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 {
 	struct gmem_file *f;
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
@@ -609,7 +610,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
-	list_add(&f->entry, &inode->i_mapping->i_private_list);
+	list_add(&f->entry, &GMEM_I(inode)->gem_file_list);
 
 	fd_install(fd, file);
 	return fd;
@@ -945,6 +946,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	INIT_LIST_HEAD(&gi->gem_file_list);
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0

