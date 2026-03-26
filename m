Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E33C277E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519009; cv=none; b=rKfqhs1Hqfi4pZV4orGEU+zjmrRH57pGDyS68asB7+fZU27IEGwpgTvys9LZNs3yLxfwEifTuHBEzPbYzePJ8kvgnK9X5iHJUsZvelMiZBRmVkrx0pqjmhEoE9azRGmD8IpOIJRtClFWdqOVYHp+u14ygv70akdK66ySzDoSLg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519009; c=relaxed/simple;
	bh=aaS3p7rYcU0Djxp6pNN/3QR5Enbcvk2UVb3ATJEe+lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvnndmUubnBtxAdY3jMeuoa1fuIVjY9j7ERgPOTWYo360cfa/gfZdGIaL6Y2Bix2jZeQT6uQ+5/fh5GY/B6Rd4NMrRDtxPW0jcROWt4J2lINGO9FQ4mKCwYQHablR41QJONzlddgSOc9hY0cIn655Di69gSHykgRVSDZkq9NrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zgt/l9+e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8A+6Hkn1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zgt/l9+e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8A+6Hkn1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zgt/l9+e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8A+6Hkn1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zgt/l9+e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8A+6Hkn1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74D914D290;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=zgt/l9+e3mgqkjhkBnOUuRm97r6GDo1AfibEJkUrEhq7SnHGNx1QvI2jjk0NaF25QrfpvS
	h2bdq5xnoUrO5e5PURzk2I7tai0vSttkQWaa9oGKqQdq/Fj9cuvw5TlzrUhOXJJxr6o1f8
	UFeUXep4f7Qy1yU4GwBU4NFsLLHJGfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=8A+6Hkn1rDDsoC70xT/ljIRRuHCer32hiMeLWs+kleav6oLDTZ1e8mzAiVzDLHpifeO/cZ
	bHZiHE3y384uoIDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zgt/l9+e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8A+6Hkn1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=zgt/l9+e3mgqkjhkBnOUuRm97r6GDo1AfibEJkUrEhq7SnHGNx1QvI2jjk0NaF25QrfpvS
	h2bdq5xnoUrO5e5PURzk2I7tai0vSttkQWaa9oGKqQdq/Fj9cuvw5TlzrUhOXJJxr6o1f8
	UFeUXep4f7Qy1yU4GwBU4NFsLLHJGfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=8A+6Hkn1rDDsoC70xT/ljIRRuHCer32hiMeLWs+kleav6oLDTZ1e8mzAiVzDLHpifeO/cZ
	bHZiHE3y384uoIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 697184A0AD;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPZyGXUCxWnmYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5EF50A0C70; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 26/42] fs: Remove i_private_data
Date: Thu, 26 Mar 2026 10:54:20 +0100
Message-ID: <20260326095354.16340-68-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1555; i=jack@suse.cz; h=from:subject; bh=aaS3p7rYcU0Djxp6pNN/3QR5Enbcvk2UVb3ATJEe+lk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJIE9HM0mjerK2ay1dK/RZJ4GYD4z+qCPm9s Z8cujXnLO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSAAKCRCcnaoHP2RA 2SHeB/9xyAbHhSlSNpe0Kpkb4wXcBjVU/YNMpOEk0hdfXskKNhk4tu2t9puIrceJ/eHa10S0gmS hQwjF39WV1aNAlN0zci/XcH8TWra0k4pjYjWsdDQ0bLYxWqDZqXcYxRWhAdz7i3V+BIRHEifrGF GXebltgg1w7b/EU6cwJeAIeRmWzr15yBi92ql3H0WT/RrFI2y/SczgX9JT31wz2+hdsyVugWj1K TYDeys+hYH4dgqve9MGDcXldcuXeNNyj1UYtXkJHJJYIX+rJCiAqG83DZbWhHhQADMWxIUdzEBz NsCXaetBz2Ve4q5CmjG+JoF0s/YFKXwln+mDgliLfOCYo51C
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
X-Rspamd-Queue-Id: 74D914D290

Nobody is using it anymore.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 0fc0cb23000e..d488459396f4 100644
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

