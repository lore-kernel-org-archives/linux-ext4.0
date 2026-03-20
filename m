Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B74C361DDB
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014132; cv=none; b=iAUavMZA0LZgR8p3nJLsq9zyM3TWdOhVj4Mz6FLBjwYkXuZBU9TosFiUKmaMiW5fOWEsoN/xkPj06vNxEzJqkPCzRCIyQ/4en+L3PUdbLc6o5U/BtbFExgFLvX1HbJb31PhbpToYKB/z60lzQoJJanlwEHu8yFwvwbGaR+GB93A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014132; c=relaxed/simple;
	bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS7DT6WJWy0aBVc4WKrqfPERdvqZvq6w4cFKPhJ0arBZgPQI3UzqC3mcCbcSUajhjIOCjGud40ebkRubE6Nf11Wq4HXf8EsO9TstfGV5Bf+4q+usjwOBmE670qCdiRe9N5ii1koF0PHS9FbFXOQVWuHfJ7SG5/i88u8Lkn0x9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06EFA5BDFE;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC94A4281B;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qzzEOZhOvWlXCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 89E72A0B4E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 07/41] exfat: Drop pointless invalidate_inode_buffers() call
Date: Fri, 20 Mar 2026 14:41:02 +0100
Message-ID: <20260320134100.20731-48-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=jack@suse.cz; h=from:subject; bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5yasYuc/oVgtRi89eW1ehL7CYhut2nO3al3 BpSIY98L/yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcgAKCRCcnaoHP2RA 2ScCCADbyrlhHTrHVqfs8gou1Q7ALFFXsr0JYh5zHoYogEoF8DE9Jqiu+H9gM0qHvlWQ+tWtR7C DjHQgemIsDeSwPHX2oxkDCVkG5ZuMGRNDrUFlJPugTxja6qVh3isu2iwEdWeHY0EpJ5hvzAwN+q P1gmgEVBbIeMufNmfZqbea7Fh0/PR/rZ/aHEdSnkspmb8AcDn8J4sMLvECHEgYjaALc5MPLVULv y0l+2j8RCTGdgX6yqc5U660NN4lMD/sm5if6lkj0YKB8iBhH7OyMqBlOqV3lpPA/DlIh9LB/isk LlxrEz/xx1EO+3iS+2yRxEWzQlm6WcWD3SuExCvDxebUTted
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 06EFA5BDFE
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

EXFAT never calls mark_buffer_dirty_inode() and thus
invalidate_inode_buffers() never has anything to evict. Drop the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/exfat/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2fb2d2d5d503..04559b88482d 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -695,7 +695,6 @@ void exfat_evict_inode(struct inode *inode)
 		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	exfat_cache_inval_inode(inode);
 	exfat_unhash_inode(inode);
-- 
2.51.0

