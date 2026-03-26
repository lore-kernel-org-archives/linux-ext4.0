Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A53C3434
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518972; cv=none; b=OhdX950LTflkJP6ow6ra46l+/g8MmfBDZnce/rIHzewbKFLhXiOlxJd6VUR26jahoolrhGEg90yuzeAWli1pFJFXK5pKR4kTLydfT3nlDR3xXUBfOHn4ycNzvu0Kgf4OvfwMAGY6LzikWfQpw0tx6I84hU4VP9AlE7EnQLn/xOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518972; c=relaxed/simple;
	bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1CcxIAnPWQp/4sSI4Azt7otL87Oi/V3AdpHlsDLfV29I8CZvk7k6reJyz46tkgZeQqh+lEVtCoC1sVlUM0jIVqnZAk2UMEC0/+HWsHUyGfe2URBVkqehPo2VQO20112XqDSq/YbngMq3E9gn8uuff0o6W9zM9+LNa7u6Odb/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y/qbVuo2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UkAt+b1u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y/qbVuo2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UkAt+b1u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y/qbVuo2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UkAt+b1u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y/qbVuo2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UkAt+b1u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 453AF5BD9F;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=Y/qbVuo2TsF3t6N5oYbim5B01JbYhSomLALeBMuonfj8yAoQ5W21Nwd0RU62zk2BHsNrJl
	clPZxzL+d1Jz6jkedXcM8NTKEb6mXi+jMyVVpDok2Ns5iUtYcCi9w1h1moZCiX2TSzTjC+
	b0QaOstfiKyakh+RWHi+1XYl8+5KCGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=UkAt+b1u0bDeTbgAVIpagAoJVUef24MK3jBjPJMcxxY/HOm07BYbsu6rgrjo/q9DNLX5lE
	RYTcNZyUV6BK7BCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y/qbVuo2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UkAt+b1u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=Y/qbVuo2TsF3t6N5oYbim5B01JbYhSomLALeBMuonfj8yAoQ5W21Nwd0RU62zk2BHsNrJl
	clPZxzL+d1Jz6jkedXcM8NTKEb6mXi+jMyVVpDok2Ns5iUtYcCi9w1h1moZCiX2TSzTjC+
	b0QaOstfiKyakh+RWHi+1XYl8+5KCGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=UkAt+b1u0bDeTbgAVIpagAoJVUef24MK3jBjPJMcxxY/HOm07BYbsu6rgrjo/q9DNLX5lE
	RYTcNZyUV6BK7BCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B89C4A0A3;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bsuGDnECxWnKYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF427A0C18; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 15/42] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Thu, 26 Mar 2026 10:54:09 +0100
Message-ID: <20260326095354.16340-57-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI+VzC4YbQ9T0Z4TeuYJcjZHgbt9+t9ryNIR 3V2CHcYpCeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPgAKCRCcnaoHP2RA 2YhHB/4vxvzXM8PjhQqlguQjvSfaMmwzwoRYgpnjUCjnzuSo/IYWrynUOLoOBVbC6S+PmQlJrE6 b5Pf4/wgb0FqVvw+X8juDydr95IBx0SAUZIu/hLCtwg6ntBeVnOoPIK8VNjqvdLA8gbHD5hKx8m 55XIOxMDGEFndABvSDT46kom2h2VpLxDa3rfAFZqBkA5aIvgD6+DPMNqkmZ6uUTdcfAmTi7mZ2U vq0CnYnmS6nw45pqdR5pdwlThY9zPP5VufYNmTOLY+IrocHv7RvMH7j9LJN8GztjhQOGqOYH+7i Tbv32pmQaeyN8kAAxNB/B+eVSRTNsG7HbRxkj05MHoQpW1PT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
X-Rspamd-Queue-Id: 453AF5BD9F
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

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

