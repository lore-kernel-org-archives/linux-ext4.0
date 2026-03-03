Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9839B965
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534119; cv=none; b=eHLrlGczqELTiu1OuYD+9HVitPfB3Xr9Fj9wu7musZXeeNFvnSjgDg/KRA3A/CBVJOrYZirfqk2Zc+g3ZF7n6V4BD48lZ/bSrjtg/LOPQmGr84gPgvW4gQNlDyFMX/ZlLTz9ZmpDzFN8UNBXcnT6c3ujTnxgciG6xO+3czhSLSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534119; c=relaxed/simple;
	bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd32nZrp2Q+pW7uDp7az2Zlsp9AnuXhn6Dv+D6WFEanzzMRU+SFosjL9hqlzFcFBMqy2/FseimxZCJj0Ja3C9MAIP9h6o+NrZ9MRaWs78W5tckT8xlSOzlBqhglwFPgeDymBW5y0SBv23prq11saLZGZrmdqCAtD1mAJyye0zJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 18AEC5BE21;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0612E3EA72;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Zx0AUW5pml1FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B7201A0AAA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 14/32] fs: Remove i_private_data
Date: Tue,  3 Mar 2026 11:34:03 +0100
Message-ID: <20260303103406.4355-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1510; i=jack@suse.cz; h=from:subject; bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDKX7dT065ga7rhq2VKrJX7nHe39/7zbtUahecZ7L+W2+ WeEtZOfdjIaszAwcjDIiimyrI68qH1tnlHX1lANGZhBrEwgUxi4OAVgIl5rOBg+2HvtSMtctuXI 5Y+JO5YV6J9vLV94yWqe7WObnA079NPfdna0eK+VOBstVSebEBa0WXabZKAGd6XCaeNK+Wifm/e d0sVlPzhnK1wzvbwl9Ul30QuGjxYJX3a/OXHQfckZs0OG/2aucGdtO3rOJeVI19b57uddrkgeqG +ubdZpFhb00zO+LButkJi9Q/PJHU2NsMlW+79HGqSssQq8KBmg8fkTa6rcnRRZ4UJHpizfGZ71w Stl5CQ2Srx2P3Te+Ukye0x9nnht1I6PLk4Bx26wvHh1tSiYa26i5bv6J5bfVO7whVlGbK6SbP1S +Ytne1aLzPKMZw7WbmF5va5BB7jVnxhMTlm+5uEOx+/JAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 18AEC5BE21
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

Nobody is using it anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 1 -
 include/linux/fs.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4f98a5f04bbd..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -283,7 +283,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	atomic_set(&mapping->nr_thps, 0);
 #endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
-	mapping->i_private_data = NULL;
 	mapping->writeback_index = 0;
 	init_rwsem(&mapping->invalidate_lock);
 	lockdep_set_class_and_name(&mapping->invalidate_lock,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..10b96eb5391d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -465,7 +465,6 @@ extern const struct address_space_operations empty_aops;
  * @wb_err: The most recent error which has occurred.
  * @i_private_lock: For use by the owner of the address_space.
  * @i_private_list: For use by the owner of the address_space.
- * @i_private_data: For use by the owner of the address_space.
  */
 struct address_space {
 	struct inode		*host;
@@ -486,7 +485,6 @@ struct address_space {
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
-	void *			i_private_data;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
-- 
2.51.0

