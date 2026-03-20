Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAD3148A3
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014108; cv=none; b=dTd/YG23V4KHQutEzAGkqSB6Uyox6gn1DFiOPIqt9P/s+3kSRtcy8z0o5K/UyhwS+SObbnqpA80pQo9DYlvPJCwICfg17RR+k0iC3MimSXt1/kEDIRd4ljUSiFKeJsKSyhFPyE/TOqZl+QaeD5wX/7ib9W7g1FYIIVS5odxtSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014108; c=relaxed/simple;
	bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlF8YkxlWqnYpSnTgVeMaDLExKKjGpbnp4cUNyy64lxr2ximBSr0VxLTwC2w7rPk51yIFK4h3IfFVopQfKpMTDwYJYUzPl0dkBLNl5KXKVyNC6/CFOBs4A0Pq5OWmJyaWoRzQ3kDhagtW81to/Ghzg26dby4rgdhHJOb79vQf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KM7Pfj0/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k/OeKw6R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KM7Pfj0/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k/OeKw6R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C10664D1FD;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=KM7Pfj0/x/z0cqPdYoaC0FfqdagK0BcoinjF4KQYPLcEYBCnukDjIVlCEBO9JJOGGnYihW
	D26ukT1LO8QsQbhN5LITcNzS4EnMBnWP8NO2V1ePm6j/eRhpaSSTrauBd3oWkisR9K17an
	7TeUD247LjHyi7Ck7VGZOz9mE+QBDvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=k/OeKw6RRCiMkf07Td2inHX9Rhej3W+yrmVKMJP8AijrW9jbrYad8Wnb3gn0gepOkYsIkO
	tezPrhUBv7c4CGBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AED464281B;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RBdUKphOvWlECQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 60A80A0AFD; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev
Subject: [PATCH 02/41] gfs2: Don't zero i_private_data
Date: Fri, 20 Mar 2026 14:40:57 +0100
Message-ID: <20260320134100.20731-43-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jack@suse.cz; h=from:subject; bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5t9QDNvNUEpIhcooLLBbuSbDnT3nLUxpPES BJ6DFZlrM2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObQAKCRCcnaoHP2RA 2YO6CAC1QjGsiVbGWR49r9Gc5PDE77TBzLQ1nn76UyxV7YDC0GXdhh/dRP7krJYNUltHXz6QS42 1SGtvIZ2eSmgIvFa6nD2Fl/96OVrwA6bGhTIwuzT5ut6YQneZZxMSaewidPP3Y3k4Skx0cToUuk cTYGfVjK7PFw/J4ecyxoUq4mtYn3Rx6d88V1dNEMdEeMq/PQ0ST/NvwhJNSXUXWJ5io9UugmtMl EViwvNz8HhVdsEUyywn6pu8/9DW9UFSQEafgqh4x9WDEyb4U5ArXHI/r1QJP+b4zG9Aq+7LhZAD 9ghuoUtRkfw5GZzSyEMygzQPxvD+P6dBh/7lgoQl1rQiTPvP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C10664D1FD
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Remove the explicit zeroing of mapping->i_private_data since this
field is no longer used.

CC: Andreas Gruenbacher <agruenba@redhat.com>
CC: gfs2@lists.linux.dev
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/glock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2acbabccc8ad..b8a144d3a73b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1149,7 +1149,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->flags = 0;
 		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
 		mapping_set_gfp_mask(mapping, gfp_mask);
-		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
 
-- 
2.51.0

