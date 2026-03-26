Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3893C13E6
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518948; cv=none; b=lfbKcxi9kxqxgCkwVZ3UgqRXXUFfqqQuVFLmyPbTOiAyGtRlh10737JK9ZOjBsis7Rae4NzA7eYHht1ezTGN+zUug0Mi+5V3jdm9+ldExxeMyYxkSHdM8osQ7L3wu6aG1e7Lv1OSGkeJ4SA9uBge07vyUsCu1mVBfPXYGRhZFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518948; c=relaxed/simple;
	bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBdwJ77l/5RofHvcyQIYCwLAKuNJUie93ZnOagByGBFWxTHpmsMcbfwWCVR5kUKH04XKvdyQUem2Z2H14b1Lg8yZsoGtKi5ZksetbdcMbEyK0eb4JF1mGoteie/iOHE4xjuKjoNUS9ZZvgivVq6nh5BrInkjx80ivGpjk3f1ls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KhtlkWiO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RPa8Up3P; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KhtlkWiO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RPa8Up3P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KhtlkWiO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RPa8Up3P";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KhtlkWiO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RPa8Up3P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 162F05BD90;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=KhtlkWiO78CCJ9mGJrt+U4aNIhhgZPPRQfPgmPwTj4qgyhwY5RT8DHONXFX8D6w/9XkBMK
	32PeTho+BOFRWhKnDofaCEPmEre8/NsuZw8oRVwL9jyu75CEJYOeApY7uRa9pc37TeiB7g
	qelr59wcfrX8hNnF5fIqkgrnSWKcxlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=RPa8Up3PdBsZgjkYN9RG5sVgNh0qSYmtretiLMFBxaF+DT+KG0OQMf3FaP+qlGtdEHT/uR
	QwquuxjWs/2ufQDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhtlkWiO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RPa8Up3P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=KhtlkWiO78CCJ9mGJrt+U4aNIhhgZPPRQfPgmPwTj4qgyhwY5RT8DHONXFX8D6w/9XkBMK
	32PeTho+BOFRWhKnDofaCEPmEre8/NsuZw8oRVwL9jyu75CEJYOeApY7uRa9pc37TeiB7g
	qelr59wcfrX8hNnF5fIqkgrnSWKcxlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=RPa8Up3PdBsZgjkYN9RG5sVgNh0qSYmtretiLMFBxaF+DT+KG0OQMf3FaP+qlGtdEHT/uR
	QwquuxjWs/2ufQDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 061F04A0A7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /WV9AXECxWmzYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A5B9BA0B68; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 07/42] exfat: Drop pointless invalidate_inode_buffers() call
Date: Thu, 26 Mar 2026 10:54:01 +0100
Message-ID: <20260326095354.16340-49-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=jack@suse.cz; h=from:subject; bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI3asYuc/oVgtRi89eW1ehL7CYhut2nO3al3 BpSIY98L/yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNwAKCRCcnaoHP2RA 2QgJB/4vYwxu9hVC2NpAKjgJUN90wx+oO48gHyS3U27s/oLQBDHOcFkcXUy8vwEZDpU0Kk9P5dN YaiK28Fi/i6gurrd8aqe+1HKn91CVevrNkUE0Tj5ceLYwOvNXM0WA+kr5N2eQxVZ9xv7RTtQyX3 bZkFBdxitJb+CLqMtg1H0afc/BoCVEE20tRT1ZLpRK4V29Ur5Q/7ABFM5sWeQdiHK8l/duTb0kg oyHjrT4uD4k6GfDhR0Ye3dTMYHn4ucIonq1Tjob2BBKYEhKPhHc3Qtkiyx7H+rxeJgHvJdpNQzV HPbeW4POGDqiPg/KkYxrAj5YFMK8Wr5a4iSQQtST1594SpnW
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 162F05BD90

EXFAT never calls mark_buffer_dirty_inode() and thus
invalidate_inode_buffers() never has anything to evict. Drop the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/exfat/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2fb2d2d5d503..04559b88482d 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -695,7 +695,6 @@ void exfat_evict_inode(struct inode *inode)
 		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	exfat_cache_inval_inode(inode);
 	exfat_unhash_inode(inode);
-- 
2.51.0

