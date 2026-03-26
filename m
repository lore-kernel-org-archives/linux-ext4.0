Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE6372EC8
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518991; cv=none; b=nV0POJ+bBvfjeC76z4lWq5eKpT8cnPrxr14GpMYoECcAiGS+ksZp3IT2HAg5NmRscxoZSlQH0fX8cZzuOgftXuCJJau6WBEAWcjOPXv8G7dJDS8gdLt8C8ws+7qHEnAPURGq0B34lfIpVk/lEfw3H7XebKSqYkfTmKPnbDgtGH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518991; c=relaxed/simple;
	bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu7rdr1zeHZ5AoNCfvDEIhM64k3GYDUZej5uIeUG06Ps4f2VWCblI8xsRfDeL+Ba7ZWOaTeSW9WOUiVOis3RPuG7B/RV82sWQwPD0HYbY/fWp3jNKUfnQuXo70Zl0siDkeH7UdAHUtj+IpiWwSTTc8XJKw0jR0jxGdB4JW80Fd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VOuvWxZR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BhADEN1L; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VOuvWxZR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BhADEN1L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VOuvWxZR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BhADEN1L";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VOuvWxZR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BhADEN1L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B4615BDAA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=VOuvWxZRG2aG35N6U9VlmaHrKhH9qUL/5N+ExEyBhAhkQ53OE2Q4OlmKS9bd1Cz9S5SV9o
	ewEop/lz9d3R6bzgpnmd70f7V37cfCvGbNUy3+793J+sHILeHapjugmjCdwA5BUIUtENxY
	Bjn3euhuialGvxtAFOTQ95ArFmprffY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=BhADEN1LXwRg7fM+KpfWFmUxoKgWyXbDmnQwXEr7aUSpjGzWHl4zXO305Ip1iQQwVihS0r
	a5iQp52EXFv80eBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=VOuvWxZRG2aG35N6U9VlmaHrKhH9qUL/5N+ExEyBhAhkQ53OE2Q4OlmKS9bd1Cz9S5SV9o
	ewEop/lz9d3R6bzgpnmd70f7V37cfCvGbNUy3+793J+sHILeHapjugmjCdwA5BUIUtENxY
	Bjn3euhuialGvxtAFOTQ95ArFmprffY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=BhADEN1LXwRg7fM+KpfWFmUxoKgWyXbDmnQwXEr7aUSpjGzWHl4zXO305Ip1iQQwVihS0r
	a5iQp52EXFv80eBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 429CB4A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /wVAEHUCxWnTYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1707DA0C63; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 18/42] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
Date: Thu, 26 Mar 2026 10:54:12 +0100
Message-ID: <20260326095354.16340-60-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=jack@suse.cz; h=from:subject; bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJBydADQX+7VdRDW1mPf110GpSWmRUvbEo7O PCx4Adt/5KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQQAKCRCcnaoHP2RA 2SzXCADo5s7TD0SK8AYz5IGC1RWjgKbeLJKPzuVl8ZPcRhzaiD8CXzkLg9H0naFpr1l7Vcd2gzx mo6xBYl1ei3xwdRuFjSaWpLxRs6xa8PI0tPjctU+9th1cgupd+Il5Z2KRk8mJpyRo7/nUcHBfmj Dt9gie8MjdqNdZlM4WAQoQsMt6Jy5X2tx1sNHvdQVRkv0O8Ek1yUtAkJSv9e1unlGSLPLw3OlMa g2L+Xyhsi1wmEP+zDLRYvDwOd1vxZQ+uL2IVIFEFig+bcnpnNd+cTMxHVVpndqjTYt/BNkV4/ko pOUPI5etCG56Ynqua43GQc/2aVdcsdYIjwETHas9+omx7+Et
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
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

