Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268513C060C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518964; cv=none; b=AUWFzj6n3CXS2rfWj8ufKC8bTZ0loKL1iOOLK5BdPamr/kItVenbofc42NS6vmpSJG65ZGfTM2Q/9B9FQFCwQSijBl6eH4e5e/2XiPT460l6B9v0roGv+JpaY7PtlnFs0YAJUOZ3ff+o7ZxTDglWE8KWxFzlksfToV0dM9RI2Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518964; c=relaxed/simple;
	bh=MUD4hvw0kKK4/k9ZuBglb9Pnr5A53izwByukHuzgvfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnkjDjXaZ3H7Sb42D0lo9GWRjBevh4SUsoj6h5OJSDoW3xDnqY39ZWA2llrNxPXfmwxNfz1fd/P6xPf0ynUlglszoW720W/ys8wbl8uVLXsyZC5qosrVDbmHNtqM/KhRylvmtylR9BzpIaqbn7TlDDUe2M6J1EhfHvC1jmagKgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0TRfXFFV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PrKmUYBT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0TRfXFFV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PrKmUYBT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0TRfXFFV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PrKmUYBT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0TRfXFFV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PrKmUYBT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BFBD5BDA5;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=0TRfXFFViPXUkITOQz2GM0pGLNQqx2D5zKOiDGVE03I+NNSKkhRlTraClHIJiDR2DBMfz1
	k6dbjaROOamix8Dn8HPhiLAJ0DKb2zpzx0S5++G3Z36JsP3jqXSf6Hs7BlvmzRx7DjdEIR
	Y1eicNGp/yR75COyyspHqz0JGvniWvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=PrKmUYBTCWL2TCFcC2JIpDwkiDan7V+OZK8QM5HGBoPNJ+//GiVfh+qG+OQZm2MHX9b/FK
	ddQNdpiGdVH2QHBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0TRfXFFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrKmUYBT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=0TRfXFFViPXUkITOQz2GM0pGLNQqx2D5zKOiDGVE03I+NNSKkhRlTraClHIJiDR2DBMfz1
	k6dbjaROOamix8Dn8HPhiLAJ0DKb2zpzx0S5++G3Z36JsP3jqXSf6Hs7BlvmzRx7DjdEIR
	Y1eicNGp/yR75COyyspHqz0JGvniWvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=PrKmUYBTCWL2TCFcC2JIpDwkiDan7V+OZK8QM5HGBoPNJ+//GiVfh+qG+OQZm2MHX9b/FK
	ddQNdpiGdVH2QHBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 402524A0A6;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OKhD3ECxWnLYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 046B2A0C59; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 16/42] udf: Sync and invalidate metadata buffers from udf_evict_inode()
Date: Thu, 26 Mar 2026 10:54:10 +0100
Message-ID: <20260326095354.16340-58-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=790; i=jack@suse.cz; h=from:subject; bh=MUD4hvw0kKK4/k9ZuBglb9Pnr5A53izwByukHuzgvfg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI/iH1edR4ShwUvYoFKD7qhhaBFBhSp0KWEX 3MdhTPWkEKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPwAKCRCcnaoHP2RA 2a4GB/sEoTazVYsOod3P+7Q7cHcOJ8li09u2SmfS9NMDOgvd7GUUyee0Amz/FogU2ivaPxMvJlz 8KjCnG+Vrw6P0Q5iWMfl9uT4DUjnYsiAZ9qT0otWDuNXi44425x4VvBWBqu25LLh1edJ1eOHAxZ EN8YuyEgOnmgDxNuFXCkfxaOwrFCsP5PgFykiZGe3ijNXDZ9YfJrUBs0oRpmvQ6EBvFEKPJPujv T8ZpmxS0YMIdFy+LdBFE7EF0JNNv6Ao1wT1qbk/WgAyQwT6RYcstoYle3mN8hjLFpvJ128g1Zdh B4irlh9r5tyPwpuDGEmY636MNurozBK/gF2amwNyKZa/BOQ/
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
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
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
X-Rspamd-Queue-Id: 4BFBD5BDA5

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..739b190ca4e9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -154,6 +154,8 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
+	if (!want_delete)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	kfree(iinfo->i_data);
-- 
2.51.0

