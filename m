Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06CC37B3F6
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501665; cv=none; b=TmWcN2pngAtGZ2qjRYa3vCQVEsjyaV8W8QFyxBO2uIC6oJRhsUBNEGmdRhdcd1zIlLVyo2+xnreyjuK+KD6qBQt+Kw4KmKShhd1fjHQQusj2LRIbaWfAP7wR+5tNXhN+LhwDRgyARoPe7153PKeI5cWkp7miBBR+fBU1yHUvXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501665; c=relaxed/simple;
	bh=HIzCwBCm/MtiIGCNy6CLFL7D2gNiBlPRrMvJiyLYQHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXgHM1DlEd6kTIb9ByABN4cobA1LCpCduy7eP4cnukPY9VdoiavTSduV6jiM4cYiVeKVR4oqa+abJqdXoc6LwjthzE8k7uE5AKiyt52/iqh7hG7/JiYaQM8xnCmymQO5rqfZ/WCt+RmFKgdlKzP1EHgblk5oj0c9MStptvSB9fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mjCr3UQ0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mHQantlO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jZqbX762; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UMaQ10L9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mjCr3UQ0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mHQantlO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jZqbX762";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UMaQ10L9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3FD3667F5B;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGmRaYFQwdub0DXXUza1Xh0kPWDeyqrWqE79oc2/MVY=;
	b=mjCr3UQ0bQE0A0icTwb2pu6LfDS+kvUMWJEskCE4DEBHMGDiokw9lERN5ZcpGGvp+lcLP/
	LTciEyn9M/lYYmkrPy3u+3304HkORZew2V2KiWoU/HhiB8U9YZY61yE6UYI8w+Agy92nMe
	Eh2MJWUktnqFGBSh2GlHa0bGzHF7yuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGmRaYFQwdub0DXXUza1Xh0kPWDeyqrWqE79oc2/MVY=;
	b=mHQantlOS6Ec6HkjhY8LYZPm6vjzB8o1f6C5/tAZQzYa/JpIGITx7naoD0v4GDFDAD4xQG
	Go3qgJ41dPJ+GHAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGmRaYFQwdub0DXXUza1Xh0kPWDeyqrWqE79oc2/MVY=;
	b=jZqbX762gjgwCuPyIV3XJo00QfaB2llqTkIrSxllZqmlBRIUF7QyfAvZGYA7nBOiDIP05z
	7Mefc8F0yD9jUMIILSJ8h/XW0flQXRtdhWgKYQyk0VEqYUIVxsey9sj5deie4txIQxqNV7
	S6UXfcQP2FEg7JO8Vug68iJR42RHNew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGmRaYFQwdub0DXXUza1Xh0kPWDeyqrWqE79oc2/MVY=;
	b=UMaQ10L9kpHf5LZr5G+UPJSLdIORlQcElliSt+huSSvqk//KsjUBYudWG7+ODHoVID3FEe
	3Q0v6FHpXyMwJuCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3239D593AC;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jLpBDBPIAWrXWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84532A0905; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5/9] udf: Fix possibly missing inode write on fsync(2)
Date: Mon, 11 May 2026 14:13:55 +0200
Message-ID: <20260511121356.241821-14-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=969; i=jack@suse.cz; h=from:subject; bh=HIzCwBCm/MtiIGCNy6CLFL7D2gNiBlPRrMvJiyLYQHk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgHDKvD+xR6Lj1wXq9hIUubTV4m98njC+iIy R85FUadcZqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHIBwAKCRCcnaoHP2RA 2d/+B/wMdpwi2ddPHdJmH/WmOjyiq2gFVB4Joy2EQCnC2vM7XdUwz7AgH7VgyhRone43MBzWxMu CULDeXr3tk8FAAGOKNvbnCzWw93+13FB3q1N0mp0ekEiv+2Dvc62yIGhZSoMYHVPnm9G1XcH+hF B5U9UaKRJojiNteQqcb2TOOPAx5HmS9XXf/3SBGyJgFZLUdMNwlaYLSe0Wq5m+bJcH5qg7JX/TA 5r8fHSW/Avh0XU31XyQRwFHS5fAp7ONhdOiM/b9O02WJweE9Ed5FRbw2ZYG+IPt1I9zu5h3k2mr q3HDmNuYI+H7+eV4PBTCAhcTUK+F8Cl41ErOQ7CXgt1fRMZt
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Use mmb inode buffer writeout infrastructure to reliably write out
inode's block on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 67bcf83758c8..4102d3482319 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1707,7 +1707,7 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
 
 int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return udf_update_inode(inode, 0);
 }
 
 static int udf_sync_inode(struct inode *inode)
@@ -1937,6 +1937,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
+	iinfo->i_metadata_bhs.inode_blk = bh->b_blocknr;
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-- 
2.51.0

