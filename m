Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792880865;
	b=srMNYIl5tQxnYgCySAw1amhGc+3BmQXwCL5a0MiE5SRUj2JccvQHMjavo7K4JWJTFf/G
	 9vkXRTq0iSHqXvIba6vQ/ELDAnlw8ke89u9YC/jXiu3Pxuv9fbnOEN7FtUMoPqT3laBGh
	 rFTMzWrY28hN7IMEFkbwPPE6ZGSWrb0EcZWhkt+BtNzEh25WNIXfmdnJQcs30BMQLZUPo
	 vfuw0VMaKyGUGa1ZHNqjcLR8c5giLM82+oAZTDlkGNDy44thAi34WhfHizZ1481AQQ92d
	 ivC6MOANqmOLl9lR2JiaZqAnVnFwRbPWBVdNs1diagoBNSwpmCU6ED1Lk+MpZhoLOoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792880865;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=8IjwxK5O6fnO5h2EAjlrc0UR17dDIl2naJJr1D8wc5k=;
	b=MlyMnxLGTTaqwOylxIJ+O73C3hCX8WxWAOnb/SmtXgCUpQGxMASblVtoZzrYqO0TOfBC
	 dR4Vj/WQCFOxvpSSHD57D37h6IBYJ8Zmo5FAm2S2l1BiubW5iwy9cjoZ6/sIUid4oYhXL
	 nXY8jYJSZuVJ8cOaYfRD1kxDdooiT3QuaQAw/B+SFv+ZRb+mRfaMyIHGGICr4yIy3TfOa
	 6iipMyaV86usrbw+Z/H4UHTFESFIfnkB5GC8uIRMzKgeBTk6nhaLcXOBgMKYPlXKwal9q
	 XHJxZlbiVSB9g35nGsyehm25JrqSq6ZgOIjLHFcalga6jIRYycCEBo8ElJAZh8iB+kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="f/oAOKlM";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=j+JrD4Vb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XO0ftCwi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cSIAVOoD;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43361606A31A;
	Sat, 24 Oct 2026 22:27:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43361606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f/oAOKlM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=j+JrD4Vb;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XO0ftCwi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cSIAVOoD
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3CEAA22447;
	Sat, 24 Oct 2026 22:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792880863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8IjwxK5O6fnO5h2EAjlrc0UR17dDIl2naJJr1D8wc5k=;
	b=f/oAOKlMtyLYwUjrobJAy+2RUIsEe4uWV/TmsAZUALQLnalwQ1pw5VAVUZvqHMMO9pPj3Y
	SkbBjRtuPVg7fB/0zPHoJnSrcLv6p57b+bUeyWgEyURPJ01iywTH5QvV+TsYlCc2hZIpNz
	dV2PGqb85jDKHgzq15CMy8Cj0PUw5fo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792880863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8IjwxK5O6fnO5h2EAjlrc0UR17dDIl2naJJr1D8wc5k=;
	b=j+JrD4VbkZfFpN1jbyaXjQUiLPJG7iQY0f4mSkq06cTuhuAQTeVyyyw31uvS4WOR7nsdAN
	y/nrkJdQVuW2uBCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XO0ftCwi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cSIAVOoD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792880861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8IjwxK5O6fnO5h2EAjlrc0UR17dDIl2naJJr1D8wc5k=;
	b=XO0ftCwiUnlxxXl9b3DvFhZRXcC6iYnHDDQ08qxD05RU4YWpAOOH520rdBz0ZQ2Ne3wOCe
	Bpwcf+RrdU0XTrir35lDGps28jNnA1GZMBnf4yM23NkZq/o7Nug47pPsWq6lDv8sroSjje
	ej9CozYVVQXQvfPuNa/qvhjORXCuZRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792880861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8IjwxK5O6fnO5h2EAjlrc0UR17dDIl2naJJr1D8wc5k=;
	b=cSIAVOoD3wD6cn0a6LzutkFt8nW7qLw7bsSE6gDsc4++lKdimQtDmYwpYfZODX6FQrNiY+
	ZVUEpF+ib2nshbCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7798C133F3;
	Sat, 24 Oct 2026 22:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NDv8D9ww3WpWMgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sat, 24 Oct 2026 22:27:40 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH] ext2: take invalidate_lock in ext2_write_failed()
Date: Sat, 24 Oct 2026 23:27:26 +0100
Message-ID: <20261024222726.889520-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ufrgs.br:email,suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 3CEAA22447

Currently, ext2_write_failed() takes care of removing extra data
(folios & blocks) from the page cache by first truncating the page cache,
then truncating the actual inode's blocks.

Understanding that this is correct - namely, that a concurrent page cache
lookup can't create stale pages and stale block mappings between
truncate_pagecache() and ext2_truncate_blocks() - is non trivial. This is
correct for two non-obvious reasons:

1) every caller of ext2_write_failed() holds some sort of exclusion
against truncation. In most cases, callers hold (in some way) the inode
lock. ext2_write_failed() is only reachable from buffered/direct IO write
paths, which hold it. page_symlink() can also call write_begin _without
the inode lock_, but at that point the inode is I_NEW, so there are no other
users.

2) the page cache is generally extremely careful at never instantiating
pages beyond EOF.

This is all quite confusing. Holding the invalidate lock across both
operations is largely simpler, and mirrors other bits of other filesystems
(like ext4_truncate_failed_write). Do that.

This has the side effect of making it so ext2_evict_inode() doesn't take
the invalidate_lock when truncating blocks on inode deletion. This is safe
as the inode should not have any users at that point.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---

This is a patch that fell out of trying to understand whether
20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br was correct. I think
it is, for the same reason ext2 is correct. I find this to be easier to reason
about if we just take the invalidate lock across both operations.

 fs/ext2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..723b31dc7dac 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -58,8 +58,10 @@ void ext2_write_failed(struct address_space *mapping, loff_t to)
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
+		filemap_invalidate_lock(mapping);
 		truncate_pagecache(inode, inode->i_size);
 		ext2_truncate_blocks(inode, inode->i_size);
+		filemap_invalidate_unlock(mapping);
 	}
 }
 
@@ -1236,9 +1238,7 @@ static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	if (ext2_inode_is_fast_symlink(inode))
 		return;
 
-	filemap_invalidate_lock(inode->i_mapping);
 	__ext2_truncate_blocks(inode, offset);
-	filemap_invalidate_unlock(inode->i_mapping);
 }
 
 static int ext2_setsize(struct inode *inode, loff_t newsize)
-- 
2.56.0

