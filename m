Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFBE388E75
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534084; cv=none; b=C1w+gcmdILdH/lNkXCAN0VHZWlVmQD6yonrbaLbW2bZUl/Ba6cGe15uDzAhQZ5t6WpqLvnpXzcQvE8QrWbflVtQBUZMUhXPQKy++pUNl3CGxTxdT0rPT+XhMBZt4DvzKWPHcAoMi+AqQ9s7k6Ldx5igA5Ag+UOaELk95znRnhZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534084; c=relaxed/simple;
	bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzZ/v4KLLnkd1mlzD5a8zBRxLciId8wbzPM4vEJURJTxRBEVOatZHLHKlF21FfJIW7UUFia+dk0dMC73vwzMgep+xUI3H5tC4CztXn7ReVK3Uyh9hKvQkWK88E37Ewn0b1KCaryX3gdjOxX4BOMtaM/Svhnfat+xxhfNNdpB3I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUtj8IoW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i70SHgcT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUtj8IoW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i70SHgcT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUtj8IoW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i70SHgcT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUtj8IoW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i70SHgcT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A35AA3F8ED;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=HUtj8IoWsOwo/attLdC4UcmKD4HtbndQZYTS7fZBHo0KwodaHnCqBxznjievlQ4UQJm89Z
	Lg0YPyK4RuNYs8230r3At73PGZUj43N6khysk9sPk1kypegI5rF5mAdnKgHIZt7s9+3yp8
	/LD9SUcTczbjbShDqyJXg/mzfA/ruYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=i70SHgcTNUJ7NMAjo96n8YgGmzVbHFUF6jPlmdsdNnCuSZlw/33zd7Kq6bFyPqdgt7A+Qu
	zYwNIB6TLNM/qYCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=HUtj8IoWsOwo/attLdC4UcmKD4HtbndQZYTS7fZBHo0KwodaHnCqBxznjievlQ4UQJm89Z
	Lg0YPyK4RuNYs8230r3At73PGZUj43N6khysk9sPk1kypegI5rF5mAdnKgHIZt7s9+3yp8
	/LD9SUcTczbjbShDqyJXg/mzfA/ruYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=i70SHgcTNUJ7NMAjo96n8YgGmzVbHFUF6jPlmdsdNnCuSZlw/33zd7Kq6bFyPqdgt7A+Qu
	zYwNIB6TLNM/qYCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96B373EA69;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hj3EJEC5pmnDFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 51FE1A0A0B; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 01/32] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Tue,  3 Mar 2026 11:33:50 +0100
Message-ID: <20260303103406.4355-33-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkeVzC4YbQ9T0Z4TeuYJcjZHgbt9+t9ryNIR 3V2CHcYpCeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5HgAKCRCcnaoHP2RA 2ca8CACs8G3pdHr9kW9Q+TKPXSn2npqd4bM2vAfsVoOQ/P2gyi0t8/O8mkzMj/CohCUiyH0qNTc 4TySVlIGRafg5gnSttomZAd3lIx9qrRY2p9FsV2YnjfMGJJKOjm4MGnc7uCut4GOf5H4MUpHrfM kY5/VzZQy7/HyZE435Tg5wuWLOXdMNY1sA9wd2bbSwPO7ZB6kDU1huFJDvu6ik/KYUxgbFeZYzR WO3GlipQ/dmUqVw4HjTWkPA+Xifi2VZ/SnisOeUBk51Es0ro0swV0JsRiTQ7L1nlj5s/f4507Ez +tW0uBn0ZVAmxI2PNJ3LiduM4x+XORJJYCHHL+YkYc/USDl2
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,ZenIV.linux.org.uk,vger.kernel.org,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3cc5fb01afa1..ce88602b0d57 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
-	} else
+	} else {
+		sync_mapping_buffers(inode->i_mapping);
 		fat_free_eofblocks(inode);
+	}
 
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0

