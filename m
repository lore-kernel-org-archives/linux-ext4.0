Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A59D3F8ED1
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149420; cv=none; b=SSfEbwy9yyWRBQwlgu6cId1TIC6cEf//dAHiU3S9UqhxVZ/Npt2uFsYqaPjTQwU24eBH4JROuD2cnPQCQGH8TXkTK79iyQzJh4Hdi8iEcxusdal2Mic0pcpzXA5cBluPmRHN16G2JA2635XN/cB3lECWKsbAVMidPNuV1SW2VdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149420; c=relaxed/simple;
	bh=tKjRk1t0n7fy4kXkItDZOgQtWkprop70nNQUPf8pbr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8h9nl+3cDsV/j017KPCZ3oSyiKJ1G+grtqPCWKjSEW5QclJKcoZETBw3cL+jFCZEw+Wpv86e/wtKz/T7gmtWMk4M09Bt74yumXKngbRlu90/ljcMFEmh78H65BJhceFlTQ3gtRUGSD34ohaY4br/vZou4C+fDgLLNMhvGPSXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zELLblFY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kYxTHvS2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ob8eOQ7R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FZ2ySJpO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zELLblFY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kYxTHvS2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ob8eOQ7R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZ2ySJpO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62AB07DAEA;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1GQmaF5tSTbgU4Yn7zoUw3JQBgPbO+vgHaDHHnn9HY=;
	b=zELLblFYsK7IFCmU+yOVkDMlnKPxw6yfKPfnMdhUQ3PkroZeDR63REo689xKk+uCKWzHUi
	pXXnpf4UUYfWLUWOs6sIB0+zxM9nzNhdo8upAQB+hnnMTTKrjiN8kT5o0CJGjQN9jXdr9+
	UY/OmPPUoLjgWsGMvd1Z/KHaCorX96U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1GQmaF5tSTbgU4Yn7zoUw3JQBgPbO+vgHaDHHnn9HY=;
	b=kYxTHvS2Hm3H1l9/GNvX313oz8eK8JXmciJRHx5gN6ujIYkj8rlGV0KA4+W0GZXY4UFB0r
	B//9asqgbaHMMeDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ob8eOQ7R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZ2ySJpO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1GQmaF5tSTbgU4Yn7zoUw3JQBgPbO+vgHaDHHnn9HY=;
	b=ob8eOQ7RcgYK/jekxiZXT0PdCczaznC2BW6q+2+97pCDNUltgZ52ngKhwNaU+YAzGIjnu6
	0b/nNDIo65/sq0opjqDZ6hp6cXo+5QLMqQw7BbwO4XU/HQR+/6gTkIVuVNXh8ZtCenhnwU
	b2GTNphI4hoNuZddbXW8my6iXxXZpBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1GQmaF5tSTbgU4Yn7zoUw3JQBgPbO+vgHaDHHnn9HY=;
	b=FZ2ySJpOXAjSxAkRlNI4+M1oycWT9meUjtl9pOjouxV3sZkZrQ60W0ANMzdvT0qYKAJNA8
	P4k7HlCyreMmi0Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59ED8779D5;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Au/yFcw3Z2ojawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6EAC3A133A; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 14/20] udf: Fold udf_update_inode() into udf_write_inode()
Date: Mon, 27 Jul 2026 12:49:32 +0200
Message-ID: <20260727104923.3828017-34-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1493; i=jack@suse.cz; h=from:subject; bh=tKjRk1t0n7fy4kXkItDZOgQtWkprop70nNQUPf8pbr4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze+Jbc/2Ho6jRq2NOf+BtUFzD/GgoGcyXPBS JR0tsQbH4yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3vgAKCRCcnaoHP2RA 2cnWCADJk4Ke+QZQ5DZGZbAPOf4bAHnMHrLAgiB3gfLdkpAvhGQjcvwGnjNi/33xqkPbSOtTiZU 9vivRxLgKjBD+LgaJdAgGsea6wKECaBxb9M+jiLc+YGLRXOJy09Xu3x+TjjSQlToczQBX5VB7DU ehDa2j/R8+yuJ2uUptzQowARXi0rO2mMnRg7s5QRjRGtncsCcx/8RyNz0dTqyuilgmN9OGmF5yT DkRObITkfszXdTVU0rO9jBa5LFwFIrDewCFzthCKpYMeQxHV6T+ylhjly3GedmUGX4AWqTTBrqT NIlSFRt0aULW6z59VErv/9BElw/Ob4wPE2tDrijdFv9vk4yf
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 62AB07DAEA
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:email,suse.cz:dkim];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:email,suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

There is no point in udf_update_inode() anymore as it has a single
caller. Just fold udf_update_inode() into it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8cf0562f34bb..68c6c2ba8ed1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -51,7 +51,6 @@
 struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
-static int udf_update_inode(struct inode *, int);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -1698,11 +1697,6 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
 		iinfo->i_extraPerms |= FE_PERM_O_DELETE;
 }
 
-int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	return udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-}
-
 int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
@@ -1735,7 +1729,7 @@ static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time
 		iinfo->i_crtime = time;
 }
 
-static int udf_update_inode(struct inode *inode, int do_sync)
+int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
-- 
2.51.0

