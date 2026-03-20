Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA383AC0F8
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014177; cv=none; b=oOgw8uojnd3C4L2SeP7kgiDRLLKscrMzRzryFL5LrpJ2+HEEQY6IPfyTCKSgiaBehKiJGM5BBTydVoZyHRatvjRK2+BR/sb+dxrNeTFGsvmq/buu4ANiljSiYQabdYIzgt0T3TLtX+z93p2ABALBp/iXUYYxUjZoeErTm7QqADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014177; c=relaxed/simple;
	bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRtALKCH4ySUQw7sfjhYE91hL4l1kmCy6nxKW3/LszjqgbdhPY7cZnI0GE6ImE8ym2q6cbtzq0AznSJN6fvxIYj3/FJKUmVgrzdhPLC/RVNrsqelQMl8Nwu3aUY75rBk/db94zsS47kqFQLvjXS2kNmwH9DTANjn2K5rOlmzZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m3kGs7d4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GswqmZ8Z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m3kGs7d4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GswqmZ8Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m3kGs7d4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GswqmZ8Z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m3kGs7d4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GswqmZ8Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C2EF4D32B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=m3kGs7d4J6v4QvnoUSD/e0rS1VEcdTA3AYUgR8kmCLK6KKEo8T1RnBC4HJfY88aC70Yvq7
	dIK+kvjDLiZJLIqf+4pB6t3NtsaP/W51qTtDmwF4DMO/K5A1dFyD5+alEEHk8LmXo+9X0t
	2eYRMsI8OCAGtJ4P/BdwunKe4piNfUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=GswqmZ8ZHX2vYj9kI9nAHpreAmNVLCIA5VKsGlnBVRKHgbpDTn/I6F3BUOIpKLHVETYCJG
	cjC2oXu62YH5HFBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=m3kGs7d4J6v4QvnoUSD/e0rS1VEcdTA3AYUgR8kmCLK6KKEo8T1RnBC4HJfY88aC70Yvq7
	dIK+kvjDLiZJLIqf+4pB6t3NtsaP/W51qTtDmwF4DMO/K5A1dFyD5+alEEHk8LmXo+9X0t
	2eYRMsI8OCAGtJ4P/BdwunKe4piNfUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=GswqmZ8ZHX2vYj9kI9nAHpreAmNVLCIA5VKsGlnBVRKHgbpDTn/I6F3BUOIpKLHVETYCJG
	cjC2oXu62YH5HFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7185842817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9Fq2G5lOvWmBCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22956A0B4F; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 24/41] fs: Remove i_private_data
Date: Fri, 20 Mar 2026 14:41:19 +0100
Message-ID: <20260320134100.20731-65-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1510; i=jack@suse.cz; h=from:subject; bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6AToiVV0GqpqU6pE7PQT9P/O66rCCDmO9KI 4afzBMrY+WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OgAAKCRCcnaoHP2RA 2UQ9CADYF93eU+lysMgRD9NC+J4reatt3UWiFSymsiFzUbhTUnhlS5oiXgnlRCpok++GtXhbsZI FZINwnZekAvGBqDbSCKZfIC2ZSRuaEd6Pzo9lPYRzN+jSfBMMziLJQ7O2f8nr6jQTf/yWR/Ecmi GhyUqGm9JEp2QWO6cod4WIVQ8HOf5GFZNk4y+SYXfftv3tWA+J3gS5P0Op/t3a+n4eNcrntnt38 Fw6+EIdydcLj3hs4ta3UNBxbIDKBDgNAVUY7oW3tR11iLJCoOC/wkFIoZm/KeZsAEi5SNw3wHGq IqBb7w0Ym3x9dZoiV/iOP3s/FSJGos057kaVEJqGDMTTO3Pi
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

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

