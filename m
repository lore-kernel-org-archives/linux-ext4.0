Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDD7299920
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014143; cv=none; b=ItWqOSmWwdDzAx+lM2OsV7477c8aHQIUGb0WjguQFlE8NNZFVRfSadEWSnmUbw6PeNnvrlp1Fzw2SssPwVELj3mhkz8kVrFOBZt1GUqBDin7qofY7JmPp3mi4stj4MdRm5ojMuKaTaIWP/8P4oV3k1ktu0p5wWjxlyRPyzROLko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014143; c=relaxed/simple;
	bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuC9ASXK1wayZgBEiVywF7DhSRx4eyuQhAky6ZUN/SmBkUxBuBRkC80uTVT4UoDk71pavQT8zKpRRCTx4n4izpAo2QrdP5v37nlg3TdTmWyLF8QCFpdlW+x0Bun77EcK3ymmi5GKdYokDtmW89R5UK0/raDvihh1Y6n0c5v7XkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 178E15BE03;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C7284281E;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eZcAA5lOvWliCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B9EA9A0AFD; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 13/41] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Fri, 20 Mar 2026 14:41:08 +0100
Message-ID: <20260320134100.20731-54-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+pWHG+xI3GLr71bh+3qG6ombcmxvv7+uXa/s4V5ax lEusUS9k9GYhYGRg0FWTJFldeRF7WvzjLq2hmrIwAxiZQKZwsDFKQATeTGZg2Gjpe7+OC4XV1km B7M/sic+/DrfKVI4vT/xvrBtS6GArr5H88MXtgFT5oT+EEzN91z9xEog6OKXP0yq+6/MfuJuKeD Eto9z1qqyslu71rgIJptxfS7st6nXsWdSUDh771Kg7+ukIK4HL99wGIoLVXY8dSvVifCZvNgnzt BVUzPlg2Fk6HSN5rBNyrqubzX5jp7mlVO9ksnBbjs9xah+qc3lvzFV8n251m9nVhl/3SIsIBv+i +ndUcU5ekevaS+p3Ge16X3eTiWTWd9erY7eXel3/sc973xHH+4u27cJ/pEXWfnufG8RDa2c4TZr vrXyas5nW2Q+Nv7K/PhWrX/epU2/NvNc1sp9JeSm8novAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)]
X-Rspamd-Queue-Id: 178E15BE03
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
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

