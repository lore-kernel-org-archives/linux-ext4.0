Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041B3BBA01
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518912; cv=none; b=kU7sjPTs3nnP5+xFbZ+ivNw+w+EtJwta22L+pRIuwWz0LLZB96eSQ1G0xKs17Z/ee7Fxa/zDWgxSTVGLKmLuAwKF2CxolXBYOXN/3wZeD+k8G2GR+d8DfvQfBiXzrqw3ol9uf2qPV5/vuemgGd/E4Ev2ajNKZySRwU5Es/wYUcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518912; c=relaxed/simple;
	bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3V6IHlJ4biz1tC+TIC4phpEYow6pKGRY95gJ/aHeVe8AseB7omUpse0UlQ0V1h9e+ox14XiUhqo+aspl30L/kKvB8WppMgeCdauThATppBEWhjk0X2Xie5kipoRGKCm0pSY7y7Urz2mqLRqhP6hjLMbM0ra0TEy+VmFW24rF9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fg5zz6iJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oJbDjkUK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tgBitcH7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GUNWPU2V; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fg5zz6iJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oJbDjkUK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tgBitcH7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GUNWPU2V"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE6985BD0A;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=Fg5zz6iJmRyHEh6qiH7+5WHnTRYylyOrE3kQl1PIQrb56ytIj+OgztDjLZOjnhjq4Q5yvU
	4UY7PfrTk1dhtKlab7u48fTsbNcIMy7P1/1a7I6z0YbAaQ9YkxM1y55sTVoIsmdNcTA3Hd
	VgIp8AG7Dk2jE5gDAVxrJj3WRZA/n3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=oJbDjkUK0z7SNcPYL20kKpL5l+AAfiXMXUQH5y2dSO6KUN3N4MSxc8G+pdEBzaRGOrVTVt
	A+hsUAYOb776TlCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tgBitcH7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GUNWPU2V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=tgBitcH7FdYoLfFpSjYftDRezmc3Lz836aO+H9qsVbpCAAAvIcd2GW8hfxZ6tu/JR1ybCb
	hlK/zV51kNZ7mQcRvXLe2gsZ2SeD9WrA+5ULaOVmXqlnHyFJeKZvOMfx7U42ZYZTgjJFvv
	PXBqVtfRAzH/GGFd770ZQEa/SM96CZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=GUNWPU2VmtfcnaXljrOqeEIMf2EsQqP3kks6SkQ82vTLD+rSSSPM/46ZN6Ar0q35ycIx7i
	fo8sg0OsLiiVo2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BED6B4A0A8;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E/eQLnACxWmiYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 82CFAA0B5E; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: [PATCH 03/42] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
Date: Thu, 26 Mar 2026 10:53:57 +0100
Message-ID: <20260326095354.16340-45-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=jack@suse.cz; h=from:subject; bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI0HEq4UQTZ1UrVhvgG+EYydxO1nRyNYrdsA +FUT3YdJO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNAAKCRCcnaoHP2RA 2dHAB/0RMeWEePefP/TbmZY2WRYlfAyvOWDAUTFwJJGUTfii5CnecrOoG2HOl9Y7eZmiLuS7dXW VImegHi6JlrloqSQWBXc5xhjHbDmWgC/lK8hprruEjr5qkPZfaLYJ9IcDMWx7d6ACLjXRfChOw6 3+5A+UsimFNqezMkcpJLjAnpVLz5wkOaBXY/5vfSAGZxqHYg7SfEUio58YuHSudrGxsoEzx5yRR 0/uFG5hGTQmQv1k6khrglQ28AQ8RHvA4WDqAjt+Eha9cBci+Iq3hXA5zAHIHZPCFRgSxKG4kTd/ GDsq4cgIb0wnof8VmkgFan/qKGlhbDK84k0boDDDj+9tkJyV
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:email];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,paragon-software.com,lists.linux.dev];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CE6985BD0A

ntfs3 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
and invalidate_inode_buffers() calls.

CC: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
CC: ntfs3@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs3/file.c  | 3 ---
 fs/ntfs3/inode.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 7eecf1e01f74..570c92fa7ee7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -387,9 +387,6 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 		int err2;
 
 		err = filemap_fdatawrite_range(mapping, pos, end - 1);
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
 		err2 = write_inode_now(inode, 1);
 		if (!err)
 			err = err2;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1..5d8f04dedcc8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1860,7 +1860,6 @@ void ntfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	ni_clear(ntfs_i(inode));
-- 
2.51.0

