Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BE3317171
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014120; cv=none; b=F5JTjpYt8lBPhI8F5+3+pC2F8adPo/UU3+0QIXUnwoCUYr+/vW/PeNrg7msPwUF528DKTc1hWo1u4EBW+FcRy3rzJ5kfiz1Av5Sta4nZkLHMFLTrLTI64v3c/OznYAeH+O/3nzeZjyfUx4QmOrLEPJcv5nZhV6oo5CRTo6BgI3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014120; c=relaxed/simple;
	bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6GhjKOJs+uEadT0E6fbyByiiEMLbvhb24expNZ48bil+nPWtm7uWRubTi6/GMhT8QP85GpGYxeLTJtIbCUG6XuU6GCvSAU8oSdUvP805NiO07S15o78jqnAo7nc5yh1urTYvK6lR+2qSEJIUYd8V7qir5ZIhSTQFH4wGuZmcA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i3ZAuXwc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hY/DWDGm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i3ZAuXwc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hY/DWDGm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i3ZAuXwc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hY/DWDGm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i3ZAuXwc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hY/DWDGm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C4FC15BDF1;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=i3ZAuXwc35r3TMofgZlHkAcNMsYqX3UQ6ZBVury6Imay3gTNNT6j82RPA0X0iSQCpDX1Ov
	W5RySzJQEbpCl2x/sCjl02ZWQVkS0DHt8xiZNM9DTFGd7WUleohLO8D93jNVcSHncXtf2C
	BQKsMIV6BzZlb0A3p+vtd/vvgLaejjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=hY/DWDGmRhA2OKmvbjkDIrnW32E5cQRzGV9LM+KdS3D+eBISnF93ZE08P00oecqeS5KMND
	EJXz3DOEzwnI/AAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=i3ZAuXwc35r3TMofgZlHkAcNMsYqX3UQ6ZBVury6Imay3gTNNT6j82RPA0X0iSQCpDX1Ov
	W5RySzJQEbpCl2x/sCjl02ZWQVkS0DHt8xiZNM9DTFGd7WUleohLO8D93jNVcSHncXtf2C
	BQKsMIV6BzZlb0A3p+vtd/vvgLaejjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=hY/DWDGmRhA2OKmvbjkDIrnW32E5cQRzGV9LM+KdS3D+eBISnF93ZE08P00oecqeS5KMND
	EJXz3DOEzwnI/AAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC8334281A;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /iWtKZhOvWlACQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69BAFA0B2E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 03/41] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
Date: Fri, 20 Mar 2026 14:40:58 +0100
Message-ID: <20260320134100.20731-44-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=jack@suse.cz; h=from:subject; bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5uHEq4UQTZ1UrVhvgG+EYydxO1nRyNYrdsA +FUT3YdJO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObgAKCRCcnaoHP2RA 2WvvB/0RJYZY+8sRCsZSDxp74cwUlJk3pSPEy6TOgUcor5WSx0fNWsU2RBKMR9lrW0nFZuGAYIE nZ80x+PYSJyIbz3wFzI7uEL92U24vHYHcIN2S1CEPaapKaX5HJshyeVQ6UgC/TBwcGYA6hdc//F xzOyybtQ3kRAgvcT4J2GX2rg07PbxzlH2Lo+E4tcn11rbOyLc/XbK+4Ys1LzsvUOwmYOwG7KCR3 V1O18HYdXkb/Fq6AGulchfOdl/QFKxjNpBYK4UysuSbb6Xxijc4KdoVb0UvbhXr4RLMuURijmFh +XPbvb7v4ubgG4Zhf784lhdxETYhNgSQT/EpvGQIt3NyqP6g
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,paragon-software.com,lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

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

