Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F33BF688
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518969; cv=none; b=o/wbJmRJMaXJSYkjt+NoBozu7SY/kxPh7O/jG2vKdGoEsTr+lFegvCQzNqfadCBqtVdT88gPhfnDpABeakGthXYVdhMdoeBf/26zK6eA7yq4X7riW0sTtXhfdN5Exipnd3/yRXN8LS1D068qPe9tO5Geb1e0xeK1ESjVqZY7FP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518969; c=relaxed/simple;
	bh=owc5m+YmFPFX9G7b4L5yVqAn4sHTNVwb7RYuqrd3Kag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TndzIGY+7xksemK8tO1vA12ywOkwupj53LbaRRXl5Ev5UzuCvHTrq+oV35va3EpHf03QA52icdzOgD/jdnfYQ+lq6D/6gi+nry4x2QQzkeSRsWzcJjp+T64h1A5tMGZWQdl57NzvLtOGzr4bVt6wz47s4BDf29QRs2mnUWJs9jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x2I30ShS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/oTi4QXc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x2I30ShS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/oTi4QXc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x2I30ShS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/oTi4QXc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x2I30ShS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/oTi4QXc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55B324D280;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=x2I30ShSDytLJbrX5Rthxf2Ef1xf7RQB2asBKGwJ3s8Yas38lhWdis4/h0rS9eHtzdf4nF
	YSHTHVjG+n6H9RpnjO9a9IWzOeBM2DrLhcu6P8QYV5GHNTIbCWpirJ9KrecZKNrAS53qUB
	s7uSRelIt3fQ6xxAzgPTmI62geffsc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=/oTi4QXcjRgOIjz/ARfDkC2JilZkH3fHD0zDYH2y3y2UNK06jXHG4uGuSgmWjmV9SCOp7M
	3+40AbSUaqCe7/CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x2I30ShS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oTi4QXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=x2I30ShSDytLJbrX5Rthxf2Ef1xf7RQB2asBKGwJ3s8Yas38lhWdis4/h0rS9eHtzdf4nF
	YSHTHVjG+n6H9RpnjO9a9IWzOeBM2DrLhcu6P8QYV5GHNTIbCWpirJ9KrecZKNrAS53qUB
	s7uSRelIt3fQ6xxAzgPTmI62geffsc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=/oTi4QXcjRgOIjz/ARfDkC2JilZkH3fHD0zDYH2y3y2UNK06jXHG4uGuSgmWjmV9SCOp7M
	3+40AbSUaqCe7/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C4324A0A7;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kDudEnUCxWnXYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 20998A0C64; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 19/42] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
Date: Thu, 26 Mar 2026 10:54:13 +0100
Message-ID: <20260326095354.16340-61-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1456; i=jack@suse.cz; h=from:subject; bh=owc5m+YmFPFX9G7b4L5yVqAn4sHTNVwb7RYuqrd3Kag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJC/m40sh9r+/VqeE/EOztc8+Vm8Hwnlm9ew gLKiBy9a+aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQgAKCRCcnaoHP2RA 2WW2B/4lP04dwjwRh8h+wXW0V6DiSHJtT7smkcwZkdsBYBj97DGD7y61i60y7su7lR0Sduf1fSu ciGf4LyMDLUmD01BBY7nuRKw28tD7V4jC6z0Cn3nsoAM1p+9jSb0x1HA4BFHypthgMqctUjd8ah mXXPs6peVD/dB6nOG0Bq2HECOh2Qi4vbvOp4qTou9apnqsReuTP1qjkDcF8/Y26e5XriGDQ4VOS R7iwUP70aga39DSmv67KEmERZfc89rRurre1rYuL+euQTTeJQA2fsbBpRsO9Hx5TwZzf0kCQv2R a4lm0ak2rY0bdnlAxFg7DjV1rFgznBWPwjmjHfFmCk4C9u6k
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
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 55B324D280
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/super.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d18d94acddcc..6f892abef003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -185,7 +185,9 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		truncate_inode_pages_final(&inode->i_data);
-
+		/* Avoid mballoc special inode which has no proper iops */
+		if (!EXT4_SB(inode->i_sb)->s_journal)
+			sync_mapping_buffers(&inode->i_data);
 		goto no_delete;
 	}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..ea827b0ecc8d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,7 +1524,8 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	invalidate_inode_buffers(inode);
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0

