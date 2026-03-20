Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF34317175
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014154; cv=none; b=uJR20YRDd6nYwgzpi6OaQHLqkvQwBdSeMCoyzZ5/fmTDCexA4oVA6Ln5t3Yp147o/mGyHQhFj1ldtnntf0aRBwyezAilbl/Fa3V0VLCRK4+WXa9GnKXCU/rlTwEwlcd1c/ydPTmV2ujORR2EanmhlViKrYHHp0lGXSed4QJ9KAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014154; c=relaxed/simple;
	bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRhBoKB/8tPZHN2ZR88K2+JxjDn8veRJoK1erprH5dAeSuH5iPYQO9knYHcJOhmmqXbiU1MkUMm2MmmzlejRb1Rgi03pMsvpCWLTgRkzi0gKyG3RcO1xilCD3bjzLkEt48GIBbkMDR+xakc7yxoi4vLRd1L46OLof4/r6V2YxLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C70B4D294;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5069B4281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PZagE5lOvWlyCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E1DD0A0B57; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 18/41] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
Date: Fri, 20 Mar 2026 14:41:13 +0100
Message-ID: <20260320134100.20731-59-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jack@suse.cz; h=from:subject; bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU57ZOEr4SoMR6litD6xJZ9vyOu7Qv8MRlaIP MceIDomSlWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OewAKCRCcnaoHP2RA 2c3sB/9m9TZqiM8eDGPMcq+rKM3PXafvjHga/QNDB8hTrqSEQ/3iD+JOV9tZLe42768TP3T60aL 2pZcZwDnO0mBm+nwL5UJjVRAYp0202vqciT738fNOr2J0/GmCW2vPnvXsr8GsKQQKHCOGbKH8jZ FdoX4qubiKQqfCSpctN1L2bhSthGpjttQX9HiQmhVvqhymLnTXV+IL9Bv34LSce19IyFVpB5Qul i/i6BtWdCZZy/lbeMeC87I7PZ0imM/vCTKmYlBVBQeR4tEVIZMwPbKyqUzAdUDx9Pz7gXOVGNAX I3uIuyIPKMrTNXEaRaPgWMBM6X3jaW0TEa9x9zVTFaqYTIzK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 5C70B4D294
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9da02f5cb6cd..e0e50a9dbe9c 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -187,6 +187,8 @@ static void bfs_evict_inode(struct inode *inode)
 	dprintf("ino=%08lx\n", ino);
 
 	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_nlink)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0

