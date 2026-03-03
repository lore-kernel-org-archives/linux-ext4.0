Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2239890C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534126; cv=none; b=fsyJU+rr9sXSCuNddvyh3OXixgdsMybIz/j1NxjmbJUjAGzGbkc9c/QHt0bd+jcY+wpEGCQkhY6OQrBlzSkKmA5HQmcm73puI/eAwyyQAJAg5L1fVSYDPyOj+wnoRQaFjbSfysTX2XtRM7eGUndW9AK+w5ZmKKD/eHILqxyX2zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534126; c=relaxed/simple;
	bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHDiF9ad/0Giv3C8ESEKd0pQyuyEgEOUdKUk5GB0aWLZGxNSt+93tYsWr5swx+s9p5e6Aj10fdAJ/n2B6jrYqBjTlf06ctxTsniJV/pLYOd7PPUUs90bz5d6fb9pPkL/oOSHi7zh9tKSDVohZggHaSbp+KbcOSuJiiFZ9WzHenM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E4983F924;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 243B83EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EyzXCEW5pml/FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C00ADA0ADA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 15/32] fs: Drop osync_buffers_list()
Date: Tue,  3 Mar 2026 11:34:04 +0100
Message-ID: <20260303103406.4355-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2464; i=jack@suse.cz; h=from:subject; bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkq3a5/P0oUM3bDlZR3EzEk1N3kzljC9F9eH VlmIijoJKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5KgAKCRCcnaoHP2RA 2YEWCADXaZjDgnEzRya8WwzOnAHZ4qj1cJhsps4vNe6LN2OzqXU9hRA0KCwyN1q3267mhf/Gtn8 cQRRvJrD7nTw1RB+acUok2EmA3WYOJGhPuSPpbrTyUgR+Z9yVqPuzZGop3fq7MfcFurZB3iLUx5 YTSQW0lx6H+QxRAeT1WU7SG9nAQn5ZNJpUFSpu49/+AaVQ4AQdrOmYLSY/z/z8uk+dbKs90w7JO 2Q67MYypYmHj19Hq5sjvXf30jcBQ+l4AlZSUrv4jJpk6eoN/Sq/dyC+CJT0RmslIUQc5Vg5w9vS U3/whdj22wIw13yayC2IA5mBBn6ZOi3aVH65TNsw32MyfLGR
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 2E4983F924
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

The function only waits for already locked buffers in the list of
metadata bhs. fsync_buffers_list() has just waited for all outstanding
IO on buffers so this isn't adding anything useful. Comment in front of
fsync_buffers_list() mentions concerns about buffers being moved out
from tmp list back to mappings i_private_list but these days
mark_buffer_dirty_inode() doesn't touch inodes with b_assoc_map set so
that cannot happen. Just delete the stale code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 43 ++-----------------------------------------
 1 file changed, 2 insertions(+), 41 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c85ccfb1a4ec..1c0e7c81a38b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -526,41 +526,6 @@ int inode_has_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_has_buffers);
 
-/*
- * osync is designed to support O_SYNC io.  It waits synchronously for
- * all already-submitted IO to complete, but does not queue any new
- * writes to the disk.
- *
- * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
- * as you dirty the buffers, and then use osync_inode_buffers to wait for
- * completion.  Any other dirty buffers which are not yet queued for
- * write will not be flushed to disk by the osync.
- */
-static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct list_head *p;
-	int err = 0;
-
-	spin_lock(lock);
-repeat:
-	list_for_each_prev(p, list) {
-		bh = BH_ENTRY(p);
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(lock);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				err = -EIO;
-			brelse(bh);
-			spin_lock(lock);
-			goto repeat;
-		}
-	}
-	spin_unlock(lock);
-	return err;
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
@@ -777,7 +742,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct address_space *mapping;
-	int err = 0, err2;
+	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
@@ -844,11 +809,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	}
 	
 	spin_unlock(lock);
-	err2 = osync_buffers_list(lock, list);
-	if (err)
-		return err;
-	else
-		return err2;
+	return err;
 }
 
 /*
-- 
2.51.0

