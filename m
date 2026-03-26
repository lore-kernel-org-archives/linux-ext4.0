Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D93E3CBE93
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519042; cv=none; b=czYJwBw1XTVYY8SZDG3e97pP+h/oy7U47F509VPNZBVPNspTYf1mujumHVujF6r2g6YqQXCkV2Vbv8momrhFzP8SffPxZx7sNRhUmSco3P1K98B9s7So+bCfvntuZoDJNOiOegd39qHLrOGHx/XdWbxANohU+ptcYSsL81zU/Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519042; c=relaxed/simple;
	bh=yQzIvf4IB3KCZ27coMo8m+PRy4c1M06bgmEFrRfpbxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htsjTuIfmOWuIkb1dYCECRnYIijdDsvsnzKBfbmG+ylGzRi6xU5ENDX//1s3a4YUuZh3J20ePrORPqH1BSGDH7heQIm/cDZonCtX6dDICa9Ryyf9vV1s24WeQ7AO5e4LZPQLJj8RlJBxh4QBQCD2jHY+2mvtjvrrJDqbpwzdizI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gdvbDLim; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PfdLa6dF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gdvbDLim; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PfdLa6dF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gdvbDLim";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PfdLa6dF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gdvbDLim";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PfdLa6dF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F7B84D297;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ODd+/BQuyhT8bHEtYfURB336X+kzedB6XCVQ0zG+0Q=;
	b=gdvbDLim8zmPCJ1qENdvp0MmM6r3GQi43VuEIXAfYLWSBgvUFl2/sxWXHIfBQ7BWi14CGR
	mJynqjBzeNeH/1JI7XFwVet565K3IVUPnGV5gq28caXVt08myoUD7U5Q7mDZKKfAMq3e+i
	BjMjFIYKIuhKLj2WolfG1CY6EkGZDp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ODd+/BQuyhT8bHEtYfURB336X+kzedB6XCVQ0zG+0Q=;
	b=PfdLa6dFwou+oMgtLWiBAOy2A+qgmui/o6nAS046la0tD95roE5TALf8UT2o6YCLDnrRxF
	QIoX5RoIyv4HjMDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gdvbDLim;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PfdLa6dF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ODd+/BQuyhT8bHEtYfURB336X+kzedB6XCVQ0zG+0Q=;
	b=gdvbDLim8zmPCJ1qENdvp0MmM6r3GQi43VuEIXAfYLWSBgvUFl2/sxWXHIfBQ7BWi14CGR
	mJynqjBzeNeH/1JI7XFwVet565K3IVUPnGV5gq28caXVt08myoUD7U5Q7mDZKKfAMq3e+i
	BjMjFIYKIuhKLj2WolfG1CY6EkGZDp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ODd+/BQuyhT8bHEtYfURB336X+kzedB6XCVQ0zG+0Q=;
	b=PfdLa6dFwou+oMgtLWiBAOy2A+qgmui/o6nAS046la0tD95roE5TALf8UT2o6YCLDnrRxF
	QIoX5RoIyv4HjMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E0874A0B0;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h+K7HnUCxWn0YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 97080A0C76; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 32/42] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
Date: Thu, 26 Mar 2026 10:54:26 +0100
Message-ID: <20260326095354.16340-74-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3280; i=jack@suse.cz; h=from:subject; bh=yQzIvf4IB3KCZ27coMo8m+PRy4c1M06bgmEFrRfpbxc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJNbu/pv8bkd4PZg8zqmg70c36DeVE2rB1// 9M/4qC8tfCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCTQAKCRCcnaoHP2RA 2Z9QCADHHaVkGq0kXrFvkP8hslPwOUIRrl9p2Gkxk7M1eJyfkVbVHmtur5um1W9DvtWvPywIdd6 h1GwzQQJ19H7+B6eXVuMsKXKCSAz81iT6a+Gq8AFolFzURTztYi/+BeGLncyQisl2oFQ5h7LwqI ONlwwc5UX/bGGu5wP5bMgJwU7TDvTRV0Kcir+61ycd1DKemUsz6n+cGg3NsGnyM/sA4zhA1vTZ4 1j16uIlXMGBvWrk07JNgF/m1IfiMccUczNjkgQH/R1L6/JD4kw9zfoMEoFm8+VrpKE4ecsMLAwH IQMXrs+S1J7ZTbwWe9TdmEHQbg4m8AGU8l/glaaGCUw5MtTV
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
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,lst.de];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 8F7B84D297
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

As part of a move towards placing mapping_metadata_bhs in fs-private
inode part, switch inode_has_buffers() to take mapping_metadata_bhs
and rename the function to mmb_has_buffers().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 14 +++++++-------
 fs/ext4/inode.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 67b3d4624503..b0436481d0f1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -468,7 +468,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * written back and waited upon before fsync() returns.
  *
  * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * inode_has_buffers() and invalidate_inode_buffers() are provided for the
+ * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
  * management of a list of dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
@@ -526,11 +526,11 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	}
 }
 
-int inode_has_buffers(struct inode *inode)
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&inode->i_data.i_metadata_bhs.list);
+	return !list_empty(&mmb->list);
 }
-EXPORT_SYMBOL_GPL(inode_has_buffers);
+EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
@@ -561,7 +561,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (list_empty(&mmb->list))
+	if (!mmb_has_buffers(mmb))
 		return 0;
 
 	blk_start_plug(&plug);
@@ -803,9 +803,9 @@ EXPORT_SYMBOL(block_dirty_folio);
  */
 void invalidate_inode_buffers(struct inode *inode)
 {
-	if (inode_has_buffers(inode)) {
-		struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
+	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
 
+	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
 			__remove_assoc_queue(mmb, BH_ENTRY(mmb->list.next));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f892abef003..011cb2eb16a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (inode_has_buffers(inode))
+	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 20636599d858..44094fd476f5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -515,7 +515,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
-int inode_has_buffers(struct inode *inode);
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void invalidate_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
-- 
2.51.0

