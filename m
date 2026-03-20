Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C53AF661
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014159; cv=none; b=HwTuCk0lsmyhVIjGLoXkoJsGl0TyZildqvVvmYBhANxjtpTYDflUr8ovfEwrIjHeTY9mStsh3VXiBNA7lk72DkKtLM7NcuzOIPruzVxydq/u/UrIhe910lnB2oqgK7s4auPV5xKhjuYSsrskgoEtk2GCbE2vVpkyzybC9PlFVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014159; c=relaxed/simple;
	bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obl4WXpWU4sOdcU+yrIw8a6JbAv4TQRsJHH8aFBXyhgHLDfJwyYt55pFbaGtRcfxIIQOZdiMx8qDSnmWncYEzqEac3pjZ/AzySIqIeJ3N8BGDa8IKyEPcvcLnpDOqqIfkOg4tek99RYPS8++vdjQMR0EFHqytH2tv8gv9QN47Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=shrhiTU6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d+1AGxDR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=shrhiTU6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d+1AGxDR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="shrhiTU6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d+1AGxDR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="shrhiTU6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d+1AGxDR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 588A24D288;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=shrhiTU6j5Tx0HiWP0P++KcPYqplbpKjvY4os/kfaJnnie2g9d+IpZ1xRDO3Ff9YMVlrNG
	VebHX3w0dRMjuC2AaxrXzo+iJxNAUWiO2gPZ89WphEhaYdnKvJdyYR+0hKnwGlCooq67Tp
	zdWMjSAmoXvJS1NaIDH9PF/zW52b39A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=d+1AGxDR7HVptYrlZfyZW0fQ+95b4dLEmCfTxO0oGZMDO7MaVVsdMhNSftGjnrbzSg8/dJ
	Nt1vcH8sXWc3k6DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=shrhiTU6j5Tx0HiWP0P++KcPYqplbpKjvY4os/kfaJnnie2g9d+IpZ1xRDO3Ff9YMVlrNG
	VebHX3w0dRMjuC2AaxrXzo+iJxNAUWiO2gPZ89WphEhaYdnKvJdyYR+0hKnwGlCooq67Tp
	zdWMjSAmoXvJS1NaIDH9PF/zW52b39A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=d+1AGxDR7HVptYrlZfyZW0fQ+95b4dLEmCfTxO0oGZMDO7MaVVsdMhNSftGjnrbzSg8/dJ
	Nt1vcH8sXWc3k6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F9E542817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WPZuE5lOvWlwCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1011A0B54; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 16/41] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
Date: Fri, 20 Mar 2026 14:41:11 +0100
Message-ID: <20260320134100.20731-57-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=jack@suse.cz; h=from:subject; bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU55ydADQX+7VdRDW1mPf110GpSWmRUvbEo7O PCx4Adt/5KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OeQAKCRCcnaoHP2RA 2WT9CADEmXI5rthiKgABVX3c19nJTjLphSGV6BADWmE2kK6bQKwOeDpesrj692xhQP7GwNbQhYQ PtUccviJY4fYPXcWKWq9zoNgDgyEQRQJ/DH6UhVss5pR/wDQBkbfAIiZSE5PhwWGa1MHi1KvGnt DQlw8Z43lFFcdP2L1JyIPan404WZBV738liDi50SohEMbiI8j1j29QZgaoKYvHrf34CJ8VUhEGs pOtNCle+dOF3GK1u37p6HlB9SgZR4GuZYrVhj05PrwFhrGhdKJjhlUTR/DE99rbd9zDFrzrbSPU fX1sWaEfwAnD4CLVEU1W68PCG+NohJQm0Aosfm1LdeAexz5l
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a124..fb91c61aa6d6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -94,8 +94,9 @@ void ext2_evict_inode(struct inode * inode)
 		if (inode->i_blocks)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
-
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0

